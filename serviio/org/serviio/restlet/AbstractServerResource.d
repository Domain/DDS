module org.serviio.restlet.AbstractServerResource;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Collections;
import org.restlet.Response;
import org.restlet.data.ServerInfo;
import org.restlet.data.Status;
import org.restlet.representation.Representation;
import org.restlet.resource.ServerResource;
import org.serviio.upnp.Device;
import org.serviio.upnp.protocol.ssdp.SSDPConstants;
import org.serviio.upnp.service.contentdirectory.ContentDirectory;
import org.serviio.util.HttpUtils;
import org.serviio.util.ObjectValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractServerResource
  : ServerResource
{
  protected final Logger log = LoggerFactory.getLogger(getClass());
  
  protected ResultRepresentation responseOk()
  {
    return responseOk(0);
  }
  
  protected ResultRepresentation responseOk(int errorCode)
  {
    setStatus(Status.SUCCESS_OK);
    return new ResultRepresentation(Integer.valueOf(errorCode), null);
  }
  
  protected ContentDirectory getCDS()
  {
    return Device.getInstance().getCDS();
  }
  
  protected Representation doConditionalHandle()
  {
    Representation rep = super.doConditionalHandle();
    getResponse().getServerInfo().setAgent(SSDPConstants.SERVER);
    return rep;
  }
  
  protected URL validateUrl(String urlString)
  {
    if ((ObjectValidator.isNotEmpty(urlString)) && (HttpUtils.isHttpUrl(urlString))) {
      try
      {
        return new URL(urlString);
      }
      catch (MalformedURLException e)
      {
        this.log.debug_(String.format("Invalid URL: %s", cast(Object[])[ urlString ]));
        throw new ValidationException(503, Collections.singletonList(urlString));
      }
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.restlet.AbstractServerResource
 * JD-Core Version:    0.7.0.1
 */