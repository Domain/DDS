module org.serviio.delivery.NonClosingPipedInputStream;

import java.lang.Runnable;
import java.io.IOException;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NonClosingPipedInputStream : PipedInputStream
{
	private static immutable int CLOSE_STREAM_AFTER_CLOSE_INACTIVITY_SEC;

	private static immutable int CLOSE_STREAM_AFTER_READ_INACTIVITY_SEC;

	private static Logger log;

	private /*final*/ ScheduledExecutorService scheduler;
	private ScheduledFuture!(Object) scheduledFuture;
	private /*final*/ ProcessListener processListener;
	private AtomicReference!(Date) lastBytesRead;
	private Client client;
	private DeliveryListener deliveryListener;
	private bool forceClosing = false;

	private bool closed = false;

	static this()
	{
		CLOSE_STREAM_AFTER_CLOSE_INACTIVITY_SEC = ApplicationSettings.getIntegerProperty("transcoded_stream_after_close_inactivity_timeout").intValue();
		CLOSE_STREAM_AFTER_READ_INACTIVITY_SEC = ApplicationSettings.getIntegerProperty("transcoded_stream_after_read_inactivity_timeout").intValue();
		log = LoggerFactory.getLogger!(NonClosingPipedInputStream)();
	}

	public this(ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing)
	{
		scheduler = Executors.newScheduledThreadPool(1);
		lastBytesRead = new AtomicReference!(Date)(new Date());
		this.processListener = processListener;
		this.client = client;
		this.deliveryListener = deliveryListener;
		this.forceClosing = forceClosing;
	}

	public this(int pipeSize, ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing) 
	{
		scheduler = Executors.newScheduledThreadPool(1);
		lastBytesRead = new AtomicReference!(Date)(new Date());
		super(pipeSize);
		this.processListener = processListener;
		this.client = client;
		this.deliveryListener = deliveryListener;
		this.forceClosing = forceClosing;
	}

	public this(PipedOutputStream src, int pipeSize, ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing) 
	{
		scheduler = Executors.newScheduledThreadPool(1);
		lastBytesRead = new AtomicReference!(Date)(new Date());
		super(src, pipeSize);
		this.processListener = processListener;
		this.client = client;
		this.deliveryListener = deliveryListener;
		this.forceClosing = forceClosing;
	}

	public this(PipedOutputStream src, ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing) 
	{
		scheduler = Executors.newScheduledThreadPool(1);
		lastBytesRead = new AtomicReference!(Date)(new Date());
		super(src);
		this.processListener = processListener;
		this.client = client;
		this.deliveryListener = deliveryListener;
		this.forceClosing = forceClosing;
	}

	override public /*synchronized*/ int read()
	{
		lastBytesRead.set(new Date());
		resetReadTimeoutScheduler(CLOSE_STREAM_AFTER_READ_INACTIVITY_SEC);
		return super.read();
	}

	override public /*synchronized*/ int read(byte[] b, int off, int len)
	{
		lastBytesRead.set(new Date());
		resetReadTimeoutScheduler(CLOSE_STREAM_AFTER_READ_INACTIVITY_SEC);
		return super.read(b, off, len);
	}

	override public /*synchronized*/ void close()
	{
		if (!closed)
			if ((forceClosing) && (!processListener.isFinished()))
			{
				reallyClose();
			}
			else if (!processListener.isFinished())
			{
				log.debug_(String_format("Scheduling stream stop to happen in %s seconds if there is no traffic", cast(Object[])[ Integer.valueOf(CLOSE_STREAM_AFTER_CLOSE_INACTIVITY_SEC) ]));
				resetReadTimeoutScheduler(CLOSE_STREAM_AFTER_CLOSE_INACTIVITY_SEC);
			} else {
				super.close();
				closed = true;
			}
	}

	private synchronized void reallyClose()
	{
		log.debug_("Closing piped input stream and closing related feeder process");
		try {
			super.close();
		} catch (IOException e) {
			log.debug_("Error while closing piped stream", e);
		} finally {
			if (processListener !is null) {
				processListener.releaseResources();
			}
			if (deliveryListener !is null) {
				deliveryListener.deliveryComplete(client);
			}
			scheduler.shutdownNow();
			closed = true;
		}
	}

	protected Date getLastBytesRead() {
		return cast(Date)lastBytesRead.get();
	}

	private synchronized void resetReadTimeoutScheduler(int timeout)
	{
		try {
			if (scheduledFuture !is null) {
				scheduledFuture.cancel(true);
			}

			scheduledFuture = scheduler.schedule(new NonClosingPipedInputStreamCompanion(), timeout, TimeUnit.SECONDS);
		} catch (Throwable e) {
			log.warn("Failed to restart stream closing monitor. Possible process leaks might occur.", e);
		}
	}

	private class NonClosingPipedInputStreamCompanion : Runnable
	{
		private Date streamClosed;

		private this() 
		{
			streamClosed = new Date();
		}

		public void run() 
		{ 
			if (!getLastBytesRead().after(streamClosed))
			{
				this.outer.reallyClose();
			}
		}
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.delivery.NonClosingPipedInputStream
* JD-Core Version:    0.6.2
*/