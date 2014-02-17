module org.serviio.upnp.service.contentdirectory.classes.Genre;

public class Genre
  : Container
{
  protected String description;
  protected String longDescription;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.GENRE;
  }
  
  public String getDescription()
  {
    return this.description;
  }
  
  public void setDescription(String description)
  {
    this.description = description;
  }
  
  public String getLongDescription()
  {
    return this.longDescription;
  }
  
  public void setLongDescription(String longDescription)
  {
    this.longDescription = longDescription;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.Genre
 * JD-Core Version:    0.7.0.1
 */