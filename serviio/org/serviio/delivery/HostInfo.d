module org.serviio.delivery.HostInfo;

import java.lang;
import java.net.InetAddress;
import org.serviio.upnp.Device;
import org.serviio.upnp.webserver.WebServer;
import org.serviio.delivery.URLParameters;

public class HostInfo
{
    private String host;
    private Integer port;
    private String context;
    private URLParameters urlParameters;

    public this(String host, Integer port, String context)
    {
        this.host = host;
        this.port = port;
        this.context = context;
    }

    public this(String host, Integer port, String context, URLParameters authentication)
    {
        this(host, port, context);
        this.urlParameters = authentication;
    }

    public static HostInfo defaultHostInfo()
    {
        return new HostInfo(Device.getInstance().getBindAddress().getHostAddress(), WebServer.WEBSERVER_PORT, "/resource");
    }

    public String getHost()
    {
        return this.host;
    }

    public Integer getPort()
    {
        return this.port;
    }

    public String getContext()
    {
        return this.context;
    }

    public URLParameters getURLParameters()
    {
        return this.urlParameters;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.HostInfo
* JD-Core Version:    0.7.0.1
*/