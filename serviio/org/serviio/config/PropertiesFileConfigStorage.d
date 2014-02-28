module org.serviio.config.PropertiesFileConfigStorage;

import java.util.HashMap;
import java.util.Map;
import java.util.Map:Entry;
import java.util.Properties;

public class PropertiesFileConfigStorage
  : ConfigStorage
{
  private Properties properties;
  
  public this()
  {
    this.properties = new Properties();
    try
    {
      this.properties.load(PropertiesFileConfigStorage.class_.getResourceAsStream("/configuration.properties"));
    }
    catch (Exception e) {}
  }
  
  public Map!(String, String) readAllConfigurationValues()
  {
    Map!(String, String) values = new HashMap();
    foreach (Map.Entry!(Object, Object) value ; this.properties.entrySet()) {
      values.put(value.getKey().toString(), value.getValue().toString());
    }
    return values;
  }
  
  public void storeValue(String name, String value)
  {
    this.properties.put(name, value);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.config.PropertiesFileConfigStorage
 * JD-Core Version:    0.7.0.1
 */