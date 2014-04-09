module org.serviio.upnp.service.contentdirectory.rest.access.UPnPWebGateway;

import java.lang.String;
import java.io.IOException;
import java.net.InetAddress;
import net.sbbi.upnp.devices.UPNPRootDevice;
import net.sbbi.upnp.impls.InternetGatewayDevice;
import net.sbbi.upnp.messages.UPNPResponseException;
import org.serviio.upnp.Device;
import org.serviio.upnp.service.contentdirectory.rest.access.WebGateway;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UPnPWebGateway : WebGateway
{
    private static Logger log;
    private static immutable int DISCOVERY_TIMEOUT = 3000;
    private InternetGatewayDevice device;

    static this()
    {
        log = LoggerFactory.getLogger!(UPnPWebGateway);
    }

    private this(InternetGatewayDevice device)
    {
        this.device = device;
    }

    public static UPnPWebGateway findRouter()
    {
        try
        {
            InternetGatewayDevice[] devices = InternetGatewayDevice.getDevices(3000);
            if ((devices !is null) && (devices.length > 0))
            {
                InternetGatewayDevice device = devices[0];
                log.debug_(java.lang.String.format("Found a UPnP router device '%s'", cast(Object[])[ device.getIGDRootDevice().getModelName() ]));
                return new UPnPWebGateway(devices[0]);
            }
            return null;
        }
        catch (IOException e)
        {
            throw new Exception(java.lang.String.format("Could not find UPnP router because of an exception: %s", cast(Object[])[ e.getMessage() ]), e);
        }
    }

    public void addPortMapping(int externalPort, int internalPort, int leaseDuration)
    {
        String localAddress = Device.getInstance().getBindAddress().getHostAddress();
        log.debug_(java.lang.String.format("Adding/updating router port mapping (%s -> %s) for IP %s with lease of %s sec.", cast(Object[])[ Integer.valueOf(externalPort), Integer.valueOf(internalPort), localAddress, Integer.valueOf(leaseDuration) ]));
        try
        {
            invokeAddPortMapping(externalPort, internalPort, localAddress, leaseDuration);
        }
        catch (UPNPResponseException e)
        {
            int errorCode = e.getDetailErrorCode();
            if (errorCode == 725)
            {
                log.debug_("Temporary lease rejected, trying permanent lease");
                invokeAddPortMapping(externalPort, internalPort, localAddress, 0);

                PortMapper.getInstance().shutdownLeaseRenewer();
                return;
            }
            throw e;
        }
    }

    public void deletePortMapping(int externalPort, int internalPort)
    {
        log.debug_(java.lang.String.format("Removing router port mapping (%s -> %s)", cast(Object[])[ Integer.valueOf(externalPort), Integer.valueOf(internalPort) ]));
        this.device.deletePortMapping(null, externalPort, "TCP");
    }

    private void invokeAddPortMapping(int externalPort, int internalPort, String localAddress, int leaseDuration)
    {
        this.device.addPortMapping("Serviio", null, internalPort, externalPort, localAddress, leaseDuration, "TCP");
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.access.UPnPWebGateway
* JD-Core Version:    0.7.0.1
*/