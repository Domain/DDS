module org.serviio.ui.representation.ApplicationRepresentation;

import java.lang.String;
import org.serviio.licensing.LicensingManager:ServiioEdition;
import org.serviio.ui.representation.LicenseRepresentation;

public class ApplicationRepresentation
{
    private String updateVersionAvailable;
    private String ver;
    private ServiioEdition edition;
    private LicenseRepresentation license;
    private String databaseUpdateId;

    public String getUpdateVersionAvailable()
    {
        return this.updateVersionAvailable;
    }

    public void setUpdateVersionAvailable(String updateVersionAvailable)
    {
        this.updateVersionAvailable = updateVersionAvailable;
    }

    public String getVersion()
    {
        return this.ver;
    }

    public void setVersion(String ver)
    {
        this.ver = ver;
    }

    public ServiioEdition getEdition()
    {
        return this.edition;
    }

    public void setEdition(ServiioEdition edition)
    {
        this.edition = edition;
    }

    public LicenseRepresentation getLicense()
    {
        return this.license;
    }

    public void setLicense(LicenseRepresentation license)
    {
        this.license = license;
    }

    public String getDatabaseUpdateId()
    {
        return this.databaseUpdateId;
    }

    public void setDatabaseUpdateId(String databaseUpdateId)
    {
        this.databaseUpdateId = databaseUpdateId;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.ApplicationRepresentation
* JD-Core Version:    0.7.0.1
*/