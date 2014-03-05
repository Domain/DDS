module org.serviio.upnp.service.contentdirectory.rest.access.PortMapper;

import java.lang;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import org.serviio.config.Configuration;
import org.serviio.licensing.LicensingManager;
import org.serviio.util.ThreadUtils;
import org.serviio.upnp.service.contentdirectory.rest.access.WebGateway;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PortMapper
{
    private static Logger log = LoggerFactory.getLogger!(PortMapper);
    private static PortMapper instance;
    private static enum LEASE_DURATION = 1800;
    private ScheduledExecutorService leaseRenewalExecutor;
    private Runnable renewer = new PortmappingLeaseRenewer(null);
    private WebGateway router;

    private this()
    {
        if (isPortMappingEnabled()) {
            startLeaserRenewer();
        }
    }

    public static PortMapper getInstance()
    {
        if (instance is null) {
            instance = new PortMapper();
        }
        return instance;
    }

    public void addPortMapping()
    {
        if (isPortMappingEnabled()) {
            ThreadUtils.runAsynchronously(new class() Runnable {
                public void run()
                {
                    WebGateway router = this.outer.getRouter();
                    if (router !is null) {
                        try
                        {
                            router.addPortMapping(23424, 23424, 1800);
                        }
                        catch (Exception e)
                        {
                            PortMapper.log.warn(String.format("Could not add port mapping to the router: %s", cast(Object[])[ e.getMessage() ]));
                        }
                    }
                }
            });
        }
    }

    public void removePortMapping()
    {
        ThreadUtils.runAsynchronously(new class() Runnable {
            public void run()
            {
                if (this.outer.router !is null) {
                    try
                    {
                        this.outer.router.deletePortMapping(23424, 23424);
                    }
                    catch (Exception e)
                    {
                        PortMapper.log.warn(String.format("Could not remove port mapping from the router: %s", cast(Object[])[ e.getMessage() ]));
                    }
                }
            }
        });
    }

    public void resetPortMapping()
    {
        if (isPortMappingEnabled()) {
            ThreadUtils.runAsynchronously(new class() Runnable {
                public void run()
                {
                    WebGateway router = this.outer.findRouter();
                    if (router !is null) {
                        try
                        {
                            router.deletePortMapping(23424, 23424);
                            router.addPortMapping(23424, 23424, 1800);
                        }
                        catch (Exception e)
                        {
                            PortMapper.log.warn(String.format("Could not reset port mapping to the router: %s", cast(Object[])[ e.getMessage() ]), e);
                        }
                    }
                }
            });
        }
    }

    public void shutdownLeaseRenewer()
    {
        if ((this.leaseRenewalExecutor !is null) && (!this.leaseRenewalExecutor.isShutdown()))
        {
            log.info("Stopping port mapping scheduler");
            this.leaseRenewalExecutor.shutdown();
            this.leaseRenewalExecutor = null;
        }
    }

    public void startLeaserRenewer()
    {
        log.info("Starting port mapping scheduler");
        if (this.leaseRenewalExecutor is null)
        {
            this.leaseRenewalExecutor = Executors.newScheduledThreadPool(1);
            this.leaseRenewalExecutor.scheduleWithFixedDelay(this.renewer, 600L, 600L, TimeUnit.SECONDS);
        }
    }

    private bool isPortMappingEnabled()
    {
        return (LicensingManager.getInstance().isProVersion()) && (Configuration.isRemotePortForwardingEnabled());
    }

    private WebGateway findRouter()
    {
        WebGateway router = null;
        try
        {
            router = UPnPWebGateway.findRouter();
        }
        catch (Throwable e)
        {
            log.debug_(e.getMessage());
        }
        if (router is null) {
            try
            {
                router = NATPMPGateway.findRouter();
            }
            catch (Throwable e)
            {
                log.debug_(e.getMessage());
            }
        }
        if (router is null) {
            log.warn("Could not find a router on the network. Autodiscovery (UPnP/NAP PMP) might be disabled or the router is not currently supported.");
        }
        return router;
    }

    private WebGateway getRouter()
    {
        if (this.router is null) {
            this.router = findRouter();
        }
        return this.router;
    }

    private class PortmappingLeaseRenewer : Runnable
    {
        private this() {}

        override public void run()
        {
            PortMapper.log.debug_("Renewing port mapping lease");
            this.outer.addPortMapping();
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.access.PortMapper
* JD-Core Version:    0.7.0.1
*/