module org.serviio.upnp.service.contentdirectory.classes.Photo;

public class Photo
  : ImageItem
{
  protected String album;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.PHOTO;
  }
  
  public String getAlbum()
  {
    return this.album;
  }
  
  public void setAlbum(String album)
  {
    this.album = album;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.Photo
 * JD-Core Version:    0.7.0.1
 */