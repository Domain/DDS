module org.serviio.library.online.metadata.SingleURLItem;

import java.io.Serializable;
import org.serviio.library.online.OnlineItemId;

public class SingleURLItem
  : OnlineItem
  , OnlineCachable, Serializable
{
  private static final long serialVersionUID = -5502211279053449413L;
  private Long repositoryId;
  
  public this(Long repositoryId)
  {
    this.repositoryId = repositoryId;
  }
  
  protected OnlineItemId generateId()
  {
    return new OnlineItemId(this.repositoryId.longValue(), 1);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.metadata.SingleURLItem
 * JD-Core Version:    0.7.0.1
 */