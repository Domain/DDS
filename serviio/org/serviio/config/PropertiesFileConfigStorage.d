module org.serviio.config.PropertiesFileConfigStorage;

import java.lang.String;
import java.lang.Class;
import java.util.HashMap;
import java.util.Map;
import java.util.Map:Entry;
import java.util.Properties;
import org.serviio.config.ConfigStorage;

public class PropertiesFileConfigStorage : ConfigStorage
{
    private Properties properties;

    public this()
    {
        this.properties = new Properties();
        try
        {
            this.properties.load(/*PropertiesFileConfigStorage.class_*/Class.getResourceAsStream("/configuration.properties"));
        }
        catch (Exception e) {}
    }

    public Map!(String, String) readAllConfigurationValues()
    {
        Map!(String, String) values = new HashMap!(String, String)();
        foreach (Entry!(String, String) value ; this.properties.entrySet()) {
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