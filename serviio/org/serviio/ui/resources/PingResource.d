module org.serviio.ui.resources.PingResource;

import org.restlet.resource.Get;
import org.serviio.restlet.ResultRepresentation;

public abstract interface PingResource
{
  @Get("xml|json")
  public abstract ResultRepresentation ping();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.PingResource
 * JD-Core Version:    0.7.0.1
 */