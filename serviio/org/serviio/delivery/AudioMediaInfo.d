module org.serviio.delivery.AudioMediaInfo;

import org.serviio.dlna.MediaFormatProfile;
import org.serviio.profile.DeliveryQuality.QualityType;

public class AudioMediaInfo
  : MediaFormatProfileResource
{
  private Integer channels;
  private Integer sampleFrequency;
  private Integer bitrate;
  
  public this(Long resourceId, MediaFormatProfile profile, Long fileSize, bool transcoded, bool live, Integer duration, String mimeType, Integer channels, Integer sampleFrequency, Integer bitrate, DeliveryQuality.QualityType quality)
  {
    super(resourceId, profile, fileSize, transcoded, live, duration, mimeType, quality);
    this.channels = channels;
    this.bitrate = bitrate;
    this.sampleFrequency = sampleFrequency;
  }
  
  public Integer getChannels()
  {
    return this.channels;
  }
  
  public Integer getSampleFrequency()
  {
    return this.sampleFrequency;
  }
  
  public Integer getBitrate()
  {
    return this.bitrate;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.AudioMediaInfo
 * JD-Core Version:    0.7.0.1
 */