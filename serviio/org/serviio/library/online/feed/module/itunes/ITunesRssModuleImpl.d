module org.serviio.library.online.feed.module.itunes.ITunesRssModuleImpl;

import com.sun.syndication.feed.module.ModuleImpl;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ITunesRssModuleImpl
  : ModuleImpl
  , ITunesRssModule
{
  private static final long serialVersionUID = 2678421912344703004L;
  private Date releaseDate;
  private String name;
  private String artist;
  private List!(Image) images = new ArrayList();
  private Integer duration;
  
  public this()
  {
    super(ITunesRssModule.class_, "http://itunes.apple.com/rss");
  }
  
  public void copyFrom(Object obj)
  {
    ITunesRssModule module = cast(ITunesRssModule)obj;
    setArtist(module.getArtist());
    setImages(module.getImages());
    setName(module.getName());
    setReleaseDate(module.getReleaseDate());
    setDuration(module.getDuration());
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
 * Qualified Name:     org.serviio.library.online.feed.module.itunes.ITunesRssModuleImpl
 * JD-Core Version:    0.7.0.1
 */