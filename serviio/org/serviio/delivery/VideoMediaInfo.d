module org.serviio.delivery.VideoMediaInfo;

import org.serviio.dlna.MediaFormatProfile;
import org.serviio.profile.DeliveryQuality:QualityType;

public class VideoMediaInfo : MediaFormatProfileResource
{
    protected Integer width;
    protected Integer height;
    protected Integer bitrate;

    public this(Long resourceId, MediaFormatProfile profile, Long fileSize, Integer width, Integer height, Integer bitrate, bool transcoded, bool live, Integer duration, String mimeType, DeliveryQuality.QualityType quality)
    {
        super(resourceId, profile, fileSize, transcoded, live, duration, mimeType, quality);
        this.width = width;
        this.height = height;
        this.bitrate = bitrate;
    }

    public Integer getWidth()
    {
        return this.width;
    }

    public Integer getHeight()
    {
        return this.height;
    }

    public Integer getBitrate()
    {
        return this.bitrate;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.VideoMediaInfo
* JD-Core Version:    0.7.0.1
*/