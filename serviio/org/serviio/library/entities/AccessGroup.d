module org.serviio.library.entities.AccessGroup;

import java.lang;
import org.serviio.db.entities.PersistedEntity;

public class AccessGroup : PersistedEntity
{
    public static Long NO_LIMIT_ACCESS_GROUP_ID = Long.valueOf(1L);
    public static AccessGroup ANY = new AccessGroup("Any");
    private String name;

    public this(String name)
    {
        this.name = name;
    }

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    override public String toString()
    {
        return this.name;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.entities.AccessGroup
* JD-Core Version:    0.7.0.1
*/