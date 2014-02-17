module org.serviio.upnp.service.contentdirectory.classes.StorageFolder;

public class StorageFolder
  : Container
{
  protected Long storageUsed;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.STORAGE_FOLDER;
  }
  
  public Long getStorageUsed()
  {
    return this.storageUsed;
  }
  
  public void setStorageUsed(Long storageUsed)
  {
    this.storageUsed = storageUsed;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.StorageFolder
 * JD-Core Version:    0.7.0.1
 */