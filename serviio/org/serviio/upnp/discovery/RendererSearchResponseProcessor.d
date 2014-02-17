module org.serviio.upnp.discovery.RendererSearchResponseProcessor;

import org.serviio.renderer.RendererManager;

public class RendererSearchResponseProcessor
  : Runnable
{
  private String deviceIPAddress;
  private String server;
  private int timeToKeep;
  private String deviceDescriptionURL;
  private String uuid;
  
  public this(String deviceIPAddress, String uuid, String server, int timeToKeep, String deviceDescriptionURL)
  {
    this.deviceIPAddress = deviceIPAddress;
    this.uuid = uuid;
    this.server = server;
    this.timeToKeep = timeToKeep;
    this.deviceDescriptionURL = deviceDescriptionURL;
  }
  
  public void run()
  {
    RendererManager.getInstance().rendererAvailable(this.uuid, this.deviceIPAddress, this.timeToKeep, this.deviceDescriptionURL, this.server);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.discovery.RendererSearchResponseProcessor
 * JD-Core Version:    0.7.0.1
 */