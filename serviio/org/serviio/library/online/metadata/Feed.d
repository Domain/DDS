module org.serviio.library.online.metadata.Feed;

import java.lang.Long;
import java.io.Serializable;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.online.FeedItemUrlExtractor;
import org.serviio.library.online.metadata.OnlineResourceContainer;
import org.serviio.library.online.metadata.FeedItem;

public class Feed : OnlineResourceContainer!(FeedItem, FeedItemUrlExtractor), Serializable
{
    private static immutable long serialVersionUID = 9081353584351407845L;

    public this(Long onlineRepositoryId)
    {
        super(onlineRepositoryId);
    }

    override public OnlineRepository toOnlineRepository()
    {
        OnlineRepository repo = new OnlineRepository(OnlineRepositoryType.FEED, null, null, null, null);
        repo.setId(getOnlineRepositoryId());
        return repo;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.metadata.Feed
* JD-Core Version:    0.7.0.1
*/