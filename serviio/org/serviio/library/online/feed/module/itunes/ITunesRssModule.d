module org.serviio.library.online.feed.module.itunes.ITunesRssModule;

import com.sun.syndication.feed.module.Module;
import java.util.Date;
import java.util.List;

public abstract interface ITunesRssModule
  : Module
{
  public static immutable String URI = "http://itunes.apple.com/rss";
  
  public abstract String getName();
  
  public abstract void setName(String paramString);
  
  public abstract String getArtist();
  
  public abstract void setArtist(String paramString);
  
  public abstract List!(Image) getImages();
  
  public abstract void setImages(List!(Image) paramList);
  
  public abstract Date getReleaseDate();
  
  public abstract void setReleaseDate(Date paramDate);
  
  public abstract Integer getDuration();
  
  public abstract void setDuration(Integer paramInteger);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.feed.module.itunes.ITunesRssModule
 * JD-Core Version:    0.7.0.1
 */