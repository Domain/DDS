module org.serviio.upnp.protocol.ssdp.SSDPRequestMessageBuilder;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import org.apache.http.HttpRequest;
import org.apache.http.HttpVersion;
import org.apache.http.message.BasicHttpRequest;
import org.serviio.upnp.Device;

public abstract class SSDPRequestMessageBuilder
  : SSDPMessageBuilder
{
  protected HttpRequest generateBase(String method)
  {
    Device device = Device.getInstance();
    HttpRequest request = new BasicHttpRequest(method, "*", HttpVersion.HTTP_1_1);
    request.addHeader("HOST", device.getMulticastGroupAddress().getAddress().getHostAddress() + ":" + device.getMulticastGroupAddress().getPort());
    
    return request;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.ssdp.SSDPRequestMessageBuilder
 * JD-Core Version:    0.7.0.1
 */