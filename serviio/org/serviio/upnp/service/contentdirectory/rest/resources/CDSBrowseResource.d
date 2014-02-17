module org.serviio.upnp.service.contentdirectory.rest.resources.CDSBrowseResource;

import org.restlet.resource.Get;
import org.serviio.upnp.service.contentdirectory.rest.representation.BrowseContentDirectoryRepresentation;

public abstract interface CDSBrowseResource
{
  @Get("xml|json")
  public abstract BrowseContentDirectoryRepresentation browse();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.CDSBrowseResource
 * JD-Core Version:    0.7.0.1
 */