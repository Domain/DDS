module org.serviio.licensing.BundledLicenseProvider;

import java.lang.String;
import java.io.IOException;
import org.serviio.util.FileUtils;
import org.serviio.util.StringUtils;
import org.serviio.licensing.LicenseProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BundledLicenseProvider : LicenseProvider
{
    private static Logger log;
    private static immutable String BUNDLED_LICENSE_CONTENT;

    static this()
    {
        log = LoggerFactory.getLogger!(BundledLicenseProvider);
        BUNDLED_LICENSE_CONTENT = readBundledLicense();
    }

    public String readLicense()
    {
        return BUNDLED_LICENSE_CONTENT;
    }

    private static String readBundledLicense()
    {
        try
        {
            return StringUtils.readStreamAsString(FileUtils.getStreamFromClasspath("/default.lic", LicenseValidator.class_), "UTF-8");
        }
        catch (IOException e)
        {
            log.warn("Cannot find bundled license");
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.licensing.BundledLicenseProvider
* JD-Core Version:    0.7.0.1
*/