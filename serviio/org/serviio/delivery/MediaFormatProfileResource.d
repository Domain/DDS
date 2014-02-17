module org.serviio.delivery.MediaFormatProfileResource;

import org.serviio.dlna.MediaFormatProfile;
import org.serviio.profile.DeliveryQuality.QualityType;

public abstract class MediaFormatProfileResource
  : ResourceInfo
{
  private MediaFormatProfile formatProfile;
  private DeliveryQuality.QualityType quality;
  
  public this(Long resourceId, MediaFormatProfile profile, Long fileSize, bool transcoded, bool live, Integer duration, String mimeType, DeliveryQuality.QualityType quality)
  {
    super(resourceId);
    this.live = live;
    this.formatProfile = profile;
    this.fileSize = fileSize;
    this.transcoded = transcoded;
    this.duration = duration;
    this.mimeType = mimeType;
    this.quality = quality;
  }
  
  public MediaFormatProfile getFormatProfile()
  {
    return this.formatProfile;
  }
  
  public DeliveryQuality.QualityType getQuality()
  {
    return this.quality;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.MediaFormatProfileResource
 * JD-Core Version:    0.7.0.1
 */