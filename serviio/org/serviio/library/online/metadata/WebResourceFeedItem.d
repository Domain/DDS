module org.serviio.library.online.metadata.WebResourceFeedItem;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import org.serviio.library.online.WebResourceItem;

public class WebResourceFeedItem
  : OnlineContainerItem!(WebResourceFeed)
  , Serializable
{
  private static final long serialVersionUID = 6334150099157949087L;
  private Map!(String, String) additionalInfo = new HashMap();
  private String parsedItemCacheKey;
  
  public this(WebResourceFeed parent, int order)
  {
    this.parentContainer = parent;
    this.order = order;
  }
  
  public WebResourceItem toContainerItem()
  {
    WebResourceItem item = new WebResourceItem();
    item.setTitle(this.title);
    item.setReleaseDate(this.date);
    item.setAdditionalInfo(this.additionalInfo);
    item.setCacheKey(this.parsedItemCacheKey);
    return item;
  }
  
  public Map!(String, String) getAdditionalInfo()
  {
    return this.additionalInfo;
  }
  
  public String getParsedItemCacheKey()
  {
    return this.parsedItemCacheKey;
  }
  
  public void setParsedItemCacheKey(String parsedItemCacheKey)
  {
    this.parsedItemCacheKey = parsedItemCacheKey;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.metadata.WebResourceFeedItem
 * JD-Core Version:    0.7.0.1
 */