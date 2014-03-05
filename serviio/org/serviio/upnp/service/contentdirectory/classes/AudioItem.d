module org.serviio.upnp.service.contentdirectory.classes.AudioItem;

import java.lang;
import java.net.URI;
import org.serviio.upnp.service.contentdirectory.classes.Item;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public class AudioItem : Item
{
    protected String genre;
    protected String description;
    protected String longDescription;
    protected String publisher;
    protected String language;
    protected URI relation;
    protected String rights;
    protected Boolean live;

    public this(String id, String title)
    {
        super(id, title);
    }

    override public ObjectClassType getObjectClass()
    {
        return ObjectClassType.AUDIO_ITEM;
    }

    public String getGenre()
    {
        return this.genre;
    }

    public void setGenre(String genre)
    {
        this.genre = genre;
    }

    public String getDescription()
    {
        return this.description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getLongDescription()
    {
        return this.longDescription;
    }

    public void setLongDescription(String longDescription)
    {
        this.longDescription = longDescription;
    }

    public String getPublisher()
    {
        return this.publisher;
    }

    public void setPublisher(String publisher)
    {
        this.publisher = publisher;
    }

    public String getLanguage()
    {
        return this.language;
    }

    public void setLanguage(String language)
    {
        this.language = language;
    }

    public URI getRelation()
    {
        return this.relation;
    }

    public void setRelation(URI relation)
    {
        this.relation = relation;
    }

    public String getRights()
    {
        return this.rights;
    }

    public void setRights(String rights)
    {
        this.rights = rights;
    }

    public Boolean getLive()
    {
        return this.live;
    }

    public void setLive(Boolean live)
    {
        this.live = live;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.AudioItem
* JD-Core Version:    0.7.0.1
*/