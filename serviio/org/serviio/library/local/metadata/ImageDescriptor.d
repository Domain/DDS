module org.serviio.library.local.metadata.ImageDescriptor;

import java.lang;
import java.net.URL;
import org.apache.commons.imaging.ImageInfo;
import org.apache.commons.imaging.Imaging;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ImageDescriptor
{
    private static Logger log;
    private byte[] imageData;
    private URL imageUrl;
    private String mimeType;
    private Integer width;
    private Integer height;

    static this()
    {
        log = LoggerFactory.getLogger!(ImageDescriptor);
    }

    public this(byte[] imageData, String mimeType)
    {
        this.imageData = imageData;
        this.mimeType = mimeType;
    }

    public this(Integer width, Integer height, byte[] imageData)
    {
        this.width = width;
        this.height = height;
        this.imageData = imageData;
    }

    public this(byte[] imageData)
    {
        try
        {
            ImageInfo imageInfo = Imaging.getImageInfo(imageData);
            this.width = Integer.valueOf(imageInfo.getWidth());
            this.height = Integer.valueOf(imageInfo.getHeight());
            this.mimeType = imageInfo.getMimeType();
        }
        catch (Exception e)
        {
            log.warn("Error retrieving image data: " + e.getMessage());
        }
        this.imageData = imageData;
    }

    public this(URL imageUrl)
    {
        this.imageUrl = imageUrl;
    }

    public byte[] getImageData()
    {
        return this.imageData;
    }

    public String getMimeType()
    {
        return this.mimeType;
    }

    public Integer getWidth()
    {
        return this.width;
    }

    public void setWidth(Integer width)
    {
        this.width = width;
    }

    public Integer getHeight()
    {
        return this.height;
    }

    public void setHeight(Integer height)
    {
        this.height = height;
    }

    public URL getImageUrl()
    {
        return this.imageUrl;
    }

    public void setImageData(byte[] imageData)
    {
        this.imageData = imageData;
    }

    public void setMimeType(String mimeType)
    {
        this.mimeType = mimeType;
    }

    public void setImageUrl(URL imageUrl)
    {
        this.imageUrl = imageUrl;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.ImageDescriptor
* JD-Core Version:    0.7.0.1
*/