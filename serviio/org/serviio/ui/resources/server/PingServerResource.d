module org.serviio.ui.resources.server.PingServerResource;

import org.serviio.restlet.AbstractServerResource;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.ui.resources.PingResource;

public class PingServerResource
  : AbstractServerResource
  , PingResource
{
  public ResultRepresentation ping()
  {
    return responseOk();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.server.PingServerResource
 * JD-Core Version:    0.7.0.1
 */