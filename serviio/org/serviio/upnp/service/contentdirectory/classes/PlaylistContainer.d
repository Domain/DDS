module org.serviio.upnp.service.contentdirectory.classes.PlaylistContainer;

public class PlaylistContainer
  : Container
{
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.PLAYLIST_CONTAINER;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.PlaylistContainer
 * JD-Core Version:    0.7.0.1
 */