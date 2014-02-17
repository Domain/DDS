module org.serviio.restlet.ValidationException;

import java.util.List;

public class ValidationException
  : AbstractRestfulException
{
  private static final long serialVersionUID = -926366811526462237L;
  
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
  
  public this(String message, Throwable cause, int errorCode, List!(String) parameters)
  {
    super(message, cause, errorCode, parameters);
  }
  
  public this(Throwable cause, int errorCode)
  {
    super(cause, errorCode);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.restlet.ValidationException
 * JD-Core Version:    0.7.0.1
 */