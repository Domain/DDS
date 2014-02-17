module org.serviio.renderer.ActiveRenderer;

import java.util.Date;
import org.serviio.renderer.entities.Renderer;

public class ActiveRenderer
{
  private Renderer renderer;
  private int timeToLive = 0;
  private Date lastUpdated;
  
  public this(Renderer renderer, int timeToLive, Date lastUpdated)
  {
    this.renderer = renderer;
    this.timeToLive = timeToLive;
    this.lastUpdated = lastUpdated;
  }
  
  public Renderer getRenderer()
  {
    return this.renderer;
  }
  
  public void setRenderer(Renderer renderer)
  {
    this.renderer = renderer;
  }
  
  public int getTimeToLive()
  {
    return this.timeToLive;
  }
  
  public void setTimeToLive(int timeToLive)
  {
    this.timeToLive = timeToLive;
  }
  
  public Date getLastUpdated()
  {
    return this.lastUpdated;
  }
  
  public void setLastUpdated(Date lastUpdated)
  {
    this.lastUpdated = lastUpdated;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.renderer.ActiveRenderer
 * JD-Core Version:    0.7.0.1
 */