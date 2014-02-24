module org.serviio.profile.DeliveryQuality;

import org.serviio.delivery.resource.transcode.TranscodingConfiguration;

public class DeliveryQuality
{
    private QualityType type;
    private TranscodingConfiguration transcodingConfiguration;
    private TranscodingConfiguration onlineTranscodingConfiguration;
    private TranscodingConfiguration hardSubsTranscodingConfiguration;

    public static enum QualityType
    {
        ORIGINAL,  MEDIUM,  LOW
    }

    public this(QualityType type, TranscodingConfiguration transcodingConfiguration, TranscodingConfiguration onlineTranscodingConfiguration, TranscodingConfiguration hardSubsTranscodingConfiguration)
    {
        this.type = type;
        this.transcodingConfiguration = transcodingConfiguration;
        this.onlineTranscodingConfiguration = onlineTranscodingConfiguration;
        this.hardSubsTranscodingConfiguration = hardSubsTranscodingConfiguration;
    }

    public QualityType getType()
    {
        return this.type;
    }

    public TranscodingConfiguration getTranscodingConfiguration()
    {
        return this.transcodingConfiguration;
    }

    public TranscodingConfiguration getOnlineTranscodingConfiguration()
    {
        return this.onlineTranscodingConfiguration;
    }

    public TranscodingConfiguration getHardSubsTranscodingConfiguration()
    {
        return this.hardSubsTranscodingConfiguration;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.profile.DeliveryQuality
* JD-Core Version:    0.7.0.1
*/