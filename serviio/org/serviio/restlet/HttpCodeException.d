module org.serviio.restlet.HttpCodeException;

public class HttpCodeException
  : RuntimeException
{
  private static final long serialVersionUID = -4813502921424204318L;
  int httpCode;
  
  public this(int httpCode)
  {
    this.httpCode = httpCode;
  }
  
  public this(int httpCode, String message, Throwable cause)
  {
    super(message, cause);
    this.httpCode = httpCode;
  }
  
  public this(int httpCode, String message)
  {
    super(message);
    this.httpCode = httpCode;
  }
  
  public this(int httpCode, Throwable cause)
  {
    super(cause);
    this.httpCode = httpCode;
  }
  
  public int getHttpCode()
  {
    return this.httpCode;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.restlet.HttpCodeException
 * JD-Core Version:    0.7.0.1
 */