module org.serviio.upnp.protocol.ssdp.DeviceUnavailableMessageBuilder;

import java.lang.String;
import java.lang.Integer;
import java.util.ArrayList;
import java.util.List;
import org.apache.http.HttpRequest;
import org.serviio.upnp.protocol.ssdp.DeviceAliveMessageBuilder;

public class DeviceUnavailableMessageBuilder : DeviceAliveMessageBuilder
{
	override public List!(String) generateSSDPMessages(Integer duration, String searchTarget)
	{
		List!(String) messages = new ArrayList!(String)();
		messages.addAll(generateRootDeviceMessages(duration));
		messages.addAll(generateServicesMessages(duration));
		return messages;
	}

	override protected HttpRequest generateBase(String method, Integer duration)
	{
		HttpRequest request = super.generateBase(method);
		request.addHeader("NTS", "ssdp:byebye");
		return request;
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.ssdp.DeviceUnavailableMessageBuilder
* JD-Core Version:    0.6.2
*/