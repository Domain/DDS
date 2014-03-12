module org.serviio.licensing.CustomerLicenseProvider;

import java.lang.String;
import org.serviio.config.Configuration;
import org.serviio.licensing.LicenseProvider;

public class CustomerLicenseProvider : LicenseProvider
{
    public String readLicense()
    {
        return Configuration.getCustomerLicense();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.licensing.CustomerLicenseProvider
* JD-Core Version:    0.7.0.1
*/