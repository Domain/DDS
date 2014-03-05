module org.serviio.licensing.InvalidLicenseException;

import java.lang.String;

public class InvalidLicenseException : Exception
{
  private static enum serialVersionUID = 4647228477001777038L;
  
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
 * Qualified Name:     org.serviio.licensing.InvalidLicenseException
 * JD-Core Version:    0.7.0.1
 */