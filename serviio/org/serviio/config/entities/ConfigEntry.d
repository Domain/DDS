module org.serviio.config.entities.ConfigEntry;

import java.lang.String;

import org.serviio.db.entities.PersistedEntity;

public class ConfigEntry : PersistedEntity
{
    private String name;
    private String value;

    public this(String name, String value)
    {
        this.name = name;
        this.value = value;
    }

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getValue()
    {
        return this.value;
    }

    public void setValue(String value)
    {
        this.value = value;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.config.entities.ConfigEntry
* JD-Core Version:    0.7.0.1
*/