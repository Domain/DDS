module org.serviio.library.entities.Series;

import java.lang;
import org.serviio.db.entities.PersistedEntity;
import org.serviio.library.entities.CoverImageEntity;

public class Series : PersistedEntity, CoverImageEntity
{
    private String title;
    private String sortTitle;
    private Long thumbnailId;

    public this(String title, String sortTitle, Long thumbnailId)
    {
        this.title = title;
        this.sortTitle = sortTitle;
        this.thumbnailId = thumbnailId;
    }

    public String getTitle()
    {
        return this.title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getSortTitle()
    {
        return this.sortTitle;
    }

    public void setSortTitle(String sortTitle)
    {
        this.sortTitle = sortTitle;
    }

    public Long getThumbnailId()
    {
        return this.thumbnailId;
    }

    public void setThumbnailId(Long thumbnailId)
    {
        this.thumbnailId = thumbnailId;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.entities.Series
* JD-Core Version:    0.7.0.1
*/