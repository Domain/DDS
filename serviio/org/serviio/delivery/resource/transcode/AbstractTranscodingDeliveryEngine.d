module org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryEngine;

import java.lang;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.serviio.config.Configuration;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryContainer;
import org.serviio.delivery.DeliveryContext;
import org.serviio.delivery.DeliveryListener;
import org.serviio.delivery.MediaFormatProfileResource;
import org.serviio.delivery.StreamDeliveryContainer;
import org.serviio.delivery.resource.AbstractDeliveryEngine;
import org.serviio.delivery.subtitles.HardSubs;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.SubtitleCodec;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.library.entities.MediaItem;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.OnlineContentType;
import org.serviio.profile.Profile;
import org.serviio.util.FileUtils;
import org.serviio.util.StringUtils;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.resource.transcode.TranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.serviio.delivery.resource.transcode.FileBasedTranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.SegmentBasedTranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.LiveSegmentBasedTranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.StreamBasedTranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.StreamDescriptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractTranscodingDeliveryEngine(RI : MediaFormatProfileResource, MI : MediaItem) : AbstractDeliveryEngine!(RI, MI), DeliveryListener
{
    private static immutable String TRANSCODING_SUBFOLDER_NAME = "Serviio";
    public static immutable String TRANSCODED_FILE_EXTENSION = "stf";
    private static Map!(Client, TranscodingJobListener) transcodeJobs;
    private static TranscodingDeliveryStrategy!(File) fileBasedStrategy;
    private static TranscodingDeliveryStrategy!(File) segmentBasedStrategy;
    private static TranscodingDeliveryStrategy!(File) liveSegmentBasedStrategy;
    private static TranscodingDeliveryStrategy!(OutputStream) streamBasedStrategy;
    private static Logger log;

    static this()
    {
        transcodeJobs = Collections.synchronizedMap(new HashMap!(Client, TranscodingJobListener)());
        fileBasedStrategy = new FileBasedTranscodingDeliveryStrategy();
        segmentBasedStrategy = new SegmentBasedTranscodingDeliveryStrategy();
        liveSegmentBasedStrategy = new LiveSegmentBasedTranscodingDeliveryStrategy();
        streamBasedStrategy = new StreamBasedTranscodingDeliveryStrategy();
        log = LoggerFactory.getLogger!(AbstractTranscodingDeliveryEngine);
    }

    public static void cleanupTranscodingEngine()
    {
        log.info("Cleaning transcode engine and its data");
        foreach (TranscodingJobListener listener ; transcodeJobs.values()) {
            listener.releaseResources();
        }
        deleteTranscodeFiles();
    }

    public static File getTranscodingFolder()
    {
        File f = new File(Configuration.getTranscodingFolder(), "Serviio");
        return f;
    }

    public void deliveryComplete(Client client)
    {
        synchronized (transcodeJobs)
        {
            transcodeJobs.remove(client);
        }
    }

    override protected DeliveryContainer retrieveTranscodedResource(MI mediaItem, MediaFormatProfile selectedVersion, QualityType selectedQuality, Double timeOffsetInSeconds, Double durationInSeconds, Client client)
    {
        Map!(QualityType, TranscodingDefinition) trDefs = getMatchingTranscodingDefinitions(mediaItem, client.getRendererProfile(), true);
        TranscodingDefinition trDef = cast(TranscodingDefinition)trDefs.get(selectedQuality);
        if (trDef !is null)
        {
            String timeOffset = timeOffsetInSeconds !is null ? String_format("-%s-%s", cast(Object[])[ timeOffsetInSeconds, Double.valueOf(durationInSeconds !is null ? durationInSeconds.doubleValue() : 0.0) ]) : "";
            String subtitle = mediaItem.getDeliveryContext().getHardsubsSubtitlesFile() !is null ? String_format("-%s", cast(Object[])[ mediaItem.getDeliveryContext().getHardsubsSubtitlesFile().getIdentifier() ]) : "";
            String transcodingIdentifier = String_format("transcoding-temp-%s-%s-%s%s%s.%s", cast(Object[])[ mediaItem.getId().toString(), client.getRendererProfile().getId().toString(), selectedQuality.toString(), timeOffset, subtitle, "stf" ]);

            TranscodingJobListener jobListener = startTranscodeJob(mediaItem, transcodingIdentifier, timeOffsetInSeconds, durationInSeconds, client, trDef, selectedVersion);
            StreamDescriptor stream = null;
            try
            {
                stream = getDeliveryStrategy(mediaItem, selectedVersion).createInputStream(jobListener, mediaItem.getId(), trDef, client, this);
            }
            catch (IOException e)
            {
                jobListener.releaseResources();

                deliveryComplete(client);
                log.debug_(String_format("Removing transcoding listener with id %s", cast(Object[])[ transcodingIdentifier ]));
                throw e;
            }
            LinkedHashMap!(QualityType, List!(RI)) transcodedMediaInfos = retrieveTranscodedMediaInfo(mediaItem, client.getRendererProfile(), stream.getFileSize());
            RI transcodedMediaInfo = findMediaInfoForFileProfile(cast(Collection!RI)transcodedMediaInfos.get(selectedQuality), selectedVersion);
            return new StreamDeliveryContainer(new BufferedInputStream(stream.getStream(), 65536), transcodedMediaInfo, jobListener);
        }
        throw new IOException(String_format("Cannot find transcoding definition for %s quality", cast(Object[])[ selectedQuality.toString() ]));
    }

    override protected RI retrieveTranscodedMediaInfoForVersion(MI mediaItem, MediaFormatProfile selectedVersion, QualityType selectedQuality, Profile rendererProfile)
    {
        log.debug_(String_format("Getting media info for transcoded version of file %s", cast(Object[])[ mediaItem.getFileName() ]));
        LinkedHashMap!(QualityType, List!(RI)) mediaInfos = retrieveTranscodedMediaInfo(mediaItem, rendererProfile, null);
        return findMediaInfoForFileProfile(cast(Collection!RI)mediaInfos.get(selectedQuality), selectedVersion);
    }

    override protected bool fileCanBeTranscoded(MI mediaItem, Profile rendererProfile)
    {
        if (((mediaItem.isLocalMedia()) && ((Configuration.isTranscodingEnabled()) || (rendererProfile.isAlwaysEnableTranscoding())) && (rendererProfile.hasAnyTranscodingDefinitions())) || ((!mediaItem.isLocalMedia()) && (rendererProfile.hasAnyOnlineTranscodingDefinitions())) || (hardSubsTranscodingConfigured(mediaItem, rendererProfile))) {
            if (getMatchingTranscodingDefinitions(mediaItem, rendererProfile, false).size() > 0) {
                return true;
            }
        }
        return false;
    }

    override protected bool fileWillBeTranscoded(MI mediaItem, MediaFormatProfile selectedVersion, QualityType selectedQuality, Profile rendererProfile)
    {
        return (fileCanBeTranscoded(mediaItem, rendererProfile)) && (getMatchingTranscodingDefinitions(mediaItem, rendererProfile, false).get(selectedQuality) !is null);
    }

    protected OnlineContentType getOnlineContentType(MediaItem mediaItem)
    {
        if (mediaItem.isLocalMedia()) {
            return OnlineContentType.ANY;
        }
        if (mediaItem.isLive()) {
            return OnlineContentType.LIVE;
        }
        return OnlineContentType.VOD;
    }

    private void prepareClientStream(Client client, String transcodingIdentifier, TranscodingDefinition trDef)
    {
        if (transcodeJobs.containsKey(client))
        {
            TranscodingJobListener existingJobListener = cast(TranscodingJobListener)transcodeJobs.get(client);

            bool closeStream = false;
            if (trDef.getTranscodingConfiguration().isKeepStreamOpen())
            {
                if ((existingJobListener !is null) && (!existingJobListener.getTranscodingIdentifier().equals(transcodingIdentifier))) {
                    if (getCountOfListenerUsers(existingJobListener) <= 1)
                    {
                        log.debug_(String_format("No other client uses transcoding job of file '%s', will stop the job", cast(Object[])[ existingJobListener.getTranscodingIdentifier() ]));
                        closeStream = true;
                    }
                    else
                    {
                        log.debug_(String_format("Removing the client from transcoding job of file '%s'", cast(Object[])[ existingJobListener.getTranscodingIdentifier() ]));

                        existingJobListener.closeStream(client);
                    }
                }
            }
            else {
                closeStream = true;
            }
            if (closeStream)
            {
                log.debug_(String_format("Stopping previous transcoding job of file '%s'", cast(Object[])[ existingJobListener.getTranscodingIdentifier() ]));

                existingJobListener.releaseResources();

                deliveryComplete(client);
            }
        }
    }

    private int getCountOfListenerUsers(TranscodingJobListener listener)
    {
        int c = 0;
        foreach (TranscodingJobListener l ; transcodeJobs.values()) {
            if (l.getTranscodingIdentifier().equals(listener.getTranscodingIdentifier())) {
                c++;
            }
        }
        return c;
    }

    private /*synchronized*/ TranscodingJobListener startTranscodeJob(MI mediaItem, String transcodingIdentifier, Double timeOffsetInSeconds, Double durationInSeconds, Client client, TranscodingDefinition trDef, MediaFormatProfile selectedVersion)
    {
        prepareClientStream(client, transcodingIdentifier, trDef);

        TranscodingJobListener newListener = null;

        Collection!(TranscodingJobListener) availableListeners = findExistingJobListeners(client, mediaItem.isLive(), trDef.getTranscodingConfiguration().isKeepStreamOpen());
        foreach (TranscodingJobListener listener ; availableListeners) {
            if (listener.getTranscodingIdentifier().equals(transcodingIdentifier))
            {
                log.debug_(String_format("A suitable transcoding job already exists, re-use it for client '%s'", cast(Object[])[ client ]));
                newListener = listener;
                break;
            }
        }
        if (newListener is null)
        {
            log.debug_(String_format("No suitable transcoding job exists yet, start one for client '%s'", cast(Object[])[ client ]));
            updateFeedUrl(mediaItem);
            newListener = getDeliveryStrategy(mediaItem, selectedVersion).invokeTranscoder(transcodingIdentifier, mediaItem, timeOffsetInSeconds, durationInSeconds, trDef, client, this);
        }
        registerJob(client, newListener);
        return newListener;
    }

    private void registerJob(Client client, TranscodingJobListener jobListener)
    {
        synchronized (transcodeJobs)
        {
            transcodeJobs.put(client, jobListener);
        }
    }

    private Collection!(TranscodingJobListener) findExistingJobListeners(Client client, bool liveStream, bool keepLiveStreamsOpen)
    {
        synchronized (transcodeJobs)
        {
            if (!liveStream) {
                return transcodeJobs.values();
            }
            if ((transcodeJobs.containsKey(client)) && (keepLiveStreamsOpen)) {
                return Collections.singleton(transcodeJobs.get(client));
            }
            return Collections.emptySet!(TranscodingJobListener)();
        }
    }

    private static void deleteTranscodeFiles()
    {
        File transcodeFolder = getTranscodingFolder();
        if ((transcodeFolder.exists()) && (transcodeFolder.isDirectory()))
        {
            log.debug_(String_format("Deleting temporary transcoded files from: %s", cast(Object[])[ transcodeFolder ]));
            File[] transcodedFiles = transcodeFolder.listFiles(new class() FilenameFilter {
                public bool accept(File dir, String name)
                {
                    String extension = FileUtils.getFileExtension(StringUtils.localeSafeToLowercase(name));
                    if ((extension.equals("stf")) || (/*SubtitleCodec.*/getAllSupportedExtensions().contains(extension))) {
                        return true;
                    }
                    return false;
                }
            });
            foreach (File f ; transcodedFiles)
            {
                bool result = FileUtils.deleteFileOrFolder(f);
                log.debug_(String_format("Deleted file %s: %s", cast(Object[])[ f, Boolean.valueOf(result) ]));
            }
        }
    }

    private TranscodingDeliveryStrategy!(Object) getDeliveryStrategy(MI mediaItem, MediaFormatProfile formatProfile)
    {
        if (formatProfile.isManifestFormat()) {
            return cast(TranscodingDeliveryStrategy!(Object))(mediaItem.isLive() ? liveSegmentBasedStrategy : segmentBasedStrategy);
        }
        return mediaItem.isLive() ? cast(TranscodingDeliveryStrategy!(Object))(streamBasedStrategy) : cast(TranscodingDeliveryStrategy!(Object))(fileBasedStrategy);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryEngine
* JD-Core Version:    0.7.0.1
*/