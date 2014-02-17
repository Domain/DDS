module org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;

public class InvalidMediaFormatException
  : Exception
{
  private static final long serialVersionUID = -313705664295140245L;
  
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
 * Qualified Name:     org.serviio.library.local.metadata.extractor.InvalidMediaFormatException
 * JD-Core Version:    0.7.0.1
 */