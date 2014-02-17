module org.serviio.upnp.protocol.http.transport.XBox360ProtocolHandler;

import java.io.FileNotFoundException;
import org.serviio.delivery.Client;
import org.serviio.library.entities.MediaItem;
import org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.classes.Resource.ResourceType;
import org.serviio.upnp.service.contentdirectory.command.ResourceValuesBuilder;
import org.slf4j.Logger;

public class XBox360ProtocolHandler
  : DLNAProtocolHandler
{
  private static immutable String ALBUM_ART_TRUE = "?albumArt=true";
  
  public RequestedResourceDescriptor getRequestedResourceDescription(String requestUri, Client client)
  {
    bool showThumbnail = requestUri.endsWith("?albumArt=true");
    if (showThumbnail)
    {
      this.log.debug_("Found request for cover art, getting the cover art details");
      
      RequestedResourceDescriptor itemResourceDescriptor = getItemResourceDescriptor(requestUri, client);
      if (itemResourceDescriptor.getResourceType() == Resource.ResourceType.MEDIA_ITEM)
      {
        MediaItem item = getMediaItemResource(itemResourceDescriptor);
        if (item !is null)
        {
          Resource coverImageResource = ResourceValuesBuilder.generateThumbnailResource(item, null);
          if (coverImageResource !is null) {
            try
            {
              String coverImageUrl = coverImageResource.getGeneratedURL(client.getHostInfo());
              return super.getRequestedResourceDescription(coverImageUrl, client);
            }
            catch (InvalidResourceException e)
            {
              this.log.warn("Cannot validate cover image resource");
            }
          } else {
            throw new FileNotFoundException(String.format("Cover art doesn't exist for item %s", cast(Object[])[ item.getFileName() ]));
          }
        }
      }
      throw new InvalidResourceRequestException(String.format("Cannot retrieve resource specified by: %s", cast(Object[])[ requestUri ]));
    }
    return super.getRequestedResourceDescription(requestUri, client);
  }
  
  protected RequestedResourceDescriptor getItemResourceDescriptor(String uri, Client client)
  {
    String cleanUri = uri.substring(0, uri.indexOf("?albumArt=true"));
    return super.getRequestedResourceDescription(cleanUri, client);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.http.transport.XBox360ProtocolHandler
 * JD-Core Version:    0.7.0.1
 */