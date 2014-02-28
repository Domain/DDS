module org.serviio.library.entities.Genre;

import java.lang.String;
import org.serviio.db.entities.PersistedEntity;

public class Genre : PersistedEntity
{
    public static immutable int NAME_MAX_LENGTH = 128;
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
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.entities.Genre
* JD-Core Version:    0.7.0.1
*/