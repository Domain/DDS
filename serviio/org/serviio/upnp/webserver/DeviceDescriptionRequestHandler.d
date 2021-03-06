module org.serviio.upnp.webserver.DeviceDescriptionRequestHandler;

import java.lang.String;
import java.io.IOException;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import org.apache.http.HttpException;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.entity.StringEntity;
import org.apache.http.protocol.HttpContext;
import org.serviio.profile.Profile;
import org.serviio.profile.ProfileManager;
import org.serviio.renderer.RendererManager;
import org.serviio.upnp.Device;
import org.serviio.upnp.protocol.TemplateApplicator;
import org.serviio.util.HttpUtils;
import org.serviio.upnp.webserver.AbstractDescriptionRequestHandler;
import org.slf4j.Logger;

public class DeviceDescriptionRequestHandler : AbstractDescriptionRequestHandler
{
    override protected void handleRequest(HttpRequest request, HttpResponse response, HttpContext context)
    {
        String[] requestFields = getRequestPathFields(getRequestUri(request), "/deviceDescription", null);
        if (requestFields.length > 1)
        {
            response.setStatusCode(404);
            return;
        }
        String deviceId = requestFields[0];
        InetAddress clientIPAddress = getCallerIPAddress(context);

        this.log.debug_(java.lang.String.format("DeviceDescription request received for device %s from %s (headers = %s)", cast(Object[])[ deviceId, clientIPAddress.getHostAddress(), HttpUtils.headersToString(request.getAllHeaders()) ]));
        if (!clientIPAddress.isLoopbackAddress()) {
            RendererManager.getInstance().rendererAvailable(request.getAllHeaders(), clientIPAddress.getHostAddress());
        }
        Device device = Device.getInstance();
        if ((deviceId !is null) && (deviceId.opEquals(device.getUuid())))
        {
            Profile profile = ProfileManager.getProfile(clientIPAddress);

            prepareSuccessfulHttpResponse(request, response);


            Map!(String, Object) dataModel = new HashMap();
            dataModel.put("device", device);
            dataModel.put("deviceDescription", profile.getDeviceDescription());
            dataModel.put("services", device.getServices());
            dataModel.put("smallPngURL", resolveIconURL("smallPNG"));
            dataModel.put("largePngURL", resolveIconURL("largePNG"));
            dataModel.put("smallJpgURL", resolveIconURL("smallJPG"));
            dataModel.put("largeJpgURL", resolveIconURL("largeJPG"));

            String message = TemplateApplicator.applyTemplate("org/serviio/upnp/protocol/templates/deviceDescription.ftl", dataModel);

            StringEntity content = new StringEntity(message, "UTF-8");
            content.setContentType("text/xml");

            response.setEntity(content);
            this.log.debug_(java.lang.String.format("Sending DeviceDescription XML back using profile '%s'", cast(Object[])[ profile ]));
        }
        else
        {
            response.setStatusCode(404);
            this.log.debug_(java.lang.String.format("Device with id %s doesn't exist, sending back 404 error", cast(Object[])[ deviceId ]));
        }
    }

    protected String resolveIconURL(String iconName)
    {
        try
        {
            return new URL("http", Device.getInstance().getBindAddress().getHostAddress(), WebServer.WEBSERVER_PORT.intValue(), "/icon/" + iconName).getPath();
        }
        catch (MalformedURLException e)
        {
            this.log.warn("Cannot resolve Device UPnP icon URL address.");
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.webserver.DeviceDescriptionRequestHandler
* JD-Core Version:    0.7.0.1
*/