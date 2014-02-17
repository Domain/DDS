module org.serviio.restlet.AbstractRestfulException;

import java.util.List;

public class AbstractRestfulException
  : RuntimeException
{
  private static final long serialVersionUID = 7485159781915824536L;
  private int errorCode;
  private List!(String) parameters;
  
  public this(int errorCode)
  {
    this(null, null, errorCode, null);
  }
  
  public this(int errorCode, List!(String) parameters)
  {
    this(null, null, errorCode, parameters);
  }
  
  public this(String message, Throwable cause, int errorCode, List!(String) parameters)
  {
    super(message, cause);
    this.errorCode = errorCode;
    this.parameters = parameters;
  }
  
  public this(String message, Throwable cause, int errorCode)
  {
    this(message, cause, errorCode, null);
  }
  
  public this(String message, int errorCode)
  {
    this(message, null, errorCode, null);
  }
  
  public this(Throwable cause, int errorCode)
  {
    this(null, cause, errorCode, null);
  }
  
  public int getErrorCode()
  {
    return this.errorCode;
  }
  
  public List!(String) getParameters()
  {
    return this.parameters;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.restlet.AbstractRestfulException
 * JD-Core Version:    0.7.0.1
 */