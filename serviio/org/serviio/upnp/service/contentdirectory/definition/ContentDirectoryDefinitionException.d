module org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionException;

public class ContentDirectoryDefinitionException
  : Exception
{
  private static final long serialVersionUID = 6044486238252166988L;
  
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
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionException
 * JD-Core Version:    0.7.0.1
 */