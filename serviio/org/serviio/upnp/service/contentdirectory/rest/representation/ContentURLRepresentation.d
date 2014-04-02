module org.serviio.upnp.service.contentdirectory.rest.representation.ContentURLRepresentation;

import java.lang;
import com.thoughtworks.xstream.annotations.XStreamConverter;
import com.thoughtworks.xstream.converters.extended.ToAttributedValueConverter;
import org.serviio.profile.DeliveryQuality:QualityType;

//@XStreamConverter(/*value=*/ToAttributedValueConverter.class_, /*strings={*/"url"/*}*/)
public class ContentURLRepresentation
{
    private String quality;
    private String url;
    private String resolution;
    private Boolean preferred;
    private Boolean transcoded;
    private Long fileSize;

    public this(QualityType quality, String url)
    {
        this.quality = quality.toString();
        this.url = url;
    }

    public String getQuality()
    {
        return this.quality;
    }

    public void setQuality(String quality)
    {
        this.quality = quality;
    }

    public String getUrl()
    {
        return this.url;
    }

    public void setUrl(String url)
    {
        this.url = url;
    }

    public String getResolution()
    {
        return this.resolution;
    }

    public void setResolution(String resolution)
    {
        this.resolution = resolution;
    }

    public Boolean isPreferred()
    {
        return this.preferred;
    }

    public void setPreferred(Boolean preferred)
    {
        this.preferred = preferred;
    }

    public Boolean isTranscoded()
    {
        return this.transcoded;
    }

    public void setTranscoded(Boolean transcoded)
    {
        this.transcoded = transcoded;
    }

    public Long getFileSize()
    {
        return this.fileSize;
    }

    public void setFileSize(Long fileSize)
    {
        this.fileSize = fileSize;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.ContentURLRepresentation
* JD-Core Version:    0.7.0.1
*/