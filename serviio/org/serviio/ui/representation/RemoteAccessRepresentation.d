module org.serviio.ui.representation.RemoteAccessRepresentation;

import org.serviio.profile.DeliveryQuality:QualityType;

public class RemoteAccessRepresentation
{
  private String remoteUserPassword;
  private DeliveryQuality.QualityType preferredRemoteDeliveryQuality;
  private bool portMappingEnabled;
  private String externalAddress;
  
  public String getRemoteUserPassword()
  {
    return this.remoteUserPassword;
  }
  
  public void setRemoteUserPassword(String remoteUserPassword)
  {
    this.remoteUserPassword = remoteUserPassword;
  }
  
  public DeliveryQuality.QualityType getPreferredRemoteDeliveryQuality()
  {
    return this.preferredRemoteDeliveryQuality;
  }
  
  public void setPreferredRemoteDeliveryQuality(DeliveryQuality.QualityType preferredRemoteDeliveryQuality)
  {
    this.preferredRemoteDeliveryQuality = preferredRemoteDeliveryQuality;
  }
  
  public bool isPortMappingEnabled()
  {
    return this.portMappingEnabled;
  }
  
  public void setPortMappingEnabled(bool portMappingEnabled)
  {
    this.portMappingEnabled = portMappingEnabled;
  }
  
  public String getExternalAddress()
  {
    return this.externalAddress;
  }
  
  public void setExternalAddress(String externalAddress)
  {
    this.externalAddress = externalAddress;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.RemoteAccessRepresentation
 * JD-Core Version:    0.7.0.1
 */