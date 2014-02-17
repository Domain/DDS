module org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractRestrictedCDSServerResource;

import org.restlet.representation.Representation;
import org.restlet.resource.ResourceException;

public abstract class AbstractRestrictedCDSServerResource
  : AbstractCDSServerResource
{
  private String authToken;
  
  protected void doInit()
  {
    super.doInit();
    this.authToken = getRequestQueryParam("authToken");
  }
  
  protected Representation doConditionalHandle()
  {
    if (isValidTokenNeeded()) {
      LoginServerResource.validateToken(this.authToken);
    }
    return super.doConditionalHandle();
  }
  
  protected bool isValidTokenNeeded()
  {
    return true;
  }
  
  protected String getToken()
  {
    return this.authToken;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractRestrictedCDSServerResource
 * JD-Core Version:    0.7.0.1
 */