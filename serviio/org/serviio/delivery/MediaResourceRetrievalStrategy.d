module org.serviio.delivery.MediaResourceRetrievalStrategy;

import java.lang;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import org.serviio.delivery.resource.AudioDeliveryEngine;
import org.serviio.delivery.resource.ImageDeliveryEngine;
import org.serviio.delivery.resource.VideoDeliveryEngine;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.library.entities.Image;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.AudioService;
import org.serviio.library.local.service.ImageService;
import org.serviio.library.local.service.MediaService;
import org.serviio.library.local.service.VideoService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.OnlineItemService;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ContentDirectoryEngine;
import org.serviio.delivery.ResourceRetrievalStrategy;
import org.serviio.delivery.DeliveryContainer;
import org.serviio.delivery.Client;
import org.serviio.delivery.ResourceInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MediaResourceRetrievalStrategy : ResourceRetrievalStrategy
{
    private static Logger log = LoggerFactory.getLogger!(MediaResourceRetrievalStrategy);

    public static List/*!(? : ResourceInfo)*/ getMediaInfoForAvailableProfiles(MediaItem mediaItem, Profile rendererProfile)
    {
        bool isLocalMedia = mediaItem.isLocalMedia();
        if (mediaItem.getFileType() == MediaFileType.IMAGE)
        {
            Image image = isLocalMedia ? ImageService.getImage(mediaItem.getId()) : cast(Image)mediaItem;
            return ImageDeliveryEngine.getInstance().getMediaInfoForProfile(image, rendererProfile);
        }
        if (mediaItem.getFileType() == MediaFileType.AUDIO)
        {
            MusicTrack track = isLocalMedia ? AudioService.getSong(mediaItem.getId()) : cast(MusicTrack)mediaItem;
            return AudioDeliveryEngine.getInstance().getMediaInfoForProfile(track, rendererProfile);
        }
        Video video = isLocalMedia ? VideoService.getVideo(mediaItem.getId()) : cast(Video)mediaItem;
        return VideoDeliveryEngine.getInstance().getMediaInfoForProfile(video, rendererProfile);
    }

    public static MediaItem loadMediaItem(Long mediaItemId)
    {
        MediaItem mediaItem = null;
        bool localMedia = MediaItem.isLocalMedia(mediaItemId);
        log.debug_(String.format("Getting information about media item %s (%s)", cast(Object[])[ mediaItemId, localMedia ? "local" : "online" ]));
        if (localMedia)
        {
            mediaItem = MediaService.readMediaItemById(mediaItemId);
            if (mediaItem.getFileType() == MediaFileType.IMAGE) {
                mediaItem = ImageService.getImage(mediaItem.getId());
            } else if (mediaItem.getFileType() == MediaFileType.AUDIO) {
                mediaItem = AudioService.getSong(mediaItem.getId());
            } else {
                mediaItem = VideoService.getVideo(mediaItem.getId());
            }
        }
        else
        {
            OnlineItem onlineItem = OnlineItemService.findOnlineItemById(mediaItemId);
            if (onlineItem !is null) {
                mediaItem = onlineItem.toMediaItem();
            }
        }
        if (mediaItem is null) {
            throw new FileNotFoundException(String.format("Media item %s cannot be found", cast(Object[])[ mediaItemId ]));
        }
        return mediaItem;
    }

    public DeliveryContainer retrieveResource(Long mediaItemId, MediaFormatProfile selectedVersion, QualityType selectedQuality, String path, Double timeOffsetInSeconds, Double durationInSeconds, Client client, bool markAsRead)
    {
        if (selectedVersion is null) {
            throw new FileNotFoundException("The request did not provide required version of the resource");
        }
        MediaItem mediaItem = loadMediaItem(mediaItemId);
        bool isLocalMedia = mediaItem.isLocalMedia();
        DeliveryContainer deliveryContainer = null;
        if (mediaItem.getFileType() == MediaFileType.IMAGE) {
            deliveryContainer = ImageDeliveryEngine.getInstance().deliver(cast(Image)mediaItem, selectedVersion, selectedQuality, null, null, client);
        } else if (mediaItem.getFileType() == MediaFileType.AUDIO) {
            deliveryContainer = AudioDeliveryEngine.getInstance().deliver(cast(MusicTrack)mediaItem, selectedVersion, selectedQuality, timeOffsetInSeconds, durationInSeconds, client);
        } else {
            deliveryContainer = VideoDeliveryEngine.getInstance().deliver(cast(Video)mediaItem, selectedVersion, selectedQuality, timeOffsetInSeconds, durationInSeconds, client);
        }
        if ((isLocalMedia) && (markAsRead) && (mediaItem.getFileType() != MediaFileType.IMAGE))
        {
            MediaService.markMediaItemAsRead(mediaItemId);

            ContentDirectoryEngine cds = ContentDirectoryEngine.getInstance();
            cds.evictItemsAfterPlay();
        }
        return deliveryContainer;
    }

    public ResourceInfo retrieveResourceInfo(Long mediaItemId, MediaFormatProfile selectedVersion, QualityType selectedQuality, String path, Client client)
    {
        if (selectedVersion is null) {
            throw new FileNotFoundException("The request did not provide required version of the resource");
        }
        MediaItem mediaItem = loadMediaItem(mediaItemId);
        Profile rendererProfile = client.getRendererProfile();
        if (mediaItem.getFileType() == MediaFileType.IMAGE) {
            return ImageDeliveryEngine.getInstance().getMediaInfoForMediaItem(cast(Image)mediaItem, selectedVersion, selectedQuality, rendererProfile);
        }
        if (mediaItem.getFileType() == MediaFileType.AUDIO) {
            return AudioDeliveryEngine.getInstance().getMediaInfoForMediaItem(cast(MusicTrack)mediaItem, selectedVersion, selectedQuality, rendererProfile);
        }
        return VideoDeliveryEngine.getInstance().getMediaInfoForMediaItem(cast(Video)mediaItem, selectedVersion, selectedQuality, rendererProfile);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.MediaResourceRetrievalStrategy
* JD-Core Version:    0.7.0.1
*/