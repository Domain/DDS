module org.serviio.licensing.LicensingManager;

import java.lang.String;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import org.serviio.licensing.ServiioLicense;
import org.serviio.licensing.LicenseValidator;

public static enum ServiioEdition
{
    FREE,  PRO
}

public static enum ServiioLicenseType
{
    BETA,  UNLIMITED,  EVALUATION,  NORMAL
}

public class LicensingManager
{
    //private static immutable int LICENSE_UPDATER_INTERVAL_SEC = 3600;
    //private static LicensingManager instance;
    //private ServiioLicense license;
    //
    //private LicenseValidator validator = new LicenseValidator();
    //private ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

    private this()
    {
        //updateLicense();
        //startCheckingThread();
    }

    public static LicensingManager getInstance()
    {
        if (instance is null) {
            instance = new LicensingManager();
        }
        return instance;
    }

    public ServiioLicense validateLicense(String licenseBody)
    {
        //ServiioLicense license = this.validator.validateProvidedLicense(licenseBody);
        //return license;
        return ServiioLicense.FREE_LICENSE;
    }

    public synchronized void updateLicense()
    {
        //this.license = this.validator.getCurrentLicense();
    }

    public bool isProVersion()
    {
        return true;//this.license.getEdition() == ServiioEdition.PRO;
    }

    public ServiioLicense getLicense()
    {
        //return this.license;
        return ServiioLicense.FREE_LICENSE;
    }

    //private void startCheckingThread()
    //{
    //    Runnable checker = new class() Runnable {
    //        public void run()
    //        {
    //            this.outer.updateLicense();
    //        }
    //    };
    //    this.scheduler.scheduleAtFixedRate(checker, 3600L, 3600L, TimeUnit.SECONDS);
    //}
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.licensing.LicensingManager
* JD-Core Version:    0.7.0.1
*/