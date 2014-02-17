module org.serviio.upnp.service.contentdirectory.rest.access.NATPMPGateway;

import com.hoodcomputing.natpmp.MapRequestMessage;
import com.hoodcomputing.natpmp.NatPmpDevice;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NATPMPGateway
  : WebGateway
{
  private static final Logger log = LoggerFactory.getLogger!(NATPMPGateway);
  private final NatPmpDevice device;
  
  private this(NatPmpDevice device)
  {
    this.device = device;
  }
  
  public static NATPMPGateway findRouter()
  {
    return new NATPMPGateway(new NatPmpDevice(false));
  }
  
  public void addPortMapping(int externalPort, int internalPort, int leaseDuration)
  {
    log.debug_(String.format("Adding/updating router port mapping (%s -> %s) with lease of %s sec.", cast(Object[])[ Integer.valueOf(externalPort), Integer.valueOf(internalPort), Integer.valueOf(leaseDuration) ]));
    MapRequestMessage map = new MapRequestMessage(true, internalPort, externalPort, leaseDuration, null);
    this.device.enqueueMessage(map);
    this.device.waitUntilQueueEmpty();
  }
  
  public void deletePortMapping(int externalPort, int internalPort)
  {
    log.debug_(String.format("Removing router port mapping (%s -> %s)", cast(Object[])[ Integer.valueOf(externalPort), Integer.valueOf(internalPort) ]));
    MapRequestMessage map = new MapRequestMessage(true, internalPort, externalPort, 0L, null);
    this.device.enqueueMessage(map);
    this.device.waitUntilQueueEmpty();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.access.NATPMPGateway
 * JD-Core Version:    0.7.0.1
 */