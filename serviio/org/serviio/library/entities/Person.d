module org.serviio.library.entities.Person;

import org.serviio.db.entities.PersistedEntity;

public class Person : PersistedEntity
{
    public static immutable int NAME_MAX_LENGTH = 128;
    private String name;
    private String sortName;
    private String initial;

    public static enum RoleType
    {
        ARTIST,  ACTOR,  DIRECTOR,  WRITER,  PRODUCER,  ALBUM_ARTIST,  COMPOSER
    }

    public this(String name, String sortName, String initial)
    {
        this.name = name;
        this.sortName = sortName;
        this.initial = initial;
    }

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getSortName()
    {
        return this.sortName;
    }

    public void setSortName(String sortName)
    {
        this.sortName = sortName;
    }

    public String getInitial()
    {
        return this.initial;
    }

    public void setInitial(String initial)
    {
        this.initial = initial;
    }

    public String toString()
    {
        return String.format("Person [name=%s, sortName=%s]", cast(Object[])[ this.name, this.sortName ]);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.entities.Person
* JD-Core Version:    0.7.0.1
*/