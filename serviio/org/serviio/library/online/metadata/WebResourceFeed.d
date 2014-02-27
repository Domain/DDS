module org.serviio.library.online.metadata.WebResourceFeed;

import java.io.Serializable;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.online.WebResourceUrlExtractor;

public class WebResourceFeed
  : OnlineResourceContainer!(WebResourceFeedItem, WebResourceUrlExtractor)
  , Serializable
{
  private static final long serialVersionUID = 6479132581531378435L;
  
  public this(Long onlineRepositoryId)
  {
    super(onlineRepositoryId);
  }
  
  public OnlineRepository toOnlineRepository()
  {
    OnlineRepository repo = new OnlineRepository(OnlineRepository.OnlineRepositoryType.WEB_RESOURCE, null, null, null, null);
    repo.setId(getOnlineRepositoryId());
    repo.setThumbnailUrl(getThumbnail() !is null ? getThumbnail().getImageUrl() : null);
    return repo;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.metadata.WebResourceFeed
 * JD-Core Version:    0.7.0.1
 */