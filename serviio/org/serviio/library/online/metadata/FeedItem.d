module org.serviio.library.online.metadata.FeedItem;

import java.io.Serializable;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class FeedItem
  : OnlineContainerItem!(Feed)
  , Serializable
{
  private static final long serialVersionUID = -1114391919989682022L;
  private Map!(String, URL) links = new HashMap();
  
  public this(Feed parentFeed, int feedOrder)
  {
    this.parentContainer = parentFeed;
    this.order = feedOrder;
  }
  
  public Map!(String, URL) getLinks()
  {
    return this.links;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.metadata.FeedItem
 * JD-Core Version:    0.7.0.1
 */