module org.serviio.upnp.protocol.http.UniversalHttpServerConnection;

import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;
import org.apache.http.HttpEntity;
import org.apache.http.HttpException;
import org.apache.http.HttpRequestFactory;
import org.apache.http.HttpResponse;
import org.apache.http.impl.DefaultHttpServerConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UniversalHttpServerConnection
  : DefaultHttpServerConnection
{
  private static final Logger log = LoggerFactory.getLogger!(UniversalHttpServerConnection);
  private String connectionId;
  private HttpEntity streamedEntity;
  
  public this(String connectionId)
  {
    this.connectionId = connectionId;
    
    log.trace(String.format("Initializing connection %s", cast(Object[])[ connectionId ]));
  }
  
  protected HttpRequestFactory createHttpRequestFactory()
  {
    return new UniversalHttpRequestFactory();
  }
  
  public String getSocketAddress()
  {
    return getSocket().getRemoteSocketAddress().toString();
  }
  
  public void sendResponseEntity(HttpResponse response)
  {
    if ((response.getEntity() !is null) && (response.getEntity() !is null)) {
      this.streamedEntity = response.getEntity();
    }
    super.sendResponseEntity(response);
  }
  
  public void closeEntityStream()
  {
    try
    {
      if ((this.streamedEntity !is null) && (this.streamedEntity.getContent() !is null))
      {
        log.trace(String.format("Closing input stream for connection %s", cast(Object[])[ this.connectionId ]));
        this.streamedEntity.getContent().close();
        this.streamedEntity = null;
      }
    }
    catch (IOException e)
    {
      log.warn(String.format("Cannot close input stream for connection %s: %s", cast(Object[])[ this.connectionId, e.getMessage() ]));
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.http.UniversalHttpServerConnection
 * JD-Core Version:    0.7.0.1
 */