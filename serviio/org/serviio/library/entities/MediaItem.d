module org.serviio.library.entities.MediaItem;

import java.lang;
import java.util.Date;
import org.serviio.db.entities.PersistedEntity;
import org.serviio.delivery.DeliveryContext;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.AbstractUrlExtractor;
import org.serviio.library.online.OnlineItemId;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.library.entities.CoverImageEntity;

public class MediaItem : PersistedEntity, CoverImageEntity
{
    public static immutable int TITLE_MAX_LENGTH = 128;
    public static immutable int FOURCC_MAX_LENGTH = 6;
    protected String title;
    protected String sortTitle;
    protected Long fileSize;
    protected String fileName;
    protected String filePath;
    protected Date date;
    protected Date lastViewedDate;
    protected Integer numberViewed;
    private Long thumbnailId;
    protected String description;
    protected Integer bookmark;
    protected Long folderId;
    protected Long repositoryId;
    protected MediaFileType fileType;
    protected bool dirty = false;
    private AbstractUrlExtractor onlineResourcePlugin;
    private OnlineItem onlineItem;
    private DeliveryContext deliveryContext = DeliveryContext.local();
    private bool live;

    public this(String title, String fileName, String filePath, Long fileSize, Long folderId, Long repositoryId, Date date, MediaFileType fileType)
    {
        this.title = title;
        this.fileName = fileName;
        this.fileSize = fileSize;
        this.folderId = folderId;
        this.repositoryId = repositoryId;
        this.date = date;
        this.fileType = fileType;
        this.filePath = filePath;
    }

    public bool isLocalMedia()
    {
        return isLocalMedia(getId());
    }

    public static bool isLocalMedia(Long mediaItemId)
    {
        return !OnlineItemId.isOnlineItemId(mediaItemId);
    }

    public String getTitle()
    {
        return this.title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public Long getFileSize()
    {
        return this.fileSize;
    }

    public void setFileSize(Long fileSize)
    {
        this.fileSize = fileSize;
    }

    public String getFileName()
    {
        return this.fileName;
    }

    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }

    public Long getFolderId()
    {
        return this.folderId;
    }

    public void setFolderId(Long folderId)
    {
        this.folderId = folderId;
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
        this.description = description;
    }

    public MediaFileType getFileType()
    {
        return this.fileType;
    }

    public bool isDirty()
    {
        return this.dirty;
    }

    public void setDirty(bool dirty)
    {
        this.dirty = dirty;
    }

    public String getSortTitle()
    {
        return this.sortTitle;
    }

    public void setSortTitle(String sortTitle)
    {
        this.sortTitle = sortTitle;
    }

    public Date getLastViewedDate()
    {
        return this.lastViewedDate;
    }

    public void setLastViewedDate(Date lastViewedDate)
    {
        this.lastViewedDate = lastViewedDate;
    }

    public Integer getNumberViewed()
    {
        return this.numberViewed;
    }

    public void setNumberViewed(Integer numberViewed)
    {
        this.numberViewed = numberViewed;
    }

    public Long getThumbnailId()
    {
        return this.thumbnailId;
    }

    public void setThumbnailId(Long thumbnailId)
    {
        this.thumbnailId = thumbnailId;
    }

    public Integer getBookmark()
    {
        return this.bookmark;
    }

    public void setBookmark(Integer bookmark)
    {
        this.bookmark = bookmark;
    }

    public AbstractUrlExtractor getOnlineResourcePlugin()
    {
        return this.onlineResourcePlugin;
    }

    public void setOnlineResourcePlugin(AbstractUrlExtractor onlineResourcePlugin)
    {
        this.onlineResourcePlugin = onlineResourcePlugin;
    }

    public OnlineItem getOnlineItem()
    {
        return this.onlineItem;
    }

    public void setOnlineItem(OnlineItem onlineItem)
    {
        this.onlineItem = onlineItem;
    }

    public bool isLive()
    {
        return this.live;
    }

    public void setLive(bool live)
    {
        this.live = live;
    }

    public String getFilePath()
    {
        return this.filePath;
    }

    public void setFilePath(String filePath)
    {
        this.filePath = filePath;
    }

    public Long getRepositoryId()
    {
        return this.repositoryId;
    }

    public void setRepositoryId(Long repositoryId)
    {
        this.repositoryId = repositoryId;
    }

    public DeliveryContext getDeliveryContext()
    {
        return this.deliveryContext;
    }

    public void setDeliveryContext(DeliveryContext deliveryContext)
    {
        this.deliveryContext = deliveryContext;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("MediaItem [fileType=").append(this.fileType).append(", fileName=").append(this.fileName).append("]");
        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.entities.MediaItem
* JD-Core Version:    0.7.0.1
*/