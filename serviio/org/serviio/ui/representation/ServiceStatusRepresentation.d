module org.serviio.ui.representation.ServiceStatusRepresentation;

import org.serviio.MediaServer;

public class ServiceStatusRepresentation
{
  private bool serviceStarted = !MediaServer.isServiceInitializationInProcess();
  
  public bool isServiceStarted()
  {
    return this.serviceStarted;
  }
  
  public void setServiceStarted(bool serviceStarted)
  {
    this.serviceStarted = serviceStarted;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.ServiceStatusRepresentation
 * JD-Core Version:    0.7.0.1
 */