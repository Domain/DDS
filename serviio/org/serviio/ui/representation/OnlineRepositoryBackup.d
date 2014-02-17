module org.serviio.ui.representation.OnlineRepositoryBackup;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import java.util.LinkedHashSet;
import org.serviio.util.ServiioUri;

public class OnlineRepositoryBackup
  : Comparable!(OnlineRepositoryBackup)
{
  private String serviioLink;
  @XStreamAsAttribute
  private bool enabled;
  @XStreamAsAttribute
  private int order;
  private LinkedHashSet!(Long) accessGroupIds;
  
  public this() {}
  
  public this(ServiioUri serviioLink, bool enabled, int order, LinkedHashSet!(Long) accessGroupIds)
  {
    this.serviioLink = serviioLink.toURI();
    this.enabled = enabled;
    this.accessGroupIds = accessGroupIds;
    this.order = order;
  }
  
  public String getServiioLink()
  {
    return this.serviioLink;
  }
  
  public void setServiioLink(String serviioLink)
  {
    this.serviioLink = serviioLink;
  }
  
  public bool isEnabled()
  {
    return this.enabled;
  }
  
  public void setEnabled(bool enabled)
  {
    this.enabled = enabled;
  }
  
  public LinkedHashSet!(Long) getAccessGroupIds()
  {
    return this.accessGroupIds;
  }
  
  public void setAccessGroupIds(LinkedHashSet!(Long) accessGroupIds)
  {
    this.accessGroupIds = accessGroupIds;
  }
  
  public int getOrder()
  {
    return this.order;
  }
  
  public void setOrder(int order)
  {
    this.order = order;
  }
  
  public int compareTo(OnlineRepositoryBackup o)
  {
    return new Integer(this.order).compareTo(Integer.valueOf(o.getOrder()));
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.OnlineRepositoryBackup
 * JD-Core Version:    0.7.0.1
 */