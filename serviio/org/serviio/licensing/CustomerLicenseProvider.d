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

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.licensing.CustomerLicenseProvider
* JD-Core Version:    0.6.2
*/