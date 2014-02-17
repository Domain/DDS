module org.serviio.renderer.CannotResolveRendererProfileException;

public class CannotResolveRendererProfileException
  : Exception
{
  private static final long serialVersionUID = -2158509340066161168L;
  
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
 * Qualified Name:     org.serviio.renderer.CannotResolveRendererProfileException
 * JD-Core Version:    0.7.0.1
 */