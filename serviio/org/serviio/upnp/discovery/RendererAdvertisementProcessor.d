module org.serviio.upnp.discovery.RendererAdvertisementProcessor;

import java.lang;
import org.serviio.renderer.RendererManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RendererAdvertisementProcessor : Runnable
{
    private static Logger log;
    private String deviceIPAddress;
    private String nts;
    private int timeToKeep;
    private String deviceDescriptionURL;
    private String uuid;
    private String server;

    static this()
    {
        log = LoggerFactory.getLogger!(RendererAdvertisementProcessor);
    }

    public this(String deviceIPAddress, String uuid, String nts, int timeToKeep, String deviceDescriptionURL, String server)
    {
        this.deviceIPAddress = deviceIPAddress;
        this.uuid = uuid;
        this.nts = nts;
        this.timeToKeep = timeToKeep;
        this.deviceDescriptionURL = deviceDescriptionURL;
        this.server = server;
    }

    public void run()
    {
        if (this.nts.equals("ssdp:alive")) {
            RendererManager.getInstance().rendererAvailable(this.uuid, this.deviceIPAddress, this.timeToKeep, this.deviceDescriptionURL, this.server);
        } else if (this.nts.equals("ssdp:byebye")) {
            RendererManager.getInstance().rendererUnavailable(this.uuid);
        } else {
            log.debug_(String.format("Invalid NTS in NOTIFY message: %s", cast(Object[])[ this.nts ]));
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.discovery.RendererAdvertisementProcessor
* JD-Core Version:    0.7.0.1
*/