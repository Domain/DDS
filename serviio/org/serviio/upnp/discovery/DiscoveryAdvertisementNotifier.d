module org.serviio.upnp.discovery.DiscoveryAdvertisementNotifier;

import java.io.IOException;
import java.net.InetAddress;
import java.net.MulticastSocket;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.util.List;
import org.serviio.upnp.Device;
import org.serviio.upnp.protocol.ssdp.SSDPMessageBuilderFactory;
import org.serviio.upnp.protocol.ssdp.SSDPMessageBuilderFactory:SSDPMessageType;
import org.serviio.upnp.protocol.ssdp.SSDPRequestMessageBuilder;
import org.serviio.util.DateUtils;
import org.serviio.util.MultiCastUtils;
import org.serviio.util.NicIP;
import org.serviio.util.NumberUtils;
import org.serviio.util.ThreadUtils;
import org.slf4j.Logger;

public class DiscoveryAdvertisementNotifier
  : Multicaster
  , Runnable
{
  private static final int INITIAL_ADV_DELAY = 10000;
  private int advertisementDuration;
  private int advertisementSendCount;
  private bool workerRunning = false;
  private int aliveSentCounter = 0;
  
  public this(int advertisementDuration, int advertisementSendCount)
  {
    this.advertisementDuration = advertisementDuration;
    this.advertisementSendCount = advertisementSendCount;
  }
  
  public void run()
  {
    this.log.info("Starting DiscoveryAdvertisementNotifier");
    



    ThreadUtils.currentThreadSleep(NumberUtils.getRandomInInterval(0, 100));
    
    this.workerRunning = true;
    while (this.workerRunning) {
      try
      {
        long sendStart = System.currentTimeMillis();
        bool sent = sendAlive();
        if (sent)
        {
          long sendDuration = System.currentTimeMillis() - sendStart;
          





          long delay = this.aliveSentCounter < 3 ? 10000L : NumberUtils.getRandomInInterval(this.advertisementDuration * 1000 / 10, this.advertisementDuration * 1000 / 7);
          delay -= sendDuration;
          this.log.debug_(String.format("Will advertise again in %s (advertisement duration is %s sec.)", cast(Object[])[ DateUtils.timeToHHMMSS(delay), Integer.valueOf(this.advertisementDuration) ]));
          
          ThreadUtils.currentThreadSleep(Math.max(0L, delay));
        }
        else
        {
          this.log.warn("Could not advertise the device on any available NIC, will try again");
          ThreadUtils.currentThreadSleep(5000L);
        }
      }
      catch (SocketException e)
      {
        this.log.warn("Problem during retrieving list on NetworkInterfaces, will try again", e);
        ThreadUtils.currentThreadSleep(5000L);
      }
      catch (Exception e)
      {
        this.log.error("Fatal error during DiscoveryAdvertisementNotifier, thread will exit", e);
        this.workerRunning = false;
      }
    }
    this.log.info("Leaving DiscoveryAdvertisementNotifier");
  }
  
  public bool sendAlive()
  {
    NicIP iface = null;
    try
    {
      iface = getBoundNIC();
      sendAliveToSingleInterface(iface);
      this.aliveSentCounter += 1;
      return true;
    }
    catch (SocketTimeoutException ex)
    {
      this.log.debug_("Socket timed out when sending to " + iface.toString() + ": " + ex.getMessage() + ", will try again");
    }
    catch (IOException e)
    {
      this.log.debug_("Problem during DiscoveryAdvertisementNotifier, will try again", e);
    }
    return false;
  }
  
  public void sendByeBye()
  {
    try
    {
      NicIP iface = getBoundNIC();
      sendByeByeToSingleInterface(iface);
    }
    catch (IOException e)
    {
      this.log.warn("Problem sending bye-bye: " + e.getMessage(), e);
    }
  }
  
  public void stopWorker()
  {
    this.workerRunning = false;
  }
  
  private void sendAliveToSingleInterface(NicIP multicastInterface)
  {
    MulticastSocket socket = null;
    Device device = Device.getInstance();
    InetAddress address = multicastInterface.getIp();
    if (address !is null) {
      try
      {
        socket = MultiCastUtils.startMultiCastSocketForSending(multicastInterface.getNic(), address, 32);
        if ((socket !is null) && (socket.isBound()))
        {
          this.log.debug_(String.format("Multicasting SSDP alive using interface %s and address %s, timeout = %s", cast(Object[])[ MultiCastUtils.getInterfaceName(multicastInterface.getNic()), address.getHostAddress(), Integer.valueOf(socket.getSoTimeout()) ]));
          

          List!(String) messages = SSDPMessageBuilderFactory.getInstance().getBuilder(SSDPMessageBuilderFactory.SSDPMessageType.ALIVE).generateSSDPMessages(Integer.valueOf(this.advertisementDuration), null);
          
          this.log.debug_(String.format("Sending %s 'alive' messages describing device %s", cast(Object[])[ Integer.valueOf(messages.size()), device.getUuid() ]));
          foreach (String message ; messages) {
            for (int i = 0; i < this.advertisementSendCount; i++)
            {
              MultiCastUtils.send(message, socket, device.getMulticastGroupAddress());
              ThreadUtils.currentThreadSleep(100L);
            }
          }
        }
        else
        {
          this.log.warn("Cannot multicast SSDP alive message. Not connected to a socket.");
        }
      }
      finally
      {
        MultiCastUtils.stopMultiCastSocket(socket, device.getMulticastGroupAddress(), false);
      }
    }
  }
  
  private void sendByeByeToSingleInterface(NicIP multicastInterface)
  {
    MulticastSocket socket = null;
    Device device = Device.getInstance();
    InetAddress address = multicastInterface.getIp();
    if (address !is null) {
      try
      {
        socket = MultiCastUtils.startMultiCastSocketForSending(multicastInterface.getNic(), address, 32);
        if ((socket !is null) && (socket.isBound()))
        {
          this.log.debug_(String.format("Multicasting SSDP byebye using interface %s and address %s, timeout = %s", cast(Object[])[ MultiCastUtils.getInterfaceName(multicastInterface.getNic()), address.getHostAddress(), Integer.valueOf(socket.getSoTimeout()) ]));
          

          List!(String) messages = SSDPMessageBuilderFactory.getInstance().getBuilder(SSDPMessageBuilderFactory.SSDPMessageType.BYEBYE).generateSSDPMessages(null, null);
          foreach (String message ; messages) {
            for (int i = 0; i < this.advertisementSendCount; i++) {
              MultiCastUtils.send(message, socket, device.getMulticastGroupAddress());
            }
          }
        }
        else
        {
          this.log.warn("Cannot multicast SSDP byebye message. Not connected to a socket.");
        }
      }
      finally
      {
        MultiCastUtils.stopMultiCastSocket(socket, device.getMulticastGroupAddress(), false);
      }
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.discovery.DiscoveryAdvertisementNotifier
 * JD-Core Version:    0.7.0.1
 */