module org.serviio.delivery.ResourceRetrievalStrategy;

import java.io.FileNotFoundException;
import java.io.IOException;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.profile.DeliveryQuality:QualityType;

public abstract interface ResourceRetrievalStrategy
{
  public abstract DeliveryContainer retrieveResource(Long paramLong, MediaFormatProfile paramMediaFormatProfile, QualityType paramQualityType, String paramString, Double paramDouble1, Double paramDouble2, Client paramClient, bool paramBoolean);
  
  public abstract ResourceInfo retrieveResourceInfo(Long paramLong, MediaFormatProfile paramMediaFormatProfile, QualityType paramQualityType, String paramString, Client paramClient);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.ResourceRetrievalStrategy
 * JD-Core Version:    0.7.0.1
 */