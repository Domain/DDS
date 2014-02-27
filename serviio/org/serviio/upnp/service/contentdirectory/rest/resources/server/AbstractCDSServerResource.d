module org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractCDSServerResource;

import java.util.Arrays;
import java.util.Map;
import java.util.Map.Entry;
import org.restlet.Request;
import org.restlet.Response;
import org.restlet.data.CacheDirective;
import org.restlet.data.Form;
import org.restlet.data.Parameter;
import org.restlet.data.Reference;
import org.restlet.representation.Representation;
import org.restlet.resource.ResourceException;
import org.serviio.MediaServer;
import org.serviio.UPnPServerStatus;
import org.serviio.delivery.CDSUrlParameters;
import org.serviio.delivery.HostInfo;
import org.serviio.restlet.AbstractProEditionServerResource;
import org.serviio.restlet.ServerUnavailableException;
import org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.util.CaseInsensitiveMap;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public abstract class AbstractCDSServerResource
: AbstractProEditionServerResource
{
    private static immutable String ORG_RESTLET_HTTP_HEADERS = "org.restlet.http.headers";
    protected static immutable String X_SERVIIO_CLIENTID_HEADER = "X-Serviio-ClientId";

    protected void doInit()
    {
        getResponse().setCacheDirectives(Arrays.asList(cast(CacheDirective[])[ new CacheDirective("no-cache") ]));
    }

    protected Representation doConditionalHandle()
    {
        if (MediaServer.getStatus() == UPnPServerStatus.STARTED) {
            return super.doConditionalHandle();
        }
        throw new ServerUnavailableException();
    }

    protected Map!(String, String) getRequestHeaders(Request request)
    {
        Form form = cast(Form)request.getAttributes().get("org.restlet.http.headers");
        Map!(String, String) headers = new CaseInsensitiveMap();
        foreach (Parameter p ; form) {
            headers.put(p.getName(), p.getValue());
        }
        return headers;
    }

    protected void setCustomHeader(Response response, String name, String value)
    {
        Form form = cast(Form)response.getAttributes().get("org.restlet.http.headers");
        if (form is null)
        {
            form = new Form();
            response.getAttributes().put("org.restlet.http.headers", form);
        }
        form.add(name, value);
    }

    protected Object getHeaderValue(String headerName, Map/*!(String, ?)*/ headers)
    {
        String lowercaseHeaderName = StringUtils.localeSafeToLowercase(headerName);
        foreach (Map.Entry/*!(String, ?)*/ header ; headers.entrySet()) {
            if (lowercaseHeaderName.equals(StringUtils.localeSafeToLowercase(cast(String)header.getKey()))) {
                return header.getValue();
            }
        }
        return null;
    }

    protected String getHeaderStringValue(String headerName, Map/*!(String, ?)*/ headers)
    {
        Object value = getHeaderValue(headerName, headers);
        if (value !is null) {
            return value.toString();
        }
        return null;
    }

    protected HostInfo getHostInfo(bool includeHost, bool withSharedAuthentication, String profileId)
    {
        String host = null;
        Integer port = null;
        if (includeHost)
        {
            host = getRequest().getHostRef().getHostDomain();
            port = Integer.valueOf(getRequest().getHostRef().getHostPort());
        }
        return new HostInfo(host, port, "/cds/resource", new CDSUrlParameters(withSharedAuthentication, profileId));
    }

    protected String getResourceUrl(Resource resource, String profileId)
    {
        if (resource !is null) {
            try
            {
                return resource.getGeneratedURL(getHostInfo(false, false, profileId));
            }
            catch (InvalidResourceException e)
            {
                this.log.warn("Cannot generate resource URL because the resource is invalid.");
            }
        }
        return null;
    }

    protected String getRequestQueryParam(String paramName)
    {
        return new Form(getRequest().getOriginalRef().getQuery(true)).getFirstValue(paramName, true);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractCDSServerResource
* JD-Core Version:    0.7.0.1
*/