module org.serviio.upnp.webserver.ServiceControlRequestHandler;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPMessage;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpEntityEnclosingRequest;
import org.apache.http.HttpException;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.MethodNotSupportedException;
import org.apache.http.RequestLine;
import org.apache.http.entity.StringEntity;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.serviio.renderer.RendererManager;
import org.serviio.renderer.entities.Renderer;
import org.serviio.upnp.protocol.soap.ServiceInvocationException;
import org.serviio.upnp.protocol.soap.ServiceInvoker;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public class ServiceControlRequestHandler
  : AbstractRequestHandler
{
  protected void checkMethod(HttpRequest request)
  {
    String method = StringUtils.localeSafeToUppercase(request.getRequestLine().getMethod());
    if (!method.equals("POST")) {
      throw new MethodNotSupportedException(method + " method not supported");
    }
  }
  
  protected void handleRequest(HttpRequest request, HttpResponse response, HttpContext context)
  {
    String soapAction = request.getFirstHeader("SOAPACTION").getValue();
    InetAddress clientIPAddress = getCallerIPAddress(context);
    
    this.log.debug_(String.format("ServiceControl request received for action '%s' from %s", cast(Object[])[ soapAction, clientIPAddress.getHostAddress() ]));
    if (( cast(HttpEntityEnclosingRequest)request !is null ))
    {
      Renderer renderer = RendererManager.getInstance().getStoredRendererByIPAddress(clientIPAddress);
      HttpEntity entity = (cast(HttpEntityEnclosingRequest)request).getEntity();
      String entityContent = EntityUtils.toString(entity);
      try
      {
        SOAPMessage resultSOAPMessage = ServiceInvoker.invokeService(soapAction, entityContent, renderer);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        try
        {
          resultSOAPMessage.writeTo(outputStream);
          if (resultSOAPMessage.getSOAPBody().hasFault())
          {
            response.setStatusCode(500);
            this.log.debug_("Returning error SOAP message");
          }
          else
          {
            response.setStatusCode(200);
            this.log.debug_("Returning OK SOAP message");
          }
          response.addHeader("EXT", "");
          StringEntity body = new StringEntity(outputStream.toString("UTF-8"), "UTF-8");
          body.setContentType("text/xml; charset=\"utf-8\"");
          
          response.setEntity(body);
        }
        catch (SOAPException e)
        {
          this.log.error("Cannot write retrieve SOAP response message", e);
          response.setStatusCode(500);
        }
      }
      catch (ServiceInvocationException e)
      {
        this.log.error(String.format("Cannot process control request: %s", cast(Object[])[ e.getMessage() ]), e);
        response.setStatusCode(500);
      }
    }
    else
    {
      this.log.error("HttpRequest doesn't contain any SOAP message");
      response.setStatusCode(500);
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.webserver.ServiceControlRequestHandler
 * JD-Core Version:    0.7.0.1
 */