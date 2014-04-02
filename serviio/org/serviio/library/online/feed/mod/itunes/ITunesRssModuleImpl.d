module org.serviio.library.online.feed.mod.itunes.ITunesRssModuleImpl;

//import com.sun.syndication.feed.mod.ModuleImpl;
import java.lang;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.serviio.library.online.feed.mod.itunes.ITunesRssModule;
import org.serviio.library.online.feed.mod.itunes.Image;

public class ITunesRssModuleImpl : /*ModuleImpl, */ITunesRssModule
{
    private static immutable long serialVersionUID = 2678421912344703004L;
    private Date releaseDate;
    private String name;
    private String artist;
    private List!(Image) images = new ArrayList!(Image)();
    private Integer duration;

    public this()
    {
        super(ITunesRssModule.class_, "http://itunes.apple.com/rss");
    }

    public void copyFrom(Object obj)
    {
        ITunesRssModule mod = cast(ITunesRssModule)obj;
        setArtist(mod.getArtist());
        setImages(mod.getImages());
        setName(mod.getName());
        setReleaseDate(mod.getReleaseDate());
        setDuration(mod.getDuration());
    }

    public Class/*!(?)*/ getInterface()
    {
        return ITunesRssModule.class_;
    }

    public Date getReleaseDate()
    {
        return this.releaseDate;
    }

    public void setReleaseDate(Date releaseDate)
    {
        this.releaseDate = releaseDate;
    }

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getArtist()
    {
        return this.artist;
    }

    public void setArtist(String artist)
    {
        this.artist = artist;
    }

    public List!(Image) getImages()
    {
        return this.images;
    }

    public void setImages(List!(Image) images)
    {
        this.images = images;
    }

    public Integer getDuration()
    {
        return this.duration;
    }

    public void setDuration(Integer duration)
    {
        this.duration = duration;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.feed.mod.itunes.ITunesRssModuleImpl
* JD-Core Version:    0.7.0.1
*/