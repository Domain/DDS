module org.serviio.upnp.Device;

import java.lang.String;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.serviio.upnp.addressing.LocalAddressResolverStrategy;
import org.serviio.upnp.service.Service;
import org.serviio.upnp.service.connectionmanager.ConnectionManager;
import org.serviio.upnp.service.contentdirectory.ContentDirectory;
import org.serviio.upnp.service.microsoft.MediaReceiverRegistrar;
import org.serviio.upnp.webserver.WebServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Device
{
    private static Device instance;
    private static Logger log;
    private String uuid;
    private String deviceType = "urn:schemas-upnp-org:device:MediaServer:1";
    private InetAddress bindAddress;
    private URL descriptionURL;
    private List!(Service) services;
    private InetSocketAddress multicastGroupAddress;

    static this()
    {
        log = LoggerFactory.getLogger!(Device);
    }

    private this()
    {
        setupBindAddress();
        this.multicastGroupAddress = new InetSocketAddress("239.255.255.250", 1900);

        this.uuid = generateDeviceUUID();
        this.descriptionURL = resolveDescriptionURL();

        log.info(java.lang.String.format("Created UPnP Device with UUID: %s, bound address: %s", cast(Object[])[ this.uuid, this.bindAddress.getHostAddress() ]));
    }

    public static synchronized Device getInstance()
    {
        if (instance is null)
        {
            instance = new Device();
            instance.setupServices();
        }
        return instance;
    }

    public void refreshBoundIPAddress()
    {
        setupBindAddress();
        log.info(java.lang.String.format("Updated bound IP address of Device with UUID: %s, bound address: %s", cast(Object[])[ this.uuid, this.bindAddress.getHostAddress() ]));
    }

    public Service getServiceById(String serviceId)
    {
        foreach (Service service ; this.services) {
            if (service.getServiceId().opEquals(serviceId)) {
                return service;
            }
        }
        return null;
    }

    public Service getServiceByType(String serviceType)
    {
        foreach (Service service ; this.services) {
            if (service.getServiceType().opEquals(serviceType)) {
                return service;
            }
        }
        return null;
    }

    public Service getServiceByShortName(String serviceShortName)
    {
        foreach (Service service ; this.services) {
            if (service.getServiceId().endsWith(serviceShortName)) {
                return service;
            }
        }
        return null;
    }

    public ContentDirectory getCDS()
    {
        return cast(ContentDirectory)getInstance().getServiceById("urn:upnp-org:serviceId:ContentDirectory");
    }

    public void setupServices()
    {
        this.services = new ArrayList(2);
        this.services.add(new ConnectionManager());
        this.services.add(new ContentDirectory());
        this.services.add(new MediaReceiverRegistrar());
    }

    protected String generateDeviceUUID()
    {
        try
        {
            MessageDigest md5 = MessageDigest.getInstance("MD5");


            md5.update("Serviio".getBytes());
            md5.update(this.deviceType.getBytes());
            md5.update(this.bindAddress.getHostAddress().getBytes());
            byte[] digest = md5.digest();
            return UUID.nameUUIDFromBytes(digest).toString();
        }
        catch (Exception ex)
        {
            throw new RuntimeException("Unexpected error during MD5 hash creation", ex);
        }
    }

    protected URL resolveDescriptionURL()
    {
        try
        {
            return new URL("http", this.bindAddress.getHostAddress(), WebServer.WEBSERVER_PORT.intValue(), "/deviceDescription/" + this.uuid);
        }
        catch (MalformedURLException e)
        {
            throw new RuntimeException("Cannot resolve Device description URL address. Exiting.");
        }
    }

    private void setupBindAddress()
    {
        this.bindAddress = new LocalAddressResolverStrategy().getHostIpAddress();
    }

    public String getUuid()
    {
        return this.uuid;
    }

    public URL getDescriptionURL()
    {
        return this.descriptionURL;
    }

    public List!(Service) getServices()
    {
        return this.services;
    }

    public InetSocketAddress getMulticastGroupAddress()
    {
        return this.multicastGroupAddress;
    }

    public InetAddress getBindAddress()
    {
        return this.bindAddress;
    }

    public String getDeviceType()
    {
        return this.deviceType;
    }

    public void setUuid(String uuid)
    {
        this.uuid = uuid;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.Device
* JD-Core Version:    0.7.0.1
*/