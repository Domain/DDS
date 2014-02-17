module org.serviio.profile.DetectionDefinition;

import java.util.HashMap;
import java.util.Map;

public class DetectionDefinition
{
  public static enum DetectionType
  {
    UPNP_SEARCH,  HTTP_HEADERS;
    
    private this() {}
  }
  
  private Map!(String, String) fieldValues = new HashMap();
  private DetectionType type;
  
  public this(DetectionType type)
  {
    this.type = type;
  }
  
  public Map!(String, String) getFieldValues()
  {
    return this.fieldValues;
  }
  
  public DetectionType getType()
  {
    return this.type;
  }
  
  public void setType(DetectionType type)
  {
    this.type = type;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.profile.DetectionDefinition
 * JD-Core Version:    0.7.0.1
 */