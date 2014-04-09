module org.serviio.upnp.protocol.ssdp.RendererSearchMessageBuilder;

import java.lang;
import java.util.ArrayList;
import java.util.List;
import org.apache.http.HttpRequest;
import org.serviio.upnp.protocol.http.HttpMessageBuilder;
import org.serviio.upnp.protocol.ssdp.SSDPRequestMessageBuilder;

public class RendererSearchMessageBuilder : SSDPRequestMessageBuilder
{
    public List!(String) generateSSDPMessages(Integer duration, String searchTarget)
    {
        if ((duration is null) || (duration.intValue() < 0)) {
            throw new InsufficientInformationException(java.lang.String.format("Message wait time includes invalid value: %s", cast(Object[])[ duration ]));
        }
        List!(String) messages = new ArrayList();
        messages.add(HttpMessageBuilder.transformToString(generateMessage("M-SEARCH", duration, searchTarget)));

        return messages;
    }

    protected HttpRequest generateMessage(String method, Integer duration, String searchTarget)
    {
        HttpRequest request = super.generateBase(method);
        request.addHeader("MAN", "\"ssdp:discover\"");
        request.addHeader("MX", Integer.toString(duration.intValue()));
        request.addHeader("ST", searchTarget);
        return request;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.ssdp.RendererSearchMessageBuilder
* JD-Core Version:    0.7.0.1
*/