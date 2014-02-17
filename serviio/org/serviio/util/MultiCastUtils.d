module org.serviio.util.MultiCastUtils;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.MulticastSocket;
import java.net.NetworkInterface;
import java.net.SocketAddress;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MultiCastUtils
{
  private static final Logger log = LoggerFactory.getLogger!(MultiCastUtils);
  
  public static MulticastSocket startMultiCastSocketForListening(InetSocketAddress group, NetworkInterface networkInterface, int ttl)
  {
    MulticastSocket socket = new MulticastSocket(group.getPort());
    socket.setTimeToLive(ttl);
    

    socket.setReuseAddress(true);
    socket.joinGroup(group, networkInterface);
    return socket;
  }
  
  public static MulticastSocket startMultiCastSocketForSending(NetworkInterface networkInterface, InetAddress boundAddress, int ttl)
  {
    MulticastSocket socket = new MulticastSocket();
    socket.setTimeToLive(ttl);
    
    socket.setInterface(boundAddress);
    try
    {
      socket.setNetworkInterface(networkInterface);
    }
    catch (SocketException e) {}
    socket.setReuseAddress(true);
    return socket;
  }
  
  public static void stopMultiCastSocket(MulticastSocket socket, InetSocketAddress group, bool leaveGroup)
  {
    if (socket !is null) {
      try
      {
        if (leaveGroup) {
          socket.leaveGroup(group.getAddress());
        }
      }
      catch (Exception ex)
      {
        log.debug_("Problem leaving multicast group", ex);
      }
      finally
      {
        if (!socket.isClosed()) {
          socket.close();
        }
      }
    }
  }
  
  public static DatagramSocket startUniCastSocket()
  {
    DatagramSocket ssdpUniSock = new DatagramSocket();
    return ssdpUniSock;
  }
  
  public static void send(String message, DatagramSocket socket, SocketAddress target)
  {
    byte[] pk = message.getBytes();
    socket.send(new DatagramPacket(pk, pk.length, target));
  }
  
  public static DatagramPacket receive(DatagramSocket socket)
  {
    byte[] buf = new byte[2048];
    DatagramPacket input = new DatagramPacket(buf, buf.length);
    socket.receive(input);
    return input;
  }
  
  public static String getPacketData(DatagramPacket packet)
  {
    String received = new String(packet.getData(), packet.getOffset(), packet.getLength());
    return received;
  }
  
  public static Set!(NetworkInterface) findSuitableInterfaces()
  {
    Set!(NetworkInterface) ifaceList = new HashSet();
    for (Enumeration!(NetworkInterface) ifaces = NetworkInterface.getNetworkInterfaces(); ifaces.hasMoreElements();)
    {
      NetworkInterface iface = cast(NetworkInterface)ifaces.nextElement();
      if ((!iface.isLoopback()) && (!iface.isVirtual()) && (!iface.isPointToPoint()) && (iface.isUp()) && (iface.supportsMulticast()) && (findIPAddresses(iface).size() > 0)) {
        ifaceList.add(iface);
      }
    }
    return ifaceList;
  }
  
  public static Set!(NetworkInterface) findAllAvailableInterfaces()
  {
    Set!(NetworkInterface) ifaceList = new HashSet();
    for (Enumeration!(NetworkInterface) ifaces = NetworkInterface.getNetworkInterfaces(); ifaces.hasMoreElements();)
    {
      NetworkInterface iface = cast(NetworkInterface)ifaces.nextElement();
      if ((!iface.isLoopback()) && (!iface.isPointToPoint()) && (iface.isUp()) && (iface.supportsMulticast()) && (findIPAddresses(iface).size() > 0)) {
        ifaceList.add(iface);
      }
    }
    return ifaceList;
  }
  
  public static List!(NicIP) findIPAddresses(NetworkInterface iface)
  {
    List!(NicIP) ips = new ArrayList();
    int index = 0;
    for (Enumeration!(InetAddress) addresses = iface.getInetAddresses(); addresses.hasMoreElements();)
    {
      InetAddress address = cast(InetAddress)addresses.nextElement();
      if (( cast(Inet4Address)address !is null ))
      {
        ips.add(new NicIP(iface, address, index));
        index++;
      }
    }
    return ips;
  }
  
  public static NicIP findNicIP(InetAddress ipAddress)
  {
    for (Enumeration!(NetworkInterface) ifaces = NetworkInterface.getNetworkInterfaces(); ifaces.hasMoreElements();)
    {
      NetworkInterface iface = cast(NetworkInterface)ifaces.nextElement();
      List!(NicIP) ifaceIps = findIPAddresses(iface);
      foreach (NicIP nicIp ; ifaceIps) {
        if (ipAddress.equals(nicIp.getIp())) {
          return nicIp;
        }
      }
    }
    throw new IOException("No network inferface found for IP " + ipAddress.getHostAddress());
  }
  
  public static Tupple!(NicIP, Boolean) findNicIPWithRetry(InetAddress ipAddress)
  {
    int countdown = 10;
    NicIP nicIP = null;
    bool retried = false;
    do
    {
      try
      {
        nicIP = findNicIP(ipAddress);
      }
      catch (IOException e) {}
      countdown--;
      if ((nicIP is null) && (countdown > 0))
      {
        retried = true;
        log.warn(String.format("Host IP address %s is not available, will try again %s times", cast(Object[])[ ipAddress.getHostAddress(), Integer.valueOf(countdown) ]));
        ThreadUtils.currentThreadSleep(5000L);
      }
    } while ((nicIP is null) && (countdown > 0));
    if (nicIP is null) {
      throw new IOException("No network inferface found for IP " + ipAddress.getHostAddress());
    }
    return new Tupple(nicIP, Boolean.valueOf(retried));
  }
  
  public static String getInterfaceName(NetworkInterface iface)
  {
    if (iface !is null) {
      return String.format("%s (%s)", cast(Object[])[ iface.getName(), iface.getDisplayName() ]);
    }
    return "Unknown";
  }
  
  public static InetAddress getIPAddressForNICWithIndex(String nicWithIndex)
  {
    if (ObjectValidator.isEmpty(nicWithIndex)) {
      return null;
    }
    List!(String) values = CollectionUtils.csvToList(nicWithIndex, "-", false);
    if (values.size() == 2)
    {
      String nicName = cast(String)values.get(0);
      int ipIndex = Integer.valueOf(cast(String)values.get(1)).intValue();
      Enumeration!(NetworkInterface) ifaces;
      try
      {
        for (ifaces = NetworkInterface.getNetworkInterfaces(); ifaces.hasMoreElements();)
        {
          NetworkInterface iface = cast(NetworkInterface)ifaces.nextElement();
          List!(NicIP) ifaceIps = findIPAddresses(iface);
          foreach (NicIP ifaceIp ; ifaceIps) {
            if ((ifaceIp.getNicName() !is null) && (ifaceIp.getNicName().equals(nicName)) && (ifaceIp.getIpIndex() == ipIndex)) {
              return ifaceIp.getIp();
            }
          }
        }
      }
      catch (SocketException e) {}
    }
    log.warn(String.format("Could not find NIC with name '%s'", cast(Object[])[ nicWithIndex ]));
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.util.MultiCastUtils
 * JD-Core Version:    0.7.0.1
 */