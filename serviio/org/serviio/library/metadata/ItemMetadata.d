module org.serviio.library.metadata.ItemMetadata;

import java.lang.String;
import java.util.Date;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;

public abstract class ItemMetadata
{
    public static immutable String UNKNOWN_ENTITY = "Unknown";
    protected String title;
    protected String author;
    protected Date date;
    protected String description;
    private bool dirty = false;

    public void fillInUnknownEntries()
    {
        if (ObjectValidator.isEmpty(this.author)) {
            setAuthor("Unknown");
        }
    }

    public void validateMetadata()
    {
        if (ObjectValidator.isEmpty(this.title)) {
            throw new InvalidMetadataException("Title is empty.");
        }
    }

    public String getTitle()
    {
        return this.title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getAuthor()
    {
        return this.author;
    }

    public void setAuthor(String author)
    {
        this.author = author;
    }

    public Date getDate()
    {
        return this.date;
    }

    public void setDate(Date date)
    {
        this.date = date;
    }

    public String getDescription()
    {
        return this.description;
    }

    public void setDescription(String description)
    {
        if (description !is null)
        {
            description = StringUtils.removeNewLineCharacters(description);
            if (description.length() > 1024)
            {
                this.description = (description.substring(0, 1020) + " ...");
                return;
            }
        }
        this.description = description;
    }

    public bool isDirty()
    {
        return this.dirty;
    }

    public void setDirty(bool dirty)
    {
        this.dirty = dirty;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.metadata.ItemMetadata
* JD-Core Version:    0.7.0.1
*/