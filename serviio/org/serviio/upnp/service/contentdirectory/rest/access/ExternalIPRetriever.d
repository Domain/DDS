module org.serviio.upnp.service.contentdirectory.rest.access.ExternalIPRetriever;

import java.lang.String;
import java.io.IOException;
import java.net.InetAddress;
import org.serviio.util.HttpClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ExternalIPRetriever
{
    private static immutable String API_URL = "http://api.exip.org/?call=ip";
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(ExternalIPRetriever);
    }

    public static InetAddress getExternalIP()
    {
        log.debug_("Retrieving external IP address");
        String ip = HttpClient.retrieveTextFileFromURL("http://api.exip.org/?call=ip", "UTF-8");
        log.debug_("Found external IP address: " + ip);
        return InetAddress.getByName(ip);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.access.ExternalIPRetriever
* JD-Core Version:    0.7.0.1
*/