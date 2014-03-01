module org.serviio.delivery.DeliveryContainer;

import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.ResourceInfo;

public abstract class DeliveryContainer
{
    private ResourceInfo resourceInfo;
    private TranscodingJobListener jobListener;

    public this(ResourceInfo resourceInfo)
    {
        this.resourceInfo = resourceInfo;
    }

    public this(ResourceInfo resourceInfo, TranscodingJobListener jobListener)
    {
        this(resourceInfo);
        this.jobListener = jobListener;
    }

    public ResourceInfo getResourceInfo()
    {
        return this.resourceInfo;
    }

    public TranscodingJobListener getTranscodingJobListener()
    {
        return this.jobListener;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.DeliveryContainer
* JD-Core Version:    0.7.0.1
*/