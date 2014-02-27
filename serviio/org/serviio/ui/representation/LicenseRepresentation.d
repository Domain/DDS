module org.serviio.ui.representation.LicenseRepresentation;

import org.serviio.licensing.LicensingManager:ServiioLicenseType;

public class LicenseRepresentation
{
    private String id;
    private LicensingManager.ServiioLicenseType type;
    private String name;
    private String email;
    private Integer expiresInMinutes;

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public LicensingManager.ServiioLicenseType getType()
    {
        return this.type;
    }

    public void setType(LicensingManager.ServiioLicenseType type)
    {
        this.type = type;
    }

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getEmail()
    {
        return this.email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public Integer getExpiresInMinutes()
    {
        return this.expiresInMinutes;
    }

    public void setExpiresInMinutes(Integer expiresInMinutes)
    {
        this.expiresInMinutes = expiresInMinutes;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.LicenseRepresentation
* JD-Core Version:    0.7.0.1
*/