module org.serviio.upnp.discovery.AbstractSSDPMessageListener;

import java.lang.String;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.util.StringUtils;
import org.serviio.upnp.discovery.Multicaster;

public abstract class AbstractSSDPMessageListener : Multicaster
{
    private static final Pattern usnPattern = Pattern.compile("uuid:(.+)::urn:.+", 2);

    protected String getDeviceUuidFromUSN(String usn)
    {
        if (usn !is null)
        {
            Matcher m = usnPattern.matcher(usn);
            if (m.find()) {
                return StringUtils.localeSafeToLowercase(m.group(1));
            }
        }
        return null;
    }

    protected String getDeviceIPAddress(String descriptionURL, SocketAddress fallbackSocketAddress)
    {
        if (descriptionURL is null) {
            return getIPFromSocketAddress(fallbackSocketAddress);
        }
        try
        {
            InetAddress address = InetAddress.getByName(new URL(descriptionURL).getHost());
            return address.getHostAddress();
        }
        catch (Exception e) {}
        return getIPFromSocketAddress(fallbackSocketAddress);
    }

    private String getIPFromSocketAddress(SocketAddress address)
    {
        return (cast(InetSocketAddress)address).getAddress().getHostAddress();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.discovery.AbstractSSDPMessageListener
* JD-Core Version:    0.7.0.1
*/