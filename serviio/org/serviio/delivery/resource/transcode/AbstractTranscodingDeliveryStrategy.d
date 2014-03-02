module org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryStrategy;

import java.lang;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import org.serviio.external.FFMPEGWrapper;
import org.serviio.library.entities.MediaItem;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;

public abstract class AbstractTranscodingDeliveryStrategy
{
    protected OutputStream invokeTranscoder(MediaItem mediaItem, Double timeOffsetInSeconds, Double durationInSeconds, File transcodedFile, TranscodingDefinition trDef, TranscodingJobListener jobListener)
    {
        OutputStream transcodedStream = FFMPEGWrapper.transcodeFile(mediaItem, transcodedFile, trDef, jobListener, timeOffsetInSeconds, durationInSeconds);
        return transcodedStream;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryStrategy
* JD-Core Version:    0.7.0.1
*/