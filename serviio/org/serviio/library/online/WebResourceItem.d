module org.serviio.library.online.WebResourceItem;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class WebResourceItem
{
  private String title;
  private String cacheKey;
  private Map!(String, String) additionalInfo = new HashMap();
  private Date releaseDate = new Date();
  
  public String getTitle()
  {
    return this.title;
  }
  
  public void setTitle(String title)
  {
    this.title = title;
  }
  
  public Map!(String, String) getAdditionalInfo()
  {
    return this.additionalInfo;
  }
  
  public void setAdditionalInfo(Map!(String, String) additionalInfo)
  {
    this.additionalInfo = additionalInfo;
  }
  
  public Date getReleaseDate()
  {
    return this.releaseDate;
  }
  
  public void setReleaseDate(Date releaseDate)
  {
    this.releaseDate = releaseDate;
  }
  
  public String getCacheKey()
  {
    return this.cacheKey;
  }
  
  public void setCacheKey(String cacheKey)
  {
    this.cacheKey = cacheKey;
  }
  
  public String toString()
  {
    StringBuilder builder = new StringBuilder();
    builder.append("WebResourceItem [title=");
    builder.append(this.title);
    builder.append(", cacheKey=");
    builder.append(this.cacheKey);
    builder.append(", additionalInfo=");
    builder.append(this.additionalInfo);
    builder.append(", releaseDate=");
    builder.append(this.releaseDate);
    builder.append("]");
    return builder.toString();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.WebResourceItem
 * JD-Core Version:    0.7.0.1
 */