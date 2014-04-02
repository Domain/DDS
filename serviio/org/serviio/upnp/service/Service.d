module org.serviio.upnp.service.Service;

import java.lang.String;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentSkipListSet;
import org.serviio.upnp.Device;
import org.serviio.upnp.eventing.EventDispatcher;
import org.serviio.upnp.eventing.Subscription;
import org.serviio.upnp.webserver.WebServer;
import org.serviio.upnp.service.StateVariable;

public abstract class Service
{
    protected String serviceId;
    protected String serviceType;
    protected String scpdURL;
    protected String controlURL;
    protected String eventSubURL;
    protected Set!(StateVariable) stateVariables;
    protected Set!(Subscription) eventSubscriptions;

    public this()
    {
        setupService();
        this.scpdURL = resolveDescriptionURL();
        this.controlURL = resolveControlURL();
        this.eventSubURL = resolveEventingURL();
        this.stateVariables = new HashSet!(StateVariable)();
        this.eventSubscriptions = new ConcurrentSkipListSet!(Subscription)();
    }

    protected abstract void setupService();

    public void addEventSubscription(Subscription subscription)
    {
        this.eventSubscriptions.add(subscription);
    }

    public void removeEventSubscription(Subscription subscription)
    {
        this.eventSubscriptions.remove(subscription);
    }

    public Subscription getEventSubscription(String subscriptionId)
    {
        foreach (Subscription sub ; this.eventSubscriptions) {
            if (sub.getUuid().equals(subscriptionId)) {
                return sub;
            }
        }
        return null;
    }

    public Subscription getEventSubscription(URL deliveryURL)
    {
        foreach (Subscription sub ; this.eventSubscriptions) {
            if (sub.getDeliveryURL().equals(deliveryURL)) {
                return sub;
            }
        }
        return null;
    }

    public StateVariable getStateVariable(String name)
    {
        foreach (StateVariable variable ; this.stateVariables) {
            if (variable.getName().equals(name)) {
                return variable;
            }
        }
        return null;
    }

    public void setStateVariable(String name, Object value)
    {
        StateVariable var = getStateVariable(name);
        if (var !is null)
        {
            var.setValue(value);

            EventDispatcher.addEvent(this, var, null);
        }
    }

    public Set!(StateVariable) getStateVariablesWithEventing()
    {
        Set!(StateVariable) variables = new HashSet();
        foreach (StateVariable variable ; this.stateVariables) {
            if (variable.isSupportsEventing()) {
                variables.add(variable);
            }
        }
        return variables;
    }

    public String getShortName()
    {
        return this.serviceId.substring(this.serviceId.lastIndexOf(":") + 1);
    }

    protected String resolveDescriptionURL()
    {
        try
        {
            return new URL("http", Device.getInstance().getBindAddress().getHostAddress(), WebServer.WEBSERVER_PORT.intValue(), "/serviceDescription/" + getShortName()).getPath();
        }
        catch (MalformedURLException e)
        {
            throw new RuntimeException("Cannot resolve Service description URL address. Exiting.");
        }
    }

    protected String resolveControlURL()
    {
        try
        {
            return new URL("http", Device.getInstance().getBindAddress().getHostAddress(), WebServer.WEBSERVER_PORT.intValue(), "/serviceControl").getPath();
        }
        catch (MalformedURLException e)
        {
            throw new RuntimeException("Cannot resolve Service control URL address. Exiting.");
        }
    }

    protected String resolveEventingURL()
    {
        try
        {
            return new URL("http", Device.getInstance().getBindAddress().getHostAddress(), WebServer.WEBSERVER_PORT.intValue(), "/serviceEventing/" + getShortName()).getPath();
        }
        catch (MalformedURLException e)
        {
            throw new RuntimeException("Cannot resolve Service eventing URL address. Exiting.");
        }
    }

    public String getScpdURL()
    {
        return this.scpdURL;
    }

    public String getControlURL()
    {
        return this.controlURL;
    }

    public String getEventSubURL()
    {
        return this.eventSubURL;
    }

    public String getServiceId()
    {
        return this.serviceId;
    }

    public String getServiceType()
    {
        return this.serviceType;
    }

    public Set!(Subscription) getEventSubscriptions()
    {
        return this.eventSubscriptions;
    }

    public override equals_t opEquals(Object obj)
    {
        if ((( cast(Service)obj !is null )) && ((cast(Service)obj).getServiceId().equals(this.serviceId))) {
            return true;
        }
        return false;
    }

    public override hash_t toHash()
    {
        return this.serviceId.hashCode();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.Service
* JD-Core Version:    0.7.0.1
*/