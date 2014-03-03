module org.serviio.renderer.RendererExpirationChecker;

import java.lang.Runnable;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.serviio.util.ThreadUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RendererExpirationChecker : Runnable
{
    private static Logger log;
    private static immutable int CHECK_FREQUENCY = 5000;
    private bool workerRunning = false;

    static this()
    {
        log = LoggerFactory.getLogger!(RendererExpirationChecker);
    }

    public void run()
    {
        log.info("Starting RendererExpirationChecker");
        this.workerRunning = true;
        Calendar currentDate = new GregorianCalendar();
        while (this.workerRunning)
        {
            currentDate.setTime(new Date());
            Map!(String, ActiveRenderer) renderersMap = RendererManager.getInstance().getActiveRenderers();
            Set!(String) uuids = renderersMap.keySet();
            synchronized (renderersMap)
            {
                Iterator!(String) i = uuids.iterator();
                while (i.hasNext())
                {
                    String uuid = cast(String)i.next();
                    ActiveRenderer activeRenderer = cast(ActiveRenderer)renderersMap.get(uuid);
                    int ttl = activeRenderer.getTimeToLive();
                    Calendar expirationDate = new GregorianCalendar();
                    expirationDate.setTime(activeRenderer.getLastUpdated());
                    expirationDate.add(13, ttl);
                    if (expirationDate.compareTo(currentDate) < 0)
                    {
                        log.debug_(String.format("Removing renderer %s from list of active renderers (expired)", cast(Object[])[ uuid ]));
                        i.remove();
                    }
                }
            }
            ThreadUtils.currentThreadSleep(5000L);
        }
        log.info("Leaving RendererExpirationChecker");
    }

    public void stopWorker()
    {
        this.workerRunning = false;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.renderer.RendererExpirationChecker
* JD-Core Version:    0.7.0.1
*/