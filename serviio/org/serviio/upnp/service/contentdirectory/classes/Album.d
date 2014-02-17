module org.serviio.upnp.service.contentdirectory.classes.Album;

import java.net.URI;

public class Album
  : Container
{
  protected String storageMedium;
  protected String description;
  protected String longDescription;
  protected String publisher;
  protected String contributor;
  protected URI relation;
  protected String rights;
  protected String date;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.ALBUM;
  }
  
  public String getStorageMedium()
  {
    return this.storageMedium;
  }
  
  public void setStorageMedium(String storageMedium)
  {
    this.storageMedium = storageMedium;
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
  
  public String getPublisher()
  {
    return this.publisher;
  }
  
  public void setPublisher(String publisher)
  {
    this.publisher = publisher;
  }
  
  public String getContributor()
  {
    return this.contributor;
  }
  
  public void setContributor(String contributor)
  {
    this.contributor = contributor;
  }
  
  public URI getRelation()
  {
    return this.relation;
  }
  
  public void setRelation(URI relation)
  {
    this.relation = relation;
  }
  
  public String getRights()
  {
    return this.rights;
  }
  
  public void setRights(String rights)
  {
    this.rights = rights;
  }
  
  public String getDate()
  {
    return this.date;
  }
  
  public void setDate(String date)
  {
    this.date = date;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.Album
 * JD-Core Version:    0.7.0.1
 */