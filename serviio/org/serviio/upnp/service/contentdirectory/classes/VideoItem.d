module org.serviio.upnp.service.contentdirectory.classes.VideoItem;

import java.net.URI;
import java.util.Map;
import org.serviio.library.local.ContentType;
import org.serviio.library.local.OnlineDBIdentifier;

public class VideoItem
  : Item
{
  protected String genre;
  protected String longDescription;
  protected String[] producers;
  protected String rating;
  protected String[] actors;
  protected String[] directors;
  protected String description;
  protected String[] publishers;
  protected String language;
  protected URI relation;
  protected String date;
  protected Resource subtitlesUrlResource;
  protected Boolean live;
  protected Map!(OnlineDBIdentifier, String) onlineIdentifiers;
  protected ContentType contentType;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.VIDEO_ITEM;
  }
  
  public String getGenre()
  {
    return this.genre;
  }
  
  public void setGenre(String genre)
  {
    this.genre = genre;
  }
  
  public String getLongDescription()
  {
    return this.longDescription;
  }
  
  public void setLongDescription(String longDescription)
  {
    this.longDescription = longDescription;
  }
  
  public String[] getProducers()
  {
    return this.producers;
  }
  
  public void setProducers(String[] producer)
  {
    this.producers = producer;
  }
  
  public String getRating()
  {
    return this.rating;
  }
  
  public void setRating(String rating)
  {
    this.rating = rating;
  }
  
  public String[] getActors()
  {
    return this.actors;
  }
  
  public void setActors(String[] actor)
  {
    this.actors = actor;
  }
  
  public String[] getDirectors()
  {
    return this.directors;
  }
  
  public void setDirectors(String[] director)
  {
    this.directors = director;
  }
  
  public String getDescription()
  {
    return this.description;
  }
  
  public void setDescription(String description)
  {
    this.description = description;
  }
  
  public String[] getPublishers()
  {
    return this.publishers;
  }
  
  public void setPublishers(String[] publisher)
  {
    this.publishers = publisher;
  }
  
  public String getLanguage()
  {
    return this.language;
  }
  
  public void setLanguage(String language)
  {
    this.language = language;
  }
  
  public URI getRelation()
  {
    return this.relation;
  }
  
  public void setRelation(URI relation)
  {
    this.relation = relation;
  }
  
  public String getDate()
  {
    return this.date;
  }
  
  public void setDate(String date)
  {
    this.date = date;
  }
  
  public Resource getSubtitlesUrlResource()
  {
    return this.subtitlesUrlResource;
  }
  
  public void setSubtitlesUrlResource(Resource subtitlesUrl)
  {
    this.subtitlesUrlResource = subtitlesUrl;
  }
  
  public Boolean getLive()
  {
    return this.live;
  }
  
  public void setLive(Boolean live)
  {
    this.live = live;
  }
  
  public Map!(OnlineDBIdentifier, String) getOnlineIdentifiers()
  {
    return this.onlineIdentifiers;
  }
  
  public void setOnlineIdentifiers(Map!(OnlineDBIdentifier, String) onlineIdentifiers)
  {
    this.onlineIdentifiers = onlineIdentifiers;
  }
  
  public ContentType getContentType()
  {
    return this.contentType;
  }
  
  public void setContentType(ContentType contentType)
  {
    this.contentType = contentType;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.VideoItem
 * JD-Core Version:    0.7.0.1
 */