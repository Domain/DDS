module org.serviio.upnp.protocol.http.StreamSessionInputBuffer;

import java.io.IOException;
import java.io.InputStream;
import org.apache.http.impl.io.AbstractSessionInputBuffer;
import org.apache.http.params.BasicHttpParams;

public class StreamSessionInputBuffer
  : AbstractSessionInputBuffer
{
  public this(InputStream stream, int bufferSize)
  {
    init(stream, bufferSize, new BasicHttpParams());
  }
  
  public bool isDataAvailable(int timeout)
  {
    return true;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.http.StreamSessionInputBuffer
 * JD-Core Version:    0.7.0.1
 */