module org.serviio.licensing.ServiioLicense;

public class ServiioLicense
{
  private LicensingManager.ServiioEdition edition;
  private LicensingManager.ServiioLicenseType type;
  private String name;
  private String email;
  private String id;
  private String version;
  private Long remainingMillis;
  public static final ServiioLicense FREE_LICENSE = new ServiioLicense(null, LicensingManager.ServiioEdition.FREE, null, null, null, null, null);
  
  public this(String id, LicensingManager.ServiioEdition edition, LicensingManager.ServiioLicenseType type, String name, String email, String version, Long remainingMillis)
  {
    this.id = id;
    this.edition = edition;
    this.type = type;
    this.name = name;
    this.email = email;
    this.version = version;
    this.remainingMillis = remainingMillis;
  }
  
  public bool isBundled()
  {
    return (this.type is null) || (this.type == LicensingManager.ServiioLicenseType.BETA) || (this.type == LicensingManager.ServiioLicenseType.EVALUATION);
  }
  
  public LicensingManager.ServiioEdition getEdition()
  {
    return this.edition;
  }
  
  public LicensingManager.ServiioLicenseType getType()
  {
    return this.type;
  }
  
  public String getName()
  {
    return this.name;
  }
  
  public String getEmail()
  {
    return this.email;
  }
  
  public String getId()
  {
    return this.id;
  }
  
  public String getVersion()
  {
    return this.version;
  }
  
  public Long getRemainingMillis()
  {
    return this.remainingMillis;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.licensing.ServiioLicense
 * JD-Core Version:    0.7.0.1
 */