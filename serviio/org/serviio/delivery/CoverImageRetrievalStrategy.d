module org.serviio.delivery.CoverImageRetrievalStrategy;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.ThumbnailResolution;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.library.entities.CoverImage;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.local.service.MediaService;
import org.serviio.library.online.OnlineItemService;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.Profile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CoverImageRetrievalStrategy
  : ResourceRetrievalStrategy
{
  private static final Logger log = LoggerFactory.getLogger!(CoverImageRetrievalStrategy);
  
  public DeliveryContainer retrieveResource(Long coverImageId, MediaFormatProfile selectedVersion, QualityType selectedQuality, String path, Double timeOffsetInSeconds, Double durationInSeconds, Client client, bool markAsRead)
  {
    CoverImage coverImage = retrieveCoverImage(coverImageId);
    ThumbnailResolution resolution = client.getRendererProfile().getThumbnailsResolution();
    
    bool useHD = isHD(coverImage, resolution);
    log.debug_(String.format("Retrieving Cover image (%s) with id %s", cast(Object[])[ useHD ? "HD" : "SD", coverImageId ]));
    
    ResourceInfo resourceInfo = retrieveResourceInfo(coverImage, selectedVersion, resolution);
    DeliveryContainer container = new StreamDeliveryContainer(new ByteArrayInputStream(useHD ? coverImage.getImageBytesHD() : coverImage.getImageBytes()), resourceInfo);
    return container;
  }
  
  public ResourceInfo retrieveResourceInfo(Long coverImageId, MediaFormatProfile selectedVersion, QualityType selectedQuality, String path, Client client)
  {
    CoverImage coverImage = retrieveCoverImage(coverImageId);
    ThumbnailResolution resolution = client.getRendererProfile().getThumbnailsResolution();
    
    log.debug_(String.format("Retrieving info of Cover image with id %s", cast(Object[])[ coverImageId ]));
    return retrieveResourceInfo(coverImage, selectedVersion, resolution);
  }
  
  private ResourceInfo retrieveResourceInfo(CoverImage coverImage, MediaFormatProfile selectedVersion, ThumbnailResolution resolution)
  {
    bool useHD = isHD(coverImage, resolution);
    Long fileSize = new Long(useHD ? coverImage.getImageBytesHD().length : coverImage.getImageBytes().length);
    Integer width = Integer.valueOf(useHD ? coverImage.getWidthHD() : coverImage.getWidth());
    Integer height = Integer.valueOf(useHD ? coverImage.getHeightHD() : coverImage.getHeight());
    
    ResourceInfo resourceInfo = new ImageMediaInfo(coverImage.getId(), MediaFormatProfile.JPEG_TN, fileSize, width, height, false, coverImage.getMimeType(), QualityType.ORIGINAL);
    
    return resourceInfo;
  }
  
  private CoverImage retrieveCoverImage(Long resourceId)
  {
    if (MediaItem.isLocalMedia(resourceId))
    {
      CoverImage coverImage = MediaService.getCoverImage(resourceId);
      if (coverImage is null) {
        throw new FileNotFoundException(String.format("Cover image %s cannot be found", cast(Object[])[ resourceId ]));
      }
      return coverImage;
    }
    CoverImage coverImage = OnlineItemService.findThumbnail(resourceId);
    if (coverImage is null) {
      throw new FileNotFoundException(String.format("Cover image for feed item %s cannot be found", cast(Object[])[ resourceId ]));
    }
    return coverImage;
  }
  
  private bool isHD(CoverImage coverImage, ThumbnailResolution resolution)
  {
    return (resolution == ThumbnailResolution.HD) && (coverImage.getImageBytesHD() !is null);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.CoverImageRetrievalStrategy
 * JD-Core Version:    0.7.0.1
 */