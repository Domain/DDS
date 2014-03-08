module org.serviio.upnp.service.contentdirectory.rest.ContentDirectoryRestletApplication;

import java.lang.String;
import org.restlet.Application;
import org.restlet.Restlet;
import org.restlet.engine.application.Encoder;
import org.restlet.routing.Filter;
import org.restlet.routing.Router;
import org.serviio.ui.resources.server.PingServerResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSApplicationServerResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSBrowseServerResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSRetrieveMediaServerResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSSearchServerResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.FlowPlayerKeyGeneratorServerResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.LoginServerResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.LogoutServerResource;

public class ContentDirectoryRestletApplication : Application
{
    public static immutable String APP_CONTEXT = "/cds";

    public Restlet createInboundRoot()
    {
        Router router = new Router(getContext());
        router.setDefaultMatchingMode(1);

        router.attach("/browse/{profile}/{objectId}/{browseFlag}/{objectType}/{start}/{count}", CDSBrowseServerResource.class_);
        router.attach("/search/{profile}/{fileType}/{term}/{start}/{count}", CDSSearchServerResource.class_);
        router.attach("/resource", CDSRetrieveMediaServerResource.class_);
        router.attach("/login", LoginServerResource.class_);
        router.attach("/logout", LogoutServerResource.class_);
        router.attach("/application", CDSApplicationServerResource.class_);
        router.attach("/ping", PingServerResource.class_);
        router.attach("/fp", FlowPlayerKeyGeneratorServerResource.class_);

        Filter filter = new Encoder(getContext());
        filter.setNext(router);
        return filter;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.ContentDirectoryRestletApplication
* JD-Core Version:    0.7.0.1
*/