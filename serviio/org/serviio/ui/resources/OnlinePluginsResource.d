module org.serviio.ui.resources.OnlinePluginsResource;

import org.restlet.resource.Get;
import org.serviio.ui.representation.OnlinePluginsRepresentation;

public abstract interface OnlinePluginsResource
{
  //@Get("xml|json")
  public abstract OnlinePluginsRepresentation load();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.OnlinePluginsResource
 * JD-Core Version:    0.7.0.1
 */