module org.serviio.delivery.RangeNotSupportedException;

public class RangeNotSupportedException
  : Exception
{
  private static final long serialVersionUID = -1350679542734185819L;
  
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
 * Qualified Name:     org.serviio.delivery.RangeNotSupportedException
 * JD-Core Version:    0.7.0.1
 */