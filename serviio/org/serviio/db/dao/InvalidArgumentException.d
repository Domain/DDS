module org.serviio.db.dao.InvalidArgumentException;

public class InvalidArgumentException
  : RuntimeException
{
  private static final long serialVersionUID = 969956618129304694L;
  
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
 * Qualified Name:     org.serviio.db.dao.InvalidArgumentException
 * JD-Core Version:    0.7.0.1
 */