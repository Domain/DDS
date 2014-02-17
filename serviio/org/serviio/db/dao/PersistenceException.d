module org.serviio.db.dao.PersistenceException;

public class PersistenceException
  : RuntimeException
{
  private static final long serialVersionUID = 5322751026922794882L;
  
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
 * Qualified Name:     org.serviio.db.dao.PersistenceException
 * JD-Core Version:    0.7.0.1
 */