module org.serviio.upnp.service.contentdirectory.classes.MusicGenre;

public class MusicGenre
  : Genre
{
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.MUSIC_GENRE;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.MusicGenre
 * JD-Core Version:    0.7.0.1
 */