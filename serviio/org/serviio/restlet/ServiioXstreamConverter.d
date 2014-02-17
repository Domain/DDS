module org.serviio.restlet.ServiioXstreamConverter;

import org.restlet.data.MediaType;
import org.restlet.ext.xstream.XstreamConverter;
import org.restlet.ext.xstream.XstreamRepresentation;
import org.restlet.representation.Representation;

public class ServiioXstreamConverter
  : XstreamConverter
{
  protected !(T) XstreamRepresentation!(T) create(MediaType mediaType, T source)
  {
    return new ServiioXstreamRepresentation(mediaType, source);
  }
  
  protected !(T) XstreamRepresentation!(T) create(Representation source)
  {
    return new ServiioXstreamRepresentation(source);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.restlet.ServiioXstreamConverter
 * JD-Core Version:    0.7.0.1
 */