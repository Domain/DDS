module org.serviio.upnp.discovery.Multicaster;

import java.io.IOException;
import java.net.InetAddress;
import org.serviio.upnp.Device;
import org.serviio.util.MultiCastUtils;
import org.serviio.util.NicIP;
import org.serviio.util.Tupple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class Multicaster
{
    protected Logger log;

    static this()
    {
        log = LoggerFactory.getLogger(getClass());
    }

    protected synchronized NicIP getBoundNIC()
    {
        try
        {
            Tupple!(NicIP, Boolean) nicIpResult = MultiCastUtils.findNicIPWithRetry(Device.getInstance().getBindAddress());
            if ((cast(Boolean)nicIpResult.getValueB()).boolValue()) {
                DiscoveryManager.instance().restartDiscoveryEngine();
            }
            return cast(NicIP)nicIpResult.getValueA();
        }
        catch (IOException e)
        {
            this.log.warn(String.format("Cannot acquire NIC for current bound IP address %s, will re-acquire new IP", cast(Object[])[ Device.getInstance().getBindAddress().getHostAddress() ]));
            DiscoveryManager.instance().restartDiscoveryEngine();
        }
        return MultiCastUtils.findNicIP(Device.getInstance().getBindAddress());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.discovery.Multicaster
* JD-Core Version:    0.7.0.1
*/