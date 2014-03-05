module org.serviio.upnp.service.contentdirectory.rest.access.PortMappingChecker;

import java.lang.String;
import java.io.IOException;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.List;
import org.restlet.Client;
import org.restlet.Request;
import org.restlet.Response;
import org.restlet.data.Form;
import org.restlet.data.Method;
import org.restlet.data.Parameter;
import org.restlet.data.Protocol;
import org.restlet.data.Status;
import org.serviio.util.ObjectValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PortMappingChecker
{
    private static immutable String API_URL = "http://www.yougetsignal.com/tools/open-ports/php/check-port.php";
    private static Logger log;
    private static Client c;

    static this()
    {
        log = LoggerFactory.getLogger!(PortMappingChecker);
        c = new Client(Protocol.HTTP);
    }

    public static synchronized bool isPortOpen(String address, int port)
    {
        String externalAddress = ObjectValidator.isEmpty(address) ? ExternalIPRetriever.getExternalIP().getHostAddress() : address;

        log.info(String.format("Running a check for external mapping of port %s on '%s'", cast(Object[])[ Integer.valueOf(port), externalAddress ]));

        List!(Parameter) form = new ArrayList(2);
        form.add(new Parameter("remoteAddress", externalAddress));
        form.add(new Parameter("portNumber", Integer.toString(port)));
        Form webForm = new Form(form);
        try
        {
            Request r = new Request(Method.POST, "http://www.yougetsignal.com/tools/open-ports/php/check-port.php");
            r.setEntity(webForm.getWebRepresentation());
            Response res = c.handle(r);
            if (res.getStatus().equals(Status.SUCCESS_OK))
            {
                String html = res.getEntityAsText();
                if (html !is null)
                {
                    if (html.indexOf("is closed") > -1)
                    {
                        log.info(String.format("Port %s is closed", cast(Object[])[ Integer.valueOf(port) ]));
                        return false;
                    }
                    if (html.indexOf("is open") > -1)
                    {
                        log.info(String.format("Port %s is open", cast(Object[])[ Integer.valueOf(port) ]));
                        return true;
                    }
                    log.warn(String.format("Cannot work out whether port %s is open or closed", cast(Object[])[ Integer.valueOf(port) ]));
                    return false;
                }
            }
            throw new IOException("Returned response is empty");
        }
        catch (Throwable t)
        {
            throw new IOException(t);
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.access.PortMappingChecker
* JD-Core Version:    0.7.0.1
*/