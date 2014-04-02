module org.serviio.upnp.discovery.DiscoveryManager;

import java.lang;
import java.io.IOException;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import org.serviio.MediaServer;
import org.serviio.UPnPServerStatus;
import org.serviio.renderer.RendererManager;
import org.serviio.upnp.Device;
import org.serviio.upnp.eventing.EventDispatcher;
import org.serviio.upnp.eventing.EventSubscriptionExpirationChecker;
import org.serviio.util.ObjectValidator;
import org.serviio.util.ServiioThreadFactory;
import org.serviio.upnp.discovery.WakeUpListener;
import org.serviio.upnp.discovery.DiscoveryAdvertisementNotifier;
import org.serviio.upnp.discovery.DiscoverySSDPMessageListener;
import org.serviio.upnp.discovery.WakeUpMonitor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DiscoveryManager : WakeUpListener
{
    private static Logger log;
    private static DiscoveryManager _instance;
    private static immutable int MIN_SLEEP_CHECK_TIMEOUT_MS = 60000;
    private static immutable int SLEEP_CHECK_INTERVAL_MS = 10000;
    private DiscoveryAdvertisementNotifier discoveryNotifier;
    private DiscoverySSDPMessageListener discoverySSDPMessageListener;
    private EventSubscriptionExpirationChecker subscriptionExpiryChecker;
    private EventDispatcher eventDispatcher;
    private WakeUpMonitor wakeUpMonitor;
    private Thread discoveryNotifierThread;
    private Thread discoverySearchListenerThread;
    private Thread subscriptionExpiryCheckerThread;
    private Thread eventDispatcherThread;
    private ScheduledFuture!(Object) wakeUpMonitorSchedule;
    private ScheduledThreadPoolExecutor wakeUpMonitorExecutor;
    private int advertisementSendCount = 3;

    static this()
    {
        log = LoggerFactory.getLogger!(DiscoveryManager);
    }

    public static DiscoveryManager instance()
    {
        if (_instance is null) {
            _instance = new DiscoveryManager();
        }
        return _instance;
    }

    static this()
    {
        wakeUpMonitor = new WakeUpMonitor(MIN_SLEEP_CHECK_TIMEOUT_MS, this);
        wakeUpMonitorExecutor = new ScheduledThreadPoolExecutor(1, ServiioThreadFactory.getInstance());
    }

    public void onWakeUp()
    {
        if (MediaServer.getStatus() == UPnPServerStatus.STARTED)
        {
            log.info("System wake up detected, restarting UPnP services for network re-discovery");
            restartDiscoveryEngine();
        }
    }

    public void restartDiscoveryEngine()
    {
        deviceUnavailable(false);
        Device.getInstance().refreshBoundIPAddress();
        deviceAvailable();
    }

    public void deviceAvailable()
    {
        log.debug_(String.format("UPNP device %s (%s) is available", cast(Object[])[ Device.getInstance().getUuid(), Device.getInstance().getBindAddress().getHostAddress() ]));


        this.discoverySearchListenerThread = ServiioThreadFactory.getInstance().newThread(this.discoverySSDPMessageListener, "DiscoverySSDPMessageListener", true);
        this.discoverySearchListenerThread.setPriority(10);
        this.discoverySearchListenerThread.start();

        this.subscriptionExpiryCheckerThread = ServiioThreadFactory.getInstance().newThread(this.subscriptionExpiryChecker, "SubscriptionExpiryChecker", true);
        this.subscriptionExpiryCheckerThread.start();

        this.eventDispatcherThread = ServiioThreadFactory.getInstance().newThread(this.eventDispatcher, "EventDispatcher", true);
        this.eventDispatcherThread.start();

        this.discoveryNotifierThread = ServiioThreadFactory.getInstance().newThread(this.discoveryNotifier, "DiscoveryNotifier", true);
        this.discoveryNotifierThread.setPriority(10);
        this.discoveryNotifierThread.start();

        RendererManager.getInstance().startExpirationChecker();
        this.wakeUpMonitorSchedule = this.wakeUpMonitorExecutor.scheduleWithFixedDelay(this.wakeUpMonitor, 10000L, 10000L, TimeUnit.MILLISECONDS);
    }

    public void deviceUnavailable(bool multicast)
    {
        log.debug_(String.format("UPNP device %s (%s) is unavailable", cast(Object[])[ Device.getInstance().getUuid(), Device.getInstance().getBindAddress().getHostAddress() ]));
        try
        {
            if (this.wakeUpMonitorSchedule !is null)
            {
                this.wakeUpMonitorSchedule.cancel(true);
                this.wakeUpMonitor.reset();
            }
            RendererManager.getInstance().stopExpirationChecker();

            this.discoveryNotifier.stopWorker();
            if (this.discoveryNotifierThread !is null) {
                this.discoveryNotifierThread.interrupt();
            }
            this.discoverySSDPMessageListener.stopWorker();
            if (this.discoverySearchListenerThread !is null) {
                this.discoverySearchListenerThread.interrupt();
            }
            this.subscriptionExpiryChecker.stopWorker();
            if (this.subscriptionExpiryCheckerThread !is null) {
                this.subscriptionExpiryCheckerThread.interrupt();
            }
            this.eventDispatcher.stopWorker();
            if (this.eventDispatcherThread !is null) {
                this.eventDispatcherThread.interrupt();
            }
            if (multicast) {
                this.discoveryNotifier.sendByeBye();
            }
        }
        catch (SocketException ex)
        {
            log.warn("Problem during sending 'byebye' message. Advertisement will expire automatically.", ex);
        }
        catch (Exception e)
        {
            log.warn("Problem during sending 'byebye' message. Advertisement will expire automatically.", e);
        }
    }

    public void shutDown()
    {
        this.wakeUpMonitorExecutor.shutdownNow();
    }

    public void sendSSDPAlive()
    {
        if (MediaServer.getStatus() == UPnPServerStatus.STARTED) {
            this.discoveryNotifier.sendAlive();
        } else {
            log.warn("UPnPserver is not started, cannot send ALIVE message");
        }
    }

    public void initialize()
    {
        this.discoveryNotifier = new DiscoveryAdvertisementNotifier(getAdvertisementDuration(), this.advertisementSendCount);
        this.discoverySSDPMessageListener = new DiscoverySSDPMessageListener(getAdvertisementDuration());
        this.subscriptionExpiryChecker = new EventSubscriptionExpirationChecker();
        this.eventDispatcher = new EventDispatcher();
    }

    private int getAdvertisementDuration()
    {
        if (ObjectValidator.isEmpty(System.getProperty("serviio.advertisementDuration"))) {
            return 1800;
        }
        return Integer.parseInt(System.getProperty("serviio.advertisementDuration"));
    }

    public int getAdvertisementSendCount()
    {
        return this.advertisementSendCount;
    }

    public void setAdvertisementSendCount(int advertisementSendCount)
    {
        this.advertisementSendCount = advertisementSendCount;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.discovery.DiscoveryManager
* JD-Core Version:    0.7.0.1
*/