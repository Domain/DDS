module org.serviio.upnp.protocol.http.transport.SamsungWiseLinkProtocolHandler;

import java.io.FileNotFoundException;
import java.util.List;
import java.util.Map;
import org.apache.http.ProtocolVersion;
import org.serviio.delivery.AudioMediaInfo;
import org.serviio.delivery.Client;
import org.serviio.delivery.HttpResponseCodeException;
import org.serviio.delivery.RangeHeaders;
import org.serviio.delivery.ResourceDeliveryProcessor.HttpMethod;
import org.serviio.delivery.ResourceInfo;
import org.serviio.delivery.VideoMediaInfo;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.MediaFormatProfileResolver;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.library.entities.Image;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.ImageService;
import org.serviio.library.local.service.VideoService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.OnlineItemService;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.classes.Resource.ResourceType;
import org.serviio.upnp.service.contentdirectory.command.ResourceValuesBuilder;
import org.slf4j.Logger;

public class SamsungWiseLinkProtocolHandler
  : DLNAProtocolHandler
{
  public void handleResponse(Map!(String, String) requestHeaders, Map!(String, Object) responseHeaders, ResourceDeliveryProcessor.HttpMethod httpMethod, ProtocolVersion requestHttpVersion, ResourceInfo mediaFileResourceInfo, Integer protocolInfoIndex, TransferMode transferMode, Client client, Long streamSize, RangeHeaders range)
  {
    super.handleResponse(requestHeaders, responseHeaders, httpMethod, requestHttpVersion, mediaFileResourceInfo, protocolInfoIndex, transferMode, client, streamSize, range);
    if (httpMethod == ResourceDeliveryProcessor.HttpMethod.HEAD)
    {
      String captionInfoHeader = cast(String)requestHeaders.get("getCaptionInfo.sec");
      if ((captionInfoHeader !is null) && (captionInfoHeader.trim().equals("1"))) {
        if ((( cast(VideoMediaInfo)mediaFileResourceInfo !is null )) && (MediaItem.isLocalMedia(mediaFileResourceInfo.getResourceId())))
        {
          Video video = VideoService.getVideo(mediaFileResourceInfo.getResourceId());
          Resource subResource = ResourceValuesBuilder.generateSubtitlesResource(video, client.getRendererProfile());
          if (subResource !is null) {
            try
            {
              responseHeaders.put("CaptionInfo.sec", subResource.getGeneratedURL(client.getHostInfo()));
            }
            catch (InvalidResourceException e)
            {
              this.log.warn("Cannot set caption resource, because the subtitles resource is invalid.");
            }
          }
          storeContentFeatures(responseHeaders, mediaFileResourceInfo, protocolInfoIndex, client);
        }
      }
    }
    String mediaInfoHeader = cast(String)requestHeaders.get("getMediaInfo.sec");
    if ((mediaInfoHeader !is null) && (mediaInfoHeader.trim().equals("1"))) {
      if ((( cast(VideoMediaInfo)mediaFileResourceInfo !is null )) || (( cast(AudioMediaInfo)mediaFileResourceInfo !is null )))
      {
        Integer durationInSeconds = mediaFileResourceInfo.getDuration();
        if ((durationInSeconds is null) && (mediaFileResourceInfo.isLive())) {
          durationInSeconds = Integer.valueOf(18000);
        }
        if (durationInSeconds !is null) {
          responseHeaders.put("MediaInfo.sec", String.format("SEC_Duration=%s;", cast(Object[])[ Integer.valueOf(durationInSeconds.intValue() * 1000) ]));
        }
      }
    }
  }
  
  public RequestedResourceDescriptor getRequestedResourceDescription(String requestUri, Client client)
  {
    RequestedResourceDescriptor originalDescriptor = super.getRequestedResourceDescription(requestUri, client);
    if ((originalDescriptor.getResourceType() == Resource.ResourceType.MEDIA_ITEM) && (originalDescriptor.getTargetProfileName() !is null) && (originalDescriptor.getTargetProfileName().equals(MediaFormatProfile.JPEG_SM.toString())))
    {
      Image image = getImageResource(originalDescriptor);
      if (image !is null) {
        try
        {
          MediaFormatProfile normalImageProfile = cast(MediaFormatProfile)MediaFormatProfileResolver.resolve(image).get(0);
          if (normalImageProfile != MediaFormatProfile.JPEG_SM)
          {
            Resource coverImageResource = ResourceValuesBuilder.generateThumbnailResource(image, null);
            if (coverImageResource !is null)
            {
              this.log.debug_("Routing the image request to cover image request");
              try
              {
                String coverImageUrl = coverImageResource.getGeneratedURL(client.getHostInfo());
                return super.getRequestedResourceDescription(coverImageUrl, client);
              }
              catch (InvalidResourceException e)
              {
                this.log.warn("Cannot set cover image resource, because the image resource is invalid.");
              }
            }
          }
        }
        catch (UnsupportedDLNAMediaFileFormatException e) {}
      }
    }
    return originalDescriptor;
  }
  
  private Image getImageResource(RequestedResourceDescriptor originalDescriptor)
  {
    Image image = null;
    if (MediaItem.isLocalMedia(originalDescriptor.getResourceId()))
    {
      image = ImageService.getImage(originalDescriptor.getResourceId());
    }
    else
    {
      OnlineItem onlineItem = OnlineItemService.findOnlineItemById(originalDescriptor.getResourceId());
      if ((onlineItem !is null) && (onlineItem.getType() == MediaFileType.IMAGE)) {
        image = cast(Image)onlineItem.toMediaItem();
      }
    }
    return image;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.http.transport.SamsungWiseLinkProtocolHandler
 * JD-Core Version:    0.7.0.1
 */