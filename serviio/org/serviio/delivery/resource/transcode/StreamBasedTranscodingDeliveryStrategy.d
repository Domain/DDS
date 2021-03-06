module org.serviio.delivery.resource.transcode.StreamBasedTranscodingDeliveryStrategy;

import java.lang;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import org.serviio.ApplicationSettings;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryListener;
import org.serviio.delivery.NonClosingPipedInputStream;
import org.serviio.library.entities.MediaItem;
import org.serviio.util.ThreadUtils;
import org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.TranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.StreamDescriptor;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StreamBasedTranscodingDeliveryStrategy : AbstractTranscodingDeliveryStrategy, TranscodingDeliveryStrategy!(OutputStream)
{
    private static immutable int PIPE_BUFFER_BYTES;
    private static Logger log;

    static this()
    {
        PIPE_BUFFER_BYTES = ApplicationSettings.getIntegerProperty("live_stream_buffer").intValue();
        log = LoggerFactory.getLogger!(StreamBasedTranscodingDeliveryStrategy);
    }

    public StreamDescriptor createInputStream(TranscodingJobListener jobListener, Long resourceId, TranscodingDefinition trDef, Client client, DeliveryListener deliveryListener)
    {
        PipedInputStream pis = jobListener.getTranscodedStream();
        if (pis is null) {
            throw new IOException("Transcoded stream cannot be found, FFmpeg execution probably failed");
        }
        if (pis.available() <= 0)
        {
            int counter = 10;
            while ((pis.available() <= 0) && (counter++ <= 10)) {
                ThreadUtils.currentThreadSleep(1000L);
            }
            if (pis.available() <= 0) {
                log.debug_("Transcoded stream is empty, connection may have been lost");
            }
        }
        else if ((jobListener.isFinished()) && (!jobListener.isSuccessful()))
        {
            throw new IOException("FFmpeg execution failed");
        }
        return new StreamDescriptor(pis, null);
    }

    public TranscodingJobListener invokeTranscoder(String transcodingIdentifier, MediaItem mediaItem, Double timeOffsetInSeconds, Double durationInSeconds, TranscodingDefinition trDef, Client client, DeliveryListener deliveryListener)
    {
        TranscodingJobListener jobListener = new TranscodingJobListener(transcodingIdentifier, false);

        OutputStream transcodedOutput = super.invokeTranscoder(mediaItem, timeOffsetInSeconds, durationInSeconds, null, trDef, jobListener);
        if (transcodedOutput !is null)
        {
            jobListener.setTranscodedStream(new NonClosingPipedInputStream(cast(PipedOutputStream)transcodedOutput, PIPE_BUFFER_BYTES, jobListener, client, deliveryListener, !trDef.getTranscodingConfiguration().isKeepStreamOpen()));

            int retries = 0;
            while ((jobListener.getTranscodedStream().available() <= 0) && (retries++ < 50)) {
                ThreadUtils.currentThreadSleep(500L);
            }
        }
        else
        {
            log.debug_("Live stream doesn't produce any bytes.");
        }
        return jobListener;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.StreamBasedTranscodingDeliveryStrategy
* JD-Core Version:    0.7.0.1
*/