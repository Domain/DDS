module org.serviio.delivery.resource.DeliveryEngine;

import java.lang.Double;
import java.io.IOException;
import java.util.List;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryContainer;
import org.serviio.delivery.MediaFormatProfileResource;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.library.entities.MediaItem;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ProtocolAdditionalInfo;

public abstract interface DeliveryEngine(RI : MediaFormatProfileResource, MI : MediaItem)
{
    public abstract List!(RI) getMediaInfoForProfile(I : ProtocolAdditionalInfo)(MI paramMI, Profile!I paramProfile);

    public abstract RI getMediaInfoForMediaItem(I : ProtocolAdditionalInfo)(MI paramMI, MediaFormatProfile paramMediaFormatProfile, QualityType paramQualityType, Profile!I paramProfile);

    public abstract DeliveryContainer deliver(I : ProtocolAdditionalInfo)(MI paramMI, MediaFormatProfile paramMediaFormatProfile, QualityType paramQualityType, Double paramDouble1, Double paramDouble2, Client!I paramClient);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.DeliveryEngine
* JD-Core Version:    0.7.0.1
*/