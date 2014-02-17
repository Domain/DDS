module org.serviio.config.ConfigStorage;

import java.util.Map;

public abstract interface ConfigStorage
{
  public abstract Map!(String, String) readAllConfigurationValues();
  
  public abstract void storeValue(String paramString1, String paramString2);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.config.ConfigStorage
 * JD-Core Version:    0.7.0.1
 */