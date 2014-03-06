module org.serviio.delivery.ResourceURLGenerator;

import java.lang.String;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.delivery.HostInfo;

public abstract interface ResourceURLGenerator
{
    public abstract String getGeneratedURL(HostInfo paramHostInfo, ResourceType paramResourceType, Long paramLong, MediaFormatProfile paramMediaFormatProfile, Integer paramInteger, QualityType paramQualityType);

    public abstract String getGeneratedURL(HostInfo paramHostInfo, ResourceType paramResourceType, Long paramLong, String paramString);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.ResourceURLGenerator
* JD-Core Version:    0.7.0.1
*/