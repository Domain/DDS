module org.serviio.library.online.metadata.OnlineContainerItem;

import java.util.Date;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.online.AbstractUrlExtractor;
import org.serviio.library.online.ContentURLContainer;
import org.serviio.library.online.OnlineItemId;

public abstract class OnlineContainerItem/*!(C : OnlineResourceContainer!(?, ?))*/ : OnlineItem
{
    protected int order;
    protected C parentContainer;
    protected Date expiresOn;
    protected bool expiresImmediately = false;
    protected AbstractUrlExtractor plugin;

    protected OnlineItemId generateId()
    {
        return new OnlineItemId(this.parentContainer.getOnlineRepositoryId().longValue(), this.order);
    }

    protected void setPluginOnMediaItem(MediaItem mediaItem)
    {
        if (this.expiresImmediately)
        {
            mediaItem.setOnlineResourcePlugin(this.plugin);
            mediaItem.setOnlineItem(this);
        }
    }

    public MediaItem toMediaItem()
    {
        MediaItem item = super.toMediaItem();
        if (item !is null) {
            setPluginOnMediaItem(item);
        }
        return item;
    }

    public void applyContentUrlContainer(ContentURLContainer extractedUrl, AbstractUrlExtractor urlExtractor)
    {
        if (extractedUrl !is null)
        {
            setContentUrl(extractedUrl.getContentUrl());
            setExpiresOn(extractedUrl.getExpiresOn());
            setExpiresImmediately(extractedUrl.isExpiresImmediately());
            setCacheKey(extractedUrl.getCacheKey());
            setLive(extractedUrl.isLive());
            setType(extractedUrl.getFileType());
            setUserAgent(extractedUrl.getUserAgent());
            if (extractedUrl.getThumbnailUrl() !is null) {
                setThumbnail(new ImageDescriptor(extractedUrl.getThumbnailUrl()));
            }
            setPlugin(urlExtractor);
        }
    }

    public ImageDescriptor getThumbnail()
    {
        ImageDescriptor thumbnail = super.getThumbnail();
        return thumbnail !is null ? thumbnail : this.parentContainer.getThumbnail();
    }

    public Date getExpiresOn()
    {
        return this.expiresOn;
    }

    public void setExpiresOn(Date expiresIn)
    {
        this.expiresOn = expiresIn;
    }

    public bool isExpiresImmediately()
    {
        return this.expiresImmediately;
    }

    public void setExpiresImmediately(bool expiresImmediately)
    {
        this.expiresImmediately = expiresImmediately;
    }

    public AbstractUrlExtractor getPlugin()
    {
        return this.plugin;
    }

    public void setPlugin(AbstractUrlExtractor plugin)
    {
        this.plugin = plugin;
    }

    public int getOrder()
    {
        return this.order;
    }

    public void setOrder(int order)
    {
        this.order = order;
        resetId();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.metadata.OnlineContainerItem
* JD-Core Version:    0.7.0.1
*/