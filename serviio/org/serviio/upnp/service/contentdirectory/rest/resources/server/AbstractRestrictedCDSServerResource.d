module org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractRestrictedCDSServerResource;

import java.lang.String;
import org.restlet.representation.Representation;
import org.restlet.resource.ResourceException;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractCDSServerResource;

public abstract class AbstractRestrictedCDSServerResource : AbstractCDSServerResource
{
    private String authToken;

    override protected void doInit()
    {
        super.doInit();
        this.authToken = getRequestQueryParam("authToken");
    }

    override protected Representation doConditionalHandle()
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