module org.serviio.delivery.ImageMediaInfo;

import org.serviio.dlna.MediaFormatProfile;
import org.serviio.profile.DeliveryQuality:QualityType;

public class ImageMediaInfo
  : MediaFormatProfileResource
{
  protected Integer width;
  protected Integer height;
  
  public this(Long resourceId, MediaFormatProfile profile, Long fileSize, Integer width, Integer height, bool transcoded, String mimeType, QualityType quality)
  {
    super(resourceId, profile, fileSize, transcoded, false, null, mimeType, quality);
    this.width = width;
    this.height = height;
  }
  
  public Integer getWidth()
  {
    return this.width;
  }
  
  public Integer getHeight()
  {
    return this.height;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.ImageMediaInfo
 * JD-Core Version:    0.7.0.1
 */