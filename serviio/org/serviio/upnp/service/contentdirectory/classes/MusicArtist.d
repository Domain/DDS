module org.serviio.upnp.service.contentdirectory.classes.MusicArtist;

import java.net.URI;

public class MusicArtist
  : Person
{
  protected String genre;
  protected URI artistDiscographyURI;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.MUSIC_ARTIST;
  }
  
  public String getGenre()
  {
    return this.genre;
  }
  
  public void setGenre(String genre)
  {
    this.genre = genre;
  }
  
  public URI getArtistDiscographyURI()
  {
    return this.artistDiscographyURI;
  }
  
  public void setArtistDiscographyURI(URI artistDiscographyURI)
  {
    this.artistDiscographyURI = artistDiscographyURI;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.MusicArtist
 * JD-Core Version:    0.7.0.1
 */