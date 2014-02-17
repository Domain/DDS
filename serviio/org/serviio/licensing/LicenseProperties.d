module org.serviio.licensing.LicenseProperties;

public enum LicenseProperties
{
  TYPE,  EDITION,  VERSION,  ID,  NAME,  EMAIL;
  
  private this() {}
  
  public abstract String getName();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.licensing.LicenseProperties
 * JD-Core Version:    0.7.0.1
 */