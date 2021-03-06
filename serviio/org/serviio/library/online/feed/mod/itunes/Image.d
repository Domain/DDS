module org.serviio.library.online.feed.mod.itunes.Image;

import java.lang;
import java.io.Serializable;
import java.net.MalformedURLException;
import java.net.URL;

public class Image : Serializable, Cloneable, Comparable!(Image)
{
    private static enum serialVersionUID = 7603218208987752391L;
    private URL url;
    private Integer width;
    private Integer height;

    public this(URL url, Integer width, Integer height)
    {
        this.url = url;
        this.width = width;
        this.height = height;
    }

    public URL getUrl()
    {
        return this.url;
    }

    public Integer getWidth()
    {
        return this.width;
    }

    public Integer getHeight()
    {
        return this.height;
    }

    public Object clone()
    {
        try
        {
            return new Image(getUrl() !is null ? new URL(getUrl().toString()) : null, getWidth() !is null ? new Integer(getWidth().intValue()) : null, getHeight() !is null ? new Integer(getHeight().intValue()) : null);
        }
        catch (MalformedURLException e) {}
        return null;
    }

    public int compareTo(Image o)
    {
        if ((getWidth() !is null) && (o.getWidth() !is null)) {
            return getWidth().compareTo(o.getWidth());
        }
        if ((getHeight() !is null) && (o.getClass() !is null)) {
            return getHeight().compareTo(o.getHeight());
        }
        return 1;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.feed.module.itunes.Image
* JD-Core Version:    0.7.0.1
*/