module org.serviio.restlet.AuthenticationException;

import java.lang.String;
import java.util.List;
import org.serviio.restlet.AbstractRestfulException;

public class AuthenticationException : AbstractRestfulException
{
  private static enum serialVersionUID = 7325697136722794338L;
  
  public this(int errorCode)
  {
    super(errorCode);
  }
  
  public this(int errorCode, List!(String) parameters)
  {
    super(errorCode, parameters);
  }
  
  public this(String message, int errorCode)
  {
    super(message, errorCode);
  }
  
  public this(String message, Throwable cause, int errorCode)
  {
    super(message, cause, errorCode);
  }
  
  public this(Throwable cause, int errorCode)
  {
    super(cause, errorCode);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.restlet.AuthenticationException
 * JD-Core Version:    0.7.0.1
 */