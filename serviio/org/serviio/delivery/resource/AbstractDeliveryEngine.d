module org.serviio.delivery.resource.AbstractDeliveryEngine;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import org.serviio.ApplicationSettings;
import org.serviio.config.Configuration;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryContainer;
import org.serviio.delivery.DeliveryContext;
import org.serviio.delivery.MediaFormatProfileResource;
import org.serviio.delivery.OnlineInputStream;
import org.serviio.delivery.StreamDeliveryContainer;
import org.serviio.delivery.resource.transcode.TranscodingConfiguration;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.serviio.delivery.subtitles.SubtitlesConfiguration;
import org.serviio.delivery.subtitles.SubtitlesReader;
import org.serviio.delivery.subtitles.SubtitlesService;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.MediaService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.AbstractUrlExtractor;
import org.serviio.library.online.ContentURLContainer;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.profile.DeliveryQuality;
import org.serviio.profile.DeliveryQuality.QualityType;
import org.serviio.profile.Profile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractDeliveryEngine(e, MI : MediaItem)
: DeliveryEngine!(RI, MI)
{
    protected final Logger log = LoggerFactory.getLogger(getClass());

    public static bool isHardSubsDelivered(DeliveryQuality quality, MediaItem mediaItem, Profile profile)
    {
        return findTranscodingForHardSubs(quality, mediaItem, profile, false) !is null;
    }

    public List!(RI) getMediaInfoForProfile(MI mediaItem, Profile rendererProfile)
    {
        this.log.debug_(String.format("Retrieving resource information for item %s and profile %s", cast(Object[])[ mediaItem.getId(), rendererProfile.getName() ]));
        Map!(DeliveryQuality.QualityType, List!(RI)) infos = new LinkedHashMap();
        try
        {
            LinkedHashMap!(DeliveryQuality.QualityType, List!(RI)) originalMediaInfos = retrieveOriginalMediaInfo(mediaItem, rendererProfile);
            if (originalMediaInfos !is null) {
                infos.putAll(originalMediaInfos);
            }
        }
        catch (UnsupportedDLNAMediaFileFormatException e) {}
        if (fileCanBeTranscoded(mediaItem, rendererProfile)) {
            infos.putAll(retrieveTranscodedMediaInfo(mediaItem, rendererProfile, null));
        }
        return flattenMediaInfoMap(infos);
    }

    public DeliveryContainer deliver(MI mediaItem, MediaFormatProfile selectedVersion, DeliveryQuality.QualityType selectedQuality, Double timeOffsetInSeconds, Double durationInSeconds, Client client)
    {
        this.log.debug_(String.format("Delivering item '%s' for client '%s'", cast(Object[])[ mediaItem.getId(), client ]));
        if (fileWillBeTranscoded(mediaItem, selectedVersion, selectedQuality, client.getRendererProfile()))
        {
            this.log.debug_(String.format("Delivering file '%s' using transcoding", cast(Object[])[ mediaItem.getFileName() ]));
            return retrieveTranscodedResource(mediaItem, selectedVersion, selectedQuality, timeOffsetInSeconds, durationInSeconds, client);
        }
        this.log.debug_(String.format("Delivering file '%s' in native format", cast(Object[])[ mediaItem.getFileName() ]));
        return retrieveOriginalFileContainer(mediaItem, selectedVersion, client);
    }

    public RI getMediaInfoForMediaItem(MI mediaItem, MediaFormatProfile selectedVersion, DeliveryQuality.QualityType selectedQuality, Profile rendererProfile)
    {
        this.log.debug_(String.format("Retrieving resource information for item %s, format %s and profile %s", cast(Object[])[ mediaItem.getId(), selectedVersion, rendererProfile.getName() ]));
        if (fileWillBeTranscoded(mediaItem, selectedVersion, selectedQuality, rendererProfile)) {
            return retrieveTranscodedMediaInfoForVersion(mediaItem, selectedVersion, selectedQuality, rendererProfile);
        }
        LinkedHashMap!(DeliveryQuality.QualityType, List!(RI)) originalMediaInfos = retrieveOriginalMediaInfo(mediaItem, rendererProfile);
        return findMediaInfoForFileProfile(cast(Collection)originalMediaInfos.get(DeliveryQuality.QualityType.ORIGINAL), selectedVersion);
    }

    protected abstract bool fileCanBeTranscoded(MI paramMI, Profile paramProfile);

    protected abstract bool fileWillBeTranscoded(MI paramMI, MediaFormatProfile paramMediaFormatProfile, DeliveryQuality.QualityType paramQualityType, Profile paramProfile);

    protected abstract LinkedHashMap!(DeliveryQuality.QualityType, List!(RI)) retrieveOriginalMediaInfo(MI paramMI, Profile paramProfile);

    protected abstract LinkedHashMap!(DeliveryQuality.QualityType, List!(RI)) retrieveTranscodedMediaInfo(MI paramMI, Profile paramProfile, Long paramLong);

    protected abstract RI retrieveTranscodedMediaInfoForVersion(MI paramMI, MediaFormatProfile paramMediaFormatProfile, DeliveryQuality.QualityType paramQualityType, Profile paramProfile);

    protected abstract TranscodingDefinition getMatchingTranscodingDefinition(List!(TranscodingDefinition) paramList, MI paramMI);

    protected abstract DeliveryContainer retrieveTranscodedResource(MI paramMI, MediaFormatProfile paramMediaFormatProfile, DeliveryQuality.QualityType paramQualityType, Double paramDouble1, Double paramDouble2, Client paramClient);

    protected Map!(DeliveryQuality.QualityType, TranscodingDefinition) getMatchingTranscodingDefinitions(MI mediaItem, Profile rendererProfile, bool delivering)
    {
        Map!(DeliveryQuality.QualityType, TranscodingDefinition) defs = new LinkedHashMap();
        TranscodingDefinition defaultDefinition = getMatchingTranscodingDefinitionForQuality(rendererProfile.getDefaultDeliveryQuality(), mediaItem, rendererProfile, delivering);
        if (defaultDefinition !is null) {
            defs.put(DeliveryQuality.QualityType.ORIGINAL, defaultDefinition);
        }
        foreach (DeliveryQuality altQuality ; rendererProfile.getAlternativeDeliveryQualities())
        {
            TranscodingDefinition def = getMatchingTranscodingDefinitionForQuality(altQuality, mediaItem, rendererProfile, delivering);
            if (def !is null) {
                defs.put(altQuality.getType(), def);
            }
        }
        return defs;
    }

    private TranscodingDefinition getMatchingTranscodingDefinitionForQuality(DeliveryQuality quality, MI mediaItem, Profile profile, bool delivering)
    {
        List!(TranscodingDefinition) localTDefs = quality.getTranscodingConfiguration() !is null ? quality.getTranscodingConfiguration().getDefinitions(mediaItem.getFileType()) : null;
        List!(TranscodingDefinition) onlineTDefs = quality.getOnlineTranscodingConfiguration() !is null ? quality.getOnlineTranscodingConfiguration().getDefinitions(mediaItem.getFileType()) : null;

        TranscodingDefinition result = findTranscodingForHardSubs(quality, mediaItem, profile, delivering);
        if ((result is null) && (!mediaItem.isLocalMedia())) {
            result = getMatchingTranscodingDefinition(onlineTDefs, mediaItem);
        }
        if (result is null) {
            result = getMatchingTranscodingDefinition(localTDefs, mediaItem);
        }
        return result;
    }

    private static TranscodingDefinition findTranscodingForHardSubs(DeliveryQuality quality, MediaItem mediaItem, Profile profile, bool delivering)
    {
        List!(TranscodingDefinition) hardSubsTDefs = quality.getHardSubsTranscodingConfiguration() !is null ? quality.getHardSubsTranscodingConfiguration().getDefinitions(mediaItem.getFileType()) : null;
        TranscodingDefinition result = null;
        if ((mediaItem.getFileType() == MediaFileType.VIDEO) && (hardSubsTranscodingConfigured(mediaItem, profile)))
        {
            SubtitlesReader subsReader = SubtitlesService.getHardSubs(cast(Video)mediaItem, profile);
            if (subsReader !is null)
            {
                result = new VideoDeliveryEngine().getMatchingTranscodingDefinition(hardSubsTDefs, cast(Video)mediaItem);
                if ((result !is null) && 
                    (delivering)) {
                        try
                        {
                            mediaItem.getDeliveryContext().setHardsubsSubtitlesFile(subsReader.getSubtitlesInOriginalFormat());
                        }
                        catch (IOException e)
                        {
                            LoggerFactory.getLogger!(AbstractDeliveryEngine).warn(e.getMessage());
                        }
                    }
            }
        }
        return result;
    }

    protected DeliveryContainer retrieveOriginalFileContainer(MI mediaItem, MediaFormatProfile selectedVersion, Client client)
    {
        InputStream fis = null;
        if (mediaItem.isLocalMedia())
        {
            File file = MediaService.getFile(mediaItem.getId());
            fis = new FileInputStream(file);
        }
        else
        {
            fis = getOnlineInputStream(mediaItem);
        }
        Map!(DeliveryQuality.QualityType, List!(RI)) mediaInfos = retrieveOriginalMediaInfo(mediaItem, client.getRendererProfile());
        return new StreamDeliveryContainer(fis, findMediaInfoForFileProfile(cast(Collection)mediaInfos.get(DeliveryQuality.QualityType.ORIGINAL), selectedVersion));
    }

    protected InputStream getOnlineInputStream(MI mediaItem)
    {
        try
        {
            int buffer = mediaItem.isLive() ? ApplicationSettings.getIntegerProperty("live_stream_buffer").intValue() : 1000000;
            return new BufferedInputStream(new OnlineInputStream(getOnlineItemURL(mediaItem), mediaItem.getFileSize(), !mediaItem.isLive()), buffer);
        }
        catch (MalformedURLException e)
        {
            throw new FileNotFoundException(String.format("Cannot retrieve online media item URL: %s", cast(Object[])[ e.getMessage() ]));
        }
    }

    protected RI findMediaInfoForFileProfile(Collection!(RI) infos, MediaFormatProfile selectedVersion)
    {
        foreach (RI mi ; infos) {
            if (mi.getFormatProfile() == selectedVersion) {
                return mi;
            }
        }
        throw new UnsupportedDLNAMediaFileFormatException(String.format("No media description available for required version: %s", cast(Object[])[ selectedVersion ]));
    }

    protected void updateFeedUrl(MI mediaItem)
    {
        if ((!mediaItem.isLocalMedia()) && (mediaItem.getOnlineResourcePlugin() !is null) && (mediaItem.getOnlineItem() !is null))
        {
            this.log.debug_("Extracting new URL for the expired feed item");
            try
            {
                ContentURLContainer urlContainer = AbstractUrlExtractor.extractItemUrl(mediaItem.getOnlineResourcePlugin(), mediaItem.getOnlineItem());
                if (urlContainer !is null)
                {
                    mediaItem.setFileName(urlContainer.getContentUrl());
                    this.log.debug_("Successfully set new URL for the feed item");
                }
                else
                {
                    this.log.warn("Cannot extract expired URL, using previous one which might not work");
                }
            }
            catch (Throwable t)
            {
                this.log.debug_(String.format("Unexpected error during url extractor plugin invocation (%s) for item %s: %s", cast(Object[])[ mediaItem.getOnlineResourcePlugin().getExtractorName(), mediaItem.getOnlineItem().getTitle(), t.getMessage() ]), t);
            }
        }
    }

    private URL getOnlineItemURL(MI mediaItem)
    {
        updateFeedUrl(mediaItem);
        return new URL(mediaItem.getFileName());
    }

    private List!(RI) flattenMediaInfoMap(Map!(DeliveryQuality.QualityType, List!(RI)) map)
    {
        List!(RI) result = new ArrayList();
        foreach (Map.Entry!(DeliveryQuality.QualityType, List!(RI)) entry ; map.entrySet()) {
            result.addAll(cast(Collection)entry.getValue());
        }
        return result;
    }

    protected static bool hardSubsTranscodingConfigured(MediaItem mediaItem, Profile rendererProfile)
    {
        return (mediaItem.getFileType() == MediaFileType.VIDEO) && (Configuration.isSubtitlesEnabled()) && (Configuration.isHardSubsEnabled()) && (rendererProfile.getSubtitlesConfiguration().isHardSubsSupported()) && (rendererProfile.hasAnyHardSubsTranscodingDefinitions());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.AbstractDeliveryEngine
* JD-Core Version:    0.7.0.1
*/