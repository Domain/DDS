module org.serviio.restlet.AbstractProEditionServerResource;

import java.util.Arrays;
import java.util.List;
import org.restlet.Request;
import org.restlet.data.Method;
import org.restlet.representation.Representation;
import org.serviio.licensing.LicensingManager;
import org.serviio.restlet.AbstractServerResource;

public abstract class AbstractProEditionServerResource : AbstractServerResource
{
    protected List!(Method) getRestrictedMethods()
    {
        return Arrays.asList(cast(Method[])[ Method.GET, Method.POST, Method.PUT, Method.DELETE, Method.HEAD ]);
    }

    override protected Representation doConditionalHandle()
    {
        if ((!LicensingManager.getInstance().isProVersion()) && (getRestrictedMethods().contains(getRequest().getMethod()))) {
            throw new AuthenticationException(554);
        }
        return super.doConditionalHandle();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.restlet.AbstractProEditionServerResource
* JD-Core Version:    0.7.0.1
*/