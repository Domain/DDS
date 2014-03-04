module org.serviio.delivery.resource.transcode.TranscodingDeliveryStrategy;

import java.lang;
import java.io.IOException;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryListener;
import org.serviio.library.entities.MediaItem;
import org.serviio.delivery.resource.transcode.StreamDescriptor;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;

public abstract interface TranscodingDeliveryStrategy//(T)
{
    public abstract StreamDescriptor createInputStream(TranscodingJobListener paramTranscodingJobListener, Long paramLong, TranscodingDefinition paramTranscodingDefinition, Client paramClient, DeliveryListener paramDeliveryListener);

    public abstract TranscodingJobListener invokeTranscoder(String paramString, MediaItem paramMediaItem, Double paramDouble1, Double paramDouble2, TranscodingDefinition paramTranscodingDefinition, Client paramClient, DeliveryListener paramDeliveryListener);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.TranscodingDeliveryStrategy
* JD-Core Version:    0.7.0.1
*/