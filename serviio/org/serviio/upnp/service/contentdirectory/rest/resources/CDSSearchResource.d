module org.serviio.upnp.service.contentdirectory.rest.resources.CDSSearchResource;

import org.restlet.resource.Get;
import org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultsRepresentation;

public abstract interface CDSSearchResource
{
  @Get("xml|json")
  public abstract SearchResultsRepresentation search();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.CDSSearchResource
 * JD-Core Version:    0.7.0.1
 */