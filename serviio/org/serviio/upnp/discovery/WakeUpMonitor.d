module org.serviio.upnp.discovery.WakeUpMonitor;

import java.lang.Runnable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.serviio.upnp.discovery.WakeUpListener;

public class WakeUpMonitor : Runnable
{
    private static Logger log;
    private int minSleepTime;
    private WakeUpListener listener;
    private long lastTimestamp = -1L;

    static this()
    {
        log = LoggerFactory.getLogger!(WakeUpMonitor);
    }

    public this(int minSleepTime, WakeUpListener listener)
    {
        this.minSleepTime = minSleepTime;
        this.listener = listener;
    }

    public void reset()
    {
        this.lastTimestamp = -1L;
    }

    override public void run()
    {
        long currentTimestamp = System.currentTimeMillis();
        if ((this.lastTimestamp > -1L) && (currentTimestamp - this.minSleepTime > this.lastTimestamp))
        {
            log.debug_("System coming out from sleep detected, notifying listeners");
            this.listener.onWakeUp();
        }
        this.lastTimestamp = currentTimestamp;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.discovery.WakeUpMonitor
* JD-Core Version:    0.7.0.1
*/