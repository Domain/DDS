module org.serviio.upnp.service.contentdirectory.rest.resources.server.LogoutServerResource;

import org.serviio.restlet.ResultRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.resources.LogoutResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractRestrictedCDSServerResource;
import org.slf4j.Logger;

public class LogoutServerResource : AbstractRestrictedCDSServerResource , LogoutResource
{
    override protected bool isValidTokenNeeded()
    {
        return false;
    }

    public ResultRepresentation logout()
    {
        this.log.debug_("Logging out using token " ~ getToken());
        LoginServerResource.removeToken(getToken());
        return responseOk();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.LogoutServerResource
* JD-Core Version:    0.7.0.1
*/