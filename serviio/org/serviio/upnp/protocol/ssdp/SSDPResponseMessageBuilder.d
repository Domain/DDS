module org.serviio.upnp.protocol.ssdp.SSDPResponseMessageBuilder;

import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.message.BasicHttpResponse;
import org.serviio.upnp.Device;
import org.serviio.upnp.protocol.ssdp.SSDPMessageBuilder;

public abstract class SSDPResponseMessageBuilder : SSDPMessageBuilder
{
    protected HttpResponse generateBase(Device device)
    {
        HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1, 200, "OK");
        return response;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.ssdp.SSDPResponseMessageBuilder
* JD-Core Version:    0.7.0.1
*/