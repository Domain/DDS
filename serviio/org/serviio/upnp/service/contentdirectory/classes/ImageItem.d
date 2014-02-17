module org.serviio.upnp.service.contentdirectory.classes.ImageItem;

public class ImageItem
  : Item
{
  protected String longDescription;
  protected String storageMedium;
  protected String rating;
  protected String description;
  protected String[] publisher;
  protected String date;
  protected String rights;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.IMAGE_ITEM;
  }
  
  public String getLongDescription()
  {
    return this.longDescription;
  }
  
  public void setLongDescription(String longDescription)
  {
    this.longDescription = longDescription;
  }
  
  public String getStorageMedium()
  {
    return this.storageMedium;
  }
  
  public void setStorageMedium(String storageMedium)
  {
    this.storageMedium = storageMedium;
  }
  
  public String getRating()
  {
    return this.rating;
  }
  
  public void setRating(String rating)
  {
    this.rating = rating;
  }
  
  public String getDescription()
  {
    return this.description;
  }
  
  public void setDescription(String description)
  {
    this.description = description;
  }
  
  public String[] getPublisher()
  {
    return this.publisher;
  }
  
  public void setPublisher(String[] publisher)
  {
    this.publisher = publisher;
  }
  
  public String getDate()
  {
    return this.date;
  }
  
  public void setDate(String date)
  {
    this.date = date;
  }
  
  public String getRights()
  {
    return this.rights;
  }
  
  public void setRights(String rights)
  {
    this.rights = rights;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.ImageItem
 * JD-Core Version:    0.7.0.1
 */