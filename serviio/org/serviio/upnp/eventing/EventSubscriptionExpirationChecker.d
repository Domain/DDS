module org.serviio.upnp.eventing.EventSubscriptionExpirationChecker;

import java.lang;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.Set;
import org.serviio.upnp.Device;
import org.serviio.upnp.service.Service;
import org.serviio.util.ThreadUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EventSubscriptionExpirationChecker : Runnable
{
    private static Logger log = LoggerFactory.getLogger!(EventSubscriptionExpirationChecker);
    private static immutable int CHECK_FREQUENCY = 2000;
    private bool workerRunning = false;

    override public void run()
    {
        log.info("Starting EventSubscriptionExpirationChecker");
        Device device = Device.getInstance();
        this.workerRunning = true;
        Calendar currentDate = new GregorianCalendar();
        while (this.workerRunning)
        {
            currentDate.setTime(new Date());
            foreach (Service service ; device.getServices())
            {
                Iterator!(Subscription) subscrIt = service.getEventSubscriptions().iterator();
                while (subscrIt.hasNext())
                {
                    Subscription subscription = cast(Subscription)subscrIt.next();
                    if (!subscription.getDuration().equals("infinite")) {
                        try
                        {
                            Integer duration = Integer.valueOf(subscription.getDuration());
                            Calendar expirationDate = new GregorianCalendar();
                            expirationDate.setTime(subscription.getCreated());
                            expirationDate.add(13, duration.intValue());
                            if (expirationDate.compareTo(currentDate) < 0)
                            {
                                subscrIt.remove();
                                log.debug_(String.format("Removed expired subscription %s from service %s", cast(Object[])[ subscription.getUuid(), service.getServiceId() ]));
                            }
                        }
                        catch (NumberFormatException e)
                        {
                            log.warn(String.format("Provided subscription duration is not a number (%s), cancelling the subscription", cast(Object[])[ subscription.getDuration() ]));

                            subscrIt.remove();
                        }
                    }
                }
            }
            ThreadUtils.currentThreadSleep(2000L);
        }
        log.info("Leaving EventSubscriptionExpirationChecker, removing all event subscriptions");

        removeAllSubscriptions();
    }

    public void stopWorker()
    {
        this.workerRunning = false;
    }

    private void removeAllSubscriptions()
    {
        foreach (Service service ; Device.getInstance().getServices())
        {
            Iterator!(Subscription) subscrIt = service.getEventSubscriptions().iterator();
            while (subscrIt.hasNext())
            {
                Subscription subscription = cast(Subscription)subscrIt.next();
                subscrIt.remove();
                log.debug_(String.format("Removed subscription %s from service %s", cast(Object[])[ subscription.getUuid(), service.getServiceId() ]));
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.eventing.EventSubscriptionExpirationChecker
* JD-Core Version:    0.7.0.1
*/