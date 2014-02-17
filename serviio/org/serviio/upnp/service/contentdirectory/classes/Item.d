module org.serviio.upnp.service.contentdirectory.classes.Item;

public abstract class Item
  : DirectoryObject
{
  protected String refID;
  private String dcmInfo;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public String getRefID()
  {
    return this.refID;
  }
  
  public void setRefID(String refID)
  {
    this.refID = refID;
  }
  
  public String getDcmInfo()
  {
    return this.dcmInfo;
  }
  
  public void setDcmInfo(String dcmInfo)
  {
    this.dcmInfo = dcmInfo;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.Item
 * JD-Core Version:    0.7.0.1
 */