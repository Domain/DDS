module org.serviio.upnp.protocol.http.transport.InvalidResourceRequestException;

public class InvalidResourceRequestException
  : Exception
{
  private static final long serialVersionUID = 3044601649780819077L;
  
  public this() {}
  
  public this(String message, Throwable cause)
  {
    super(message, cause);
  }
  
  public this(String message)
  {
    super(message);
  }
  
  public this(Throwable cause)
  {
    super(cause);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.http.transport.InvalidResourceRequestException
 * JD-Core Version:    0.7.0.1
 */