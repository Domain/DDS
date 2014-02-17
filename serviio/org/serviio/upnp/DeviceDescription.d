module org.serviio.upnp.DeviceDescription;

public class DeviceDescription
{
  private String friendlyName;
  private String modelName;
  private String modelNumber;
  private String manufacturer;
  private String extraElements;
  
  public this(String friendlyName, String modelName, String modelNumber, String manufacturer, String extraElements)
  {
    this.friendlyName = friendlyName;
    this.modelName = modelName;
    this.modelNumber = modelNumber;
    this.extraElements = extraElements;
    this.manufacturer = manufacturer;
  }
  
  public String getFriendlyName()
  {
    return this.friendlyName;
  }
  
  public String getModelName()
  {
    return this.modelName;
  }
  
  public String getModelNumber()
  {
    return this.modelNumber;
  }
  
  public String getExtraElements()
  {
    return this.extraElements;
  }
  
  public String getManufacturer()
  {
    return this.manufacturer;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.DeviceDescription
 * JD-Core Version:    0.7.0.1
 */