module org.serviio.delivery.TimeoutStreamDelegator;

import java.lang;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;
import org.serviio.ApplicationSettings;
import org.serviio.external.ProcessListener;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryListener;
import org.serviio.delivery.ClosableStreamDelegator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TimeoutStreamDelegator
{
    private static Logger log;
    private static int CLOSE_STREAM_AFTER_READ_INACTIVITY_SEC;
    private static int CLOSE_STREAM_AFTER_CLOSE_INACTIVITY_SEC;
    private InputStream stream;
    private ScheduledExecutorService scheduler;
    private ScheduledFuture!(Object) scheduledFuture;
    private ProcessListener processListener;
    private AtomicReference!(Date) lastBytesRead;
    private Client client;
    private DeliveryListener deliveryListener;
    private bool forceClosing = false;
    private bool closed = false;

    static this()
    {
        log = LoggerFactory.getLogger!(TimeoutStreamDelegator);
        CLOSE_STREAM_AFTER_READ_INACTIVITY_SEC = ApplicationSettings.getIntegerProperty("transcoded_stream_after_read_inactivity_timeout").intValue();
        CLOSE_STREAM_AFTER_CLOSE_INACTIVITY_SEC = ApplicationSettings.getIntegerProperty("transcoded_stream_after_close_inactivity_timeout").intValue();
    }

    public this(InputStream stream, ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing)
    {
        scheduler = Executors.newScheduledThreadPool(1);
        lastBytesRead = new AtomicReference!(Date)(new Date());
        this.stream = stream;
        this.processListener = processListener;
        this.client = client;
        this.deliveryListener = deliveryListener;
        this.forceClosing = forceClosing;
    }

    public /*synchronized*/ void onRead()
    {
        this.lastBytesRead.set(new Date());
        resetReadTimeoutScheduler(CLOSE_STREAM_AFTER_READ_INACTIVITY_SEC);
    }

    public /*synchronized*/ void close()
    {
        if (!this.closed) {
            if ((this.forceClosing) && (!this.processListener.isFinished()))
            {
                reallyClose();
            }
            else if (!this.processListener.isFinished())
            {
                log.debug_(String.format("Scheduling stream stop to happen in %s seconds if there is no traffic", cast(Object[])[ Integer.valueOf(CLOSE_STREAM_AFTER_CLOSE_INACTIVITY_SEC) ]));
                resetReadTimeoutScheduler(CLOSE_STREAM_AFTER_CLOSE_INACTIVITY_SEC);
            }
            else
            {
                (cast(ClosableStreamDelegator)this.stream).closeParent();
                this.closed = true;
            }
        }
    }

    private /*synchronized*/ void reallyClose()
    {
        log.debug_("Closing piped input stream and closing related feeder process");
        try
        {
            (cast(ClosableStreamDelegator)this.stream).closeParent();
        }
        catch (IOException e)
        {
            log.debug_("Error while closing piped stream", e);
        }
        finally
        {
            if (this.processListener !is null) {
                this.processListener.releaseResources();
            }
            if (this.deliveryListener !is null) {
                this.deliveryListener.deliveryComplete(this.client);
            }
            this.scheduler.shutdownNow();
            this.closed = true;
        }
    }

    protected Date getLastBytesRead()
    {
        return cast(Date)this.lastBytesRead.get();
    }

    private /*synchronized*/ void resetReadTimeoutScheduler(int timeout)
    {
        try
        {
            if ((this.scheduledFuture !is null) && (!this.scheduledFuture.isCancelled())) {
                this.scheduledFuture.cancel(true);
            }
            if (!this.scheduler.isShutdown()) {
                this.scheduledFuture = this.scheduler.schedule(new NonClosingPipedInputStreamCompanion(null), timeout, TimeUnit.SECONDS);
            }
        }
        catch (Throwable e)
        {
            log.warn("Failed to restart stream closing monitor. Possible process leaks might occur.", e);
        }
    }

    public bool isClosed()
    {
        return this.closed;
    }

    private class NonClosingPipedInputStreamCompanion : Runnable
    {
        private Date streamClosed = new Date();

        private this() {}

        override public void run()
        {
            if (!this.outer.getLastBytesRead().after(this.streamClosed)) {
                this.outer.reallyClose();
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.TimeoutStreamDelegator
* JD-Core Version:    0.7.0.1
*/