module org.serviio.upnp.service.contentdirectory.command.ResourceValuesBuilder;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import org.serviio.delivery.AudioMediaInfo;
import org.serviio.delivery.ImageMediaInfo;
import org.serviio.delivery.MediaResourceRetrievalStrategy;
import org.serviio.delivery.ResourceInfo;
import org.serviio.delivery.VideoMediaInfo;
import org.serviio.delivery.resource.AbstractDeliveryEngine;
import org.serviio.delivery.subtitles.SubtitlesConfiguration;
import org.serviio.delivery.subtitles.SubtitlesService;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.ThumbnailResolution;
import org.serviio.library.entities.CoverImage;
import org.serviio.library.entities.Image;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.MediaService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ProtocolInfo;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.util.MediaUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ResourceValuesBuilder
{
    private static final Logger log = LoggerFactory.getLogger!(ResourceValuesBuilder);

    public static final Resource generateSubtitlesResource(Video item, Profile rendererProfile)
    {
        bool hardSubsDelivered = AbstractDeliveryEngine.isHardSubsDelivered(rendererProfile.getDefaultDeliveryQuality(), item, rendererProfile);
        if (!hardSubsDelivered) {
            if (SubtitlesService.isSoftSubsAvailable(item, rendererProfile))
            {
                log.debug_(String.format("Softsubs for media item %s found, will be served as a resource", cast(Object[])[ item.getId() ]));
                try
                {
                    Resource subtitle = new Resource(Resource.ResourceType.SUBTITLE, item.getId(), null, null, null, null);
                    subtitle.setProtocolInfo(String.format("http-get:*:%s:*", cast(Object[])[ rendererProfile.getSubtitlesConfiguration().getSoftSubsMimeType() ]));
                    return subtitle;
                }
                catch (Exception e)
                {
                    log.debug_("Exception while building subtitle resource: " + e.getMessage(), e);
                    return null;
                }
            }
        }
        return null;
    }

    public static List!(Resource) buildResources(MediaItem entity, Profile rendererProfile)
    {
        List!(Resource) resources = new ArrayList();
        List/*!(? : ResourceInfo)*/ resourceInfos = MediaResourceRetrievalStrategy.getMediaInfoForAvailableProfiles(entity, rendererProfile);
        if (( cast(Image)entity !is null ))
        {
            if (resourceInfos.size() > 0)
            {
                Image image = cast(Image)entity;
                for (Iterator i = resourceInfos.iterator(); i.hasNext();)
                {
                    resourceInfo = cast(ResourceInfo)i.next();
                    imageMediaInfo = cast(ImageMediaInfo)resourceInfo;

                    Set!(String) protocolInfos = rendererProfile.getResourceProtocolInfo(imageMediaInfo.getFormatProfile()).getMediaProtocolInfo(resourceInfo.isTranscoded(), resourceInfo.isLive(), imageMediaInfo.getFormatProfile().getFileType(), false);

                    i = 0;
                    foreach (String protocolInfo ; protocolInfos)
                    {
                        Resource res = new Resource(Resource.ResourceType.MEDIA_ITEM, image.getId(), imageMediaInfo.getFormatProfile(), Integer.valueOf(i++), imageMediaInfo.getQuality(), Boolean.valueOf(resourceInfo.isTranscoded()));
                        res.setSize(imageMediaInfo.getFileSize());
                        res.setProtocolInfo(protocolInfo);
                        res.setColorDepth(image.getColorDepth());
                        if ((imageMediaInfo.getWidth() !is null) && (imageMediaInfo.getHeight() !is null)) {
                            res.setResolution(String.format("%sx%s", cast(Object[])[ imageMediaInfo.getWidth(), imageMediaInfo.getHeight() ]));
                        }
                        resources.add(res);
                    }
                }
                ResourceInfo resourceInfo;
                ImageMediaInfo imageMediaInfo;
                int i;
                Resource thumbnailResource = generateThumbnailResource(image, rendererProfile);
                if (thumbnailResource !is null) {
                    resources.add(1, thumbnailResource);
                }
            }
        }
        else if (( cast(MusicTrack)entity !is null ))
        {
            if (resourceInfos.size() > 0)
            {
                MusicTrack song = cast(MusicTrack)entity;
                for (Iterator i = resourceInfos.iterator(); i.hasNext();)
                {
                    resourceInfo = cast(ResourceInfo)i.next();
                    audioMediaInfo = cast(AudioMediaInfo)resourceInfo;

                    Set!(String) protocolInfos = rendererProfile.getResourceProtocolInfo(audioMediaInfo.getFormatProfile()).getMediaProtocolInfo(audioMediaInfo.isTranscoded(), resourceInfo.isLive(), audioMediaInfo.getFormatProfile().getFileType(), (song.getDuration() !is null) && (song.getDuration().intValue() > 0));

                    i = 0;
                    foreach (String protocolInfo ; protocolInfos)
                    {
                        Resource res = new Resource(Resource.ResourceType.MEDIA_ITEM, song.getId(), audioMediaInfo.getFormatProfile(), Integer.valueOf(i++), audioMediaInfo.getQuality(), Boolean.valueOf(resourceInfo.isTranscoded()));
                        res.setSize(audioMediaInfo.getFileSize());
                        res.setDuration(song.getDuration());
                        res.setProtocolInfo(protocolInfo);
                        res.setBitrate(MediaUtils.convertBitrateFromKbpsToByPS(audioMediaInfo.getBitrate()));
                        res.setSampleFrequency(audioMediaInfo.getSampleFrequency());
                        res.setNrAudioChannels(audioMediaInfo.getChannels());
                        resources.add(res);
                    }
                }
                ResourceInfo resourceInfo;
                AudioMediaInfo audioMediaInfo;
                int i;
                Resource thumbnailResource = generateThumbnailResource(song, rendererProfile);
                if (thumbnailResource !is null) {
                    resources.add(thumbnailResource);
                }
            }
        }
        else if ((( cast(Video)entity !is null )) && 
                 (resourceInfos.size() > 0))
        {
            Video video = cast(Video)entity;
            for (Iterator i = resourceInfos.iterator(); i.hasNext();)
            {
                resourceInfo = cast(ResourceInfo)i.next();
                videoMediaInfo = cast(VideoMediaInfo)resourceInfo;
                Set!(String) protocolInfos = rendererProfile.getResourceProtocolInfo(videoMediaInfo.getFormatProfile()).getMediaProtocolInfo(videoMediaInfo.isTranscoded(), resourceInfo.isLive(), videoMediaInfo.getFormatProfile().getFileType(), (video.getDuration() !is null) && (video.getDuration().intValue() > 0));

                i = 0;
                foreach (String protocolInfo ; protocolInfos)
                {
                    Resource.ResourceType resourceType = videoMediaInfo.getFormatProfile().isManifestFormat() ? Resource.ResourceType.MANIFEST : Resource.ResourceType.MEDIA_ITEM;
                    Resource res = new Resource(resourceType, video.getId(), videoMediaInfo.getFormatProfile(), Integer.valueOf(i++), videoMediaInfo.getQuality(), Boolean.valueOf(resourceInfo.isTranscoded()));
                    res.setSize(videoMediaInfo.getFileSize());
                    res.setDuration(video.getDuration());
                    res.setProtocolInfo(protocolInfo);
                    res.setBitrate(MediaUtils.convertBitrateFromKbpsToByPS(videoMediaInfo.getBitrate()));
                    if ((videoMediaInfo.getWidth() !is null) && (videoMediaInfo.getHeight() !is null)) {
                        res.setResolution(String.format("%sx%s", cast(Object[])[ videoMediaInfo.getWidth(), videoMediaInfo.getHeight() ]));
                    }
                    resources.add(res);
                }
            }
            ResourceInfo resourceInfo;
            VideoMediaInfo videoMediaInfo;
            int i;
            Resource thumbnailResource = generateThumbnailResource(video, rendererProfile);
            if (thumbnailResource !is null) {
                resources.add(thumbnailResource);
            }
            Resource subtitleResource = generateSubtitlesResource(video, rendererProfile);
            if (subtitleResource !is null) {
                resources.add(subtitleResource);
            }
        }
        return resources;
    }

    public static final Resource generateThumbnailResource(Long entityId, Long thumbnailId, Profile rendererProfile, bool isLocalThubmnail)
    {
        if (thumbnailId !is null) {
            try
            {
                Resource thRes = null;
                if (isLocalThubmnail)
                {
                    CoverImage thumbnail = MediaService.getCoverImage(thumbnailId);
                    thRes = new Resource(Resource.ResourceType.COVER_IMAGE, thumbnail.getId(), null, null, null, null);
                    if ((rendererProfile !is null) && (rendererProfile.getThumbnailsResolution() == ThumbnailResolution.HD)) {
                        thRes.setResolution(String.format("%sx%s", cast(Object[])[ Integer.valueOf(thumbnail.getWidthHD()), Integer.valueOf(thumbnail.getHeightHD()) ]));
                    } else {
                        thRes.setResolution(String.format("%sx%s", cast(Object[])[ Integer.valueOf(thumbnail.getWidth()), Integer.valueOf(thumbnail.getHeight()) ]));
                    }
                }
                else
                {
                    thRes = new Resource(Resource.ResourceType.COVER_IMAGE, entityId, null, null, null, null);
                }
                if (rendererProfile !is null)
                {
                    String protocolInfos = cast(String)rendererProfile.getResourceProtocolInfo(MediaFormatProfile.JPEG_TN).getMediaProtocolInfo(true, false, MediaFileType.IMAGE, false).iterator().next();
                    thRes.setProtocolInfo(protocolInfos);
                }
                return thRes;
            }
            catch (Exception e)
            {
                return null;
            }
        }
        return null;
    }

    public static final Resource generateThumbnailResource(MediaItem item, Profile rendererProfile)
    {
        return generateThumbnailResource(item.getId(), item.getThumbnailId(), rendererProfile, item.isLocalMedia());
    }

    public static final Resource generateThumbnailResource(Long thumbnailId)
    {
        if (thumbnailId !is null) {
            try
            {
                return new Resource(Resource.ResourceType.COVER_IMAGE, thumbnailId, null, null, null, null);
            }
            catch (Exception e)
            {
                return null;
            }
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.ResourceValuesBuilder
* JD-Core Version:    0.7.0.1
*/