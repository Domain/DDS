module org.serviio.library.online.SingleURLParser;

import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.library.online.metadata.SingleURLItem;
import org.serviio.util.HttpUtils;
import org.slf4j.Logger;

public class SingleURLParser
  : AbstractOnlineItemParser
{
  public SingleURLItem parseItem(OnlineRepository repository)
  {
    SingleURLItem item = new SingleURLItem(repository.getId());
    String[] credentials = null;
    
    item.setType(repository.getFileType());
    item.setContentUrl(repository.getRepositoryUrl());
    item.setTitle(repository.getRepositoryUrl());
    if (repository.getThumbnailUrl() !is null) {
      item.setThumbnail(new ImageDescriptor(repository.getThumbnailUrl()));
    }
    item.setLive(repository.getRepoType() == OnlineRepositoryType.LIVE_STREAM);
    if (HttpUtils.isHttpUrl(repository.getRepositoryUrl())) {
      credentials = HttpUtils.getCredentialsFormUrl(repository.getRepositoryUrl());
    }
    try
    {
      item.fillInUnknownEntries();
      item.validateMetadata();
      alterUrlsWithCredentials(credentials, item);
    }
    catch (InvalidMetadataException e)
    {
      this.log.debug_(String.format("Cannot parse online item %s because of invalid metadata. Message: %s", cast(Object[])[ item.getContentUrl(), e.getMessage() ]));
      
      return null;
    }
    return item;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.SingleURLParser
 * JD-Core Version:    0.7.0.1
 */