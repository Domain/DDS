module org.serviio.ui.representation.StatusRepresentation;

import java.util.List;
import org.serviio.UPnPServerStatus;

public class StatusRepresentation
{
  private UPnPServerStatus serverStatus;
  private String boundNICName;
  private bool rendererEnabledByDefault;
  private Long defaultAccessGroupId;
  private List!(RendererRepresentation) renderers;
  
  public UPnPServerStatus getServerStatus()
  {
    return this.serverStatus;
  }
  
  public void setServerStatus(UPnPServerStatus uPnPServerStatus)
  {
    this.serverStatus = uPnPServerStatus;
  }
  
  public String getBoundNICName()
  {
    return this.boundNICName;
  }
  
  public void setBoundNICName(String boundNICName)
  {
    this.boundNICName = boundNICName;
  }
  
  public List!(RendererRepresentation) getRenderers()
  {
    return this.renderers;
  }
  
  public void setRenderers(List!(RendererRepresentation) renderers)
  {
    this.renderers = renderers;
  }
  
  public bool isRendererEnabledByDefault()
  {
    return this.rendererEnabledByDefault;
  }
  
  public void setRendererEnabledByDefault(bool rendererEnabledByDefault)
  {
    this.rendererEnabledByDefault = rendererEnabledByDefault;
  }
  
  public Long getDefaultAccessGroupId()
  {
    return this.defaultAccessGroupId;
  }
  
  public void setDefaultAccessGroupId(Long defaultAccessGroupId)
  {
    this.defaultAccessGroupId = defaultAccessGroupId;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.StatusRepresentation
 * JD-Core Version:    0.7.0.1
 */