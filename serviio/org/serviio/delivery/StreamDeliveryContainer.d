module org.serviio.delivery.StreamDeliveryContainer;

import java.io.InputStream;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.DeliveryContainer;
import org.serviio.delivery.ResourceInfo;

public class StreamDeliveryContainer : DeliveryContainer
{
    public static immutable int BUFFER_SIZE = 65536;
    private InputStream fileStream;

    public this(InputStream fileStream, ResourceInfo resourceInfo)
    {
        super(resourceInfo);
        this.fileStream = fileStream;
    }

    public this(InputStream fileStream, ResourceInfo resourceInfo, TranscodingJobListener jobListener)
    {
        super(resourceInfo, jobListener);
        this.fileStream = fileStream;
    }

    public InputStream getFileStream()
    {
        return this.fileStream;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.StreamDeliveryContainer
* JD-Core Version:    0.7.0.1
*/