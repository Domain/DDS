module org.serviio.library.online.metadata.OnlineResourceContainer;

import java.lang.Long;
import java.lang.String;
import java.util.ArrayList;
import java.util.List;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.online.AbstractUrlExtractor;
import org.serviio.util.ObjectValidator;
import org.serviio.library.online.metadata.OnlineCachable;

public abstract class OnlineResourceContainer(T /*: OnlineContainerItem!(?)*/, E /*: AbstractUrlExtractor*/) : OnlineCachable
{
    private Long onlineRepositoryId;
    private String title;
    private String domain;
    private ImageDescriptor thumbnail;
    private List!(T) items = new ArrayList!T();
    private E usedExtractor;

    public this(Long onlineRepositoryId)
    {
        this.onlineRepositoryId = onlineRepositoryId;
    }

    public abstract OnlineRepository toOnlineRepository();

    public String getDisplayName(String repositoryName)
    {
        if (ObjectValidator.isNotEmpty(repositoryName)) {
            return repositoryName;
        }
        if (ObjectValidator.isNotEmpty(getDomain())) {
            return String.format("%s [%s]", cast(Object[])[ getTitle(), getDomain() ]);
        }
        return getTitle();
    }

    public String getTitle()
    {
        return this.title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public List!(T) getItems()
    {
        return this.items;
    }

    public void setItems(List!(T) items)
    {
        this.items = items;
    }

    public Long getOnlineRepositoryId()
    {
        return this.onlineRepositoryId;
    }

    public String getDomain()
    {
        return this.domain;
    }

    public void setDomain(String domain)
    {
        this.domain = domain;
    }

    public ImageDescriptor getThumbnail()
    {
        return this.thumbnail;
    }

    public void setThumbnail(ImageDescriptor thumbnail)
    {
        this.thumbnail = thumbnail;
    }

    public E getUsedExtractor()
    {
        return this.usedExtractor;
    }

    public void setUsedExtractor(E usedExtractor)
    {
        this.usedExtractor = usedExtractor;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.metadata.OnlineResourceContainer
* JD-Core Version:    0.7.0.1
*/