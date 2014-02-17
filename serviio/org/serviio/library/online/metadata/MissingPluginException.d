module org.serviio.library.online.metadata.MissingPluginException;

public class MissingPluginException
  : Exception
{
  private static final long serialVersionUID = 6221909780982789923L;
  
  public this(String message, Throwable cause)
  {
    super(message, cause);
  }
  
  public this(String message)
  {
    super(message);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.metadata.MissingPluginException
 * JD-Core Version:    0.7.0.1
 */