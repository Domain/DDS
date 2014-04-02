module org.serviio.delivery.resource.transcode.LiveManifestTranscodeInputStream;

import java.lang;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import org.serviio.delivery.Client;
import org.serviio.delivery.ClosableStreamDelegator;
import org.serviio.delivery.DeliveryListener;
import org.serviio.delivery.ResourceURLGenerator;
import org.serviio.delivery.TimeoutStreamDelegator;
import org.serviio.external.ProcessListener;
import org.serviio.delivery.resource.transcode.ManifestTranscodeInputStream;
import org.serviio.delivery.resource.transcode.LiveSegmentBasedTranscodingDeliveryStrategy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LiveManifestTranscodeInputStream : ManifestTranscodeInputStream, ClosableStreamDelegator
{
    private static Logger log;
    private static Map!(File, TimeoutStreamDelegator) delegators;
    private TimeoutStreamDelegator closingDelegator;
    private File manifestFile;

    static this()
    {
        log = LoggerFactory.getLogger!(LiveManifestTranscodeInputStream);
        delegators = Collections.synchronizedMap(new HashMap!(File, TimeoutStreamDelegator)());
    }

    public this(ProcessListener processListener, File file, Client client, ResourceURLGenerator urlGenerator, Long resourceId, DeliveryListener deliveryListener, bool forceClosing, LiveSegmentBasedTranscodingDeliveryStrategy.SegmentRemover segmentRemover)
    {
        super(file, client, urlGenerator, resourceId, true, segmentRemover);
        this.manifestFile = file;
        this.closingDelegator = getClosingDelegator(this, processListener, file, client, deliveryListener, forceClosing);
    }

    public synchronized int read()
    {
        this.closingDelegator.onRead();
        return super.read();
    }

    public synchronized int read(byte[] b, int off, int len)
    {
        this.closingDelegator.onRead();
        return super.read(b, off, len);
    }

    public synchronized void close()
    {
        this.closingDelegator.close();
    }

    public void closeParent()
    {
        super.close();
        delegators.remove(this.manifestFile);
    }

    private static synchronized TimeoutStreamDelegator getClosingDelegator(InputStream is_, ProcessListener processListener, File manifestFile, Client client, DeliveryListener deliveryListener, bool forceClosing)
    {
        if (delegators.containsKey(manifestFile))
        {
            log.debug_(String.format("Using existing TimeoutStreamDelegator for file %s", cast(Object[])[ manifestFile.getPath() ]));
            return cast(TimeoutStreamDelegator)delegators.get(manifestFile);
        }
        log.debug_(String.format("Creating new TimeoutStreamDelegator for file %s", cast(Object[])[ manifestFile.getPath() ]));
        TimeoutStreamDelegator closingDelegator = new TimeoutStreamDelegator(is_, processListener, client, deliveryListener, forceClosing);
        delegators.put(manifestFile, closingDelegator);
        return closingDelegator;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.LiveManifestTranscodeInputStream
* JD-Core Version:    0.7.0.1
*/