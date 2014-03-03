module org.serviio.library.online.ContentURLContainer;

import java.lang.String;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import org.serviio.library.metadata.MediaFileType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ContentURLContainer
{
    private static Logger log;
    private String contentUrl;
    private String thumbnailUrl;
    private MediaFileType fileType = MediaFileType.VIDEO;
    private Date expiresOn;
    private bool expiresImmediately = false;
    private String cacheKey;
    private bool live = false;
    private String userAgent;

    static this()
    {
        log = LoggerFactory.getLogger!(ContentURLContainer);
    }
    public String getContentUrl()
    {
        return this.contentUrl;
    }

    public URL getThumbnailUrl()
    {
        try
        {
            return this.thumbnailUrl !is null ? new URL(this.thumbnailUrl) : null;
        }
        catch (MalformedURLException e)
        {
            log.debug_("Cannot parse thumbnail URL: " + e.getMessage());
        }
        return null;
    }

    public MediaFileType getFileType()
    {
        return this.fileType;
    }

    public void setContentUrl(String contentUrl)
    {
        this.contentUrl = contentUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl)
    {
        this.thumbnailUrl = thumbnailUrl;
    }

    public void setFileType(MediaFileType fileType)
    {
        this.fileType = fileType;
    }

    public Date getExpiresOn()
    {
        return this.expiresOn;
    }

    public void setExpiresOn(Date expiresIn)
    {
        this.expiresOn = expiresIn;
    }

    public bool isExpiresImmediately()
    {
        return this.expiresImmediately;
    }

    public void setExpiresImmediately(bool expiresImmediately)
    {
        this.expiresImmediately = expiresImmediately;
    }

    public String getCacheKey()
    {
        return this.cacheKey;
    }

    public void setCacheKey(String cacheKey)
    {
        this.cacheKey = cacheKey;
    }

    public bool isLive()
    {
        return this.live;
    }

    public void setLive(bool live)
    {
        this.live = live;
    }

    public String getUserAgent()
    {
        return this.userAgent;
    }

    public void setUserAgent(String userAgent)
    {
        this.userAgent = userAgent;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("ContentURLContainer [");
        if (this.fileType !is null) {
            builder.append("fileType=").append(this.fileType).append(", ");
        }
        if (this.contentUrl !is null) {
            builder.append("contentUrl=").append(this.contentUrl).append(", ");
        }
        if (this.thumbnailUrl !is null) {
            builder.append("thumbnailUrl=").append(this.thumbnailUrl).append(", ");
        }
        if (this.expiresOn !is null) {
            builder.append("expiresOn=").append(this.expiresOn).append(", ");
        }
        builder.append("expiresImmediately=").append(this.expiresImmediately).append(", ");
        if (this.cacheKey !is null) {
            builder.append("cacheKey=").append(this.cacheKey).append(", ");
        }
        builder.append("live=").append(this.live).append(", ");
        if (this.userAgent !is null) {
            builder.append("userAgent=").append(this.userAgent);
        }
        builder.append("]");
        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.ContentURLContainer
* JD-Core Version:    0.7.0.1
*/