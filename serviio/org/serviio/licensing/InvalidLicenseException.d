module org.serviio.licensing.InvalidLicenseException;

public class InvalidLicenseException
  : Exception
{
  private static final long serialVersionUID = 4647228477001777038L;
  
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