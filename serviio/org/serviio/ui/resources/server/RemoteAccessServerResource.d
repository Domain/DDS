module org.serviio.ui.resources.server.RemoteAccessServerResource;

import java.net.URISyntaxException;
import java.util.Collections;
import java.util.List;
import org.restlet.data.Method;
import org.serviio.config.Configuration;
import org.serviio.restlet.AbstractProEditionServerResource;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.restlet.ValidationException;
import org.serviio.ui.representation.RemoteAccessRepresentation;
import org.serviio.ui.resources.RemoteAccessResource;
import org.serviio.upnp.service.contentdirectory.ContentDirectory;
import org.serviio.upnp.service.contentdirectory.rest.access.PortMapper;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.LoginServerResource;
import org.serviio.util.HttpUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public class RemoteAccessServerResource : AbstractProEditionServerResource, RemoteAccessResource
{
    public ResultRepresentation save(RemoteAccessRepresentation representation)
    {
        bool cleanCache = false;
        if (ObjectValidator.isEmpty(representation.getRemoteUserPassword())) {
            throw new ValidationException(504);
        }
        if ((Configuration.getWebPassword() is null) || (!Configuration.getWebPassword().opEquals(representation.getRemoteUserPassword())))
        {
            this.log.debug_("Remote access password updated");
            Configuration.setWebPassword(StringUtils.trim(representation.getRemoteUserPassword()));
            LoginServerResource.removeAllTokens();
        }
        try
        {
            Configuration.setRemoteExternalAddress(HttpUtils.getHostName(StringUtils.trim(representation.getExternalAddress())));
        }
        catch (URISyntaxException e)
        {
            throw new ValidationException(503, Collections.singletonList(representation.getExternalAddress()));
        }
        if (Configuration.getRemotePreferredDeliveryQuality() != representation.getPreferredRemoteDeliveryQuality())
        {
            Configuration.setRemotePreferredDeliveryQuality(representation.getPreferredRemoteDeliveryQuality());
            cleanCache = true;
        }
        updatePortMapping(representation);
        if (cleanCache) {
            getCDS().incrementUpdateID();
        }
        return responseOk();
    }

    public RemoteAccessRepresentation load()
    {
        RemoteAccessRepresentation rar = new RemoteAccessRepresentation();
        rar.setRemoteUserPassword(Configuration.getWebPassword());
        rar.setPreferredRemoteDeliveryQuality(Configuration.getRemotePreferredDeliveryQuality());
        rar.setPortMappingEnabled(Configuration.isRemotePortForwardingEnabled());
        rar.setExternalAddress(Configuration.getRemoteExternalAddress());
        return rar;
    }

    override protected List!(Method) getRestrictedMethods()
    {
        return Collections.singletonList(Method.PUT);
    }

    private void updatePortMapping(RemoteAccessRepresentation representation)
    {
        bool changed = Configuration.isRemotePortForwardingEnabled() != representation.isPortMappingEnabled();
        if (changed)
        {
            Configuration.setRemotePortForwardingEnabled(representation.isPortMappingEnabled());
            if (representation.isPortMappingEnabled())
            {
                PortMapper.getInstance().addPortMapping();
                PortMapper.getInstance().startLeaserRenewer();
            }
            else
            {
                PortMapper.getInstance().shutdownLeaseRenewer();
                PortMapper.getInstance().removePortMapping();
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.resources.server.RemoteAccessServerResource
* JD-Core Version:    0.7.0.1
*/