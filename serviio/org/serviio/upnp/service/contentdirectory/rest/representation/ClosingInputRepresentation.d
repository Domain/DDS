module org.serviio.upnp.service.contentdirectory.rest.representation.ClosingInputRepresentation;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.restlet.Context;
import org.restlet.Request;
import org.restlet.data.MediaType;
import org.restlet.engine.Edition;
import org.restlet.engine.io.BioUtils;
import org.restlet.representation.StreamRepresentation;
import org.serviio.util.FileUtils;

public class ClosingInputRepresentation
  : StreamRepresentation
{
  private /*volatile*/ InputStream stream;
  private Long deliveredSize;
  private Request request;
  
  public this(InputStream inputStream, Request request)
  {
    this(inputStream, null, request);
  }
  
  public this(InputStream inputStream, MediaType mediaType, Request request)
  {
    this(inputStream, mediaType, -1L, null, request);
  }
  
  public this(InputStream inputStream, MediaType mediaType, long expectedSize, Long deliveredSize, Request request)
  {
    super(mediaType);
    setSize(expectedSize);
    setTransient(true);
    setStream(inputStream);
    this.request = request;
    this.deliveredSize = deliveredSize;
  }
  
  public InputStream getStream()
  {
    if (Edition.CURRENT != Edition.GWT)
    {
      InputStream result = this.stream;
      setStream(null);
      return result;
    }
    return this.stream;
  }
  
  public String getText()
  {
    return BioUtils.toString(getStream(), getCharacterSet());
  }
  
  public void release()
  {
    this.request.abort();
    if (this.stream !is null)
    {
      try
      {
        this.stream.close();
      }
      catch (IOException e)
      {
        Context.getCurrentLogger().log(Level.WARNING, "Error while releasing the representation.", e);
      }
      this.stream = null;
    }
    super.release();
  }
  
  public void setStream(InputStream stream)
  {
    this.stream = stream;
    setAvailable(stream !is null);
  }
  
  public void write(OutputStream outputStream)
  {
    if (getSize() == -1L) {
      BioUtils.copy(getStream(), outputStream);
    } else if (this.deliveredSize is null) {
      BioUtils.copy(getStream(), outputStream);
    } else {
      FileUtils.copyStream(getStream(), outputStream, this.deliveredSize.longValue());
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.ClosingInputRepresentation
 * JD-Core Version:    0.7.0.1
 */