module org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSApplicationServerResource;

import org.serviio.ui.resources.server.ApplicationServerResource;

public class CDSApplicationServerResource
  : ApplicationServerResource
{
  protected bool includePersonalDetails()
  {
    return false;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSApplicationServerResource
 * JD-Core Version:    0.7.0.1
 */