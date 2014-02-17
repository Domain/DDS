module org.serviio.upnp.service.contentdirectory.classes.MusicAlbum;

import java.net.URI;

public class MusicAlbum
  : Album
{
  protected String artist;
  protected String genre;
  protected String producer;
  protected String toc;
  protected URI albumArtURI;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.MUSIC_ALBUM;
  }
  
  public String getArtist()
  {
    return this.artist;
  }
  
  public void setArtist(String artist)
  {
    this.artist = artist;
  }
  
  public String getGenre()
  {
    return this.genre;
  }
  
  public void setGenre(String genre)
  {
    this.genre = genre;
  }
  
  public String getProducer()
  {
    return this.producer;
  }
  
  public void setProducer(String producer)
  {
    this.producer = producer;
  }
  
  public String getToc()
  {
    return this.toc;
  }
  
  public void setToc(String toc)
  {
    this.toc = toc;
  }
  
  public URI getAlbumArtURI()
  {
    return this.albumArtURI;
  }
  
  public void setAlbumArtURI(URI albumArtURI)
  {
    this.albumArtURI = albumArtURI;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.MusicAlbum
 * JD-Core Version:    0.7.0.1
 */