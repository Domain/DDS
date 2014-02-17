module org.serviio.ui.resources.server.LicenseUploadServerResource;

import java.io.IOException;
import org.restlet.representation.InputRepresentation;
import org.serviio.config.Configuration;
import org.serviio.licensing.InvalidLicenseException;
import org.serviio.licensing.LicensingManager;
import org.serviio.restlet.AbstractServerResource;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.restlet.ValidationException;
import org.serviio.ui.resources.LicenseUploadResource;
import org.serviio.util.FileUtils;
import org.slf4j.Logger;

public class LicenseUploadServerResource
  : AbstractServerResource
  , LicenseUploadResource
{
  public ResultRepresentation save(InputRepresentation rep)
  {
    byte[] receivedBytes = FileUtils.readFileBytes(rep.getStream());
    String postedLicense = new String(receivedBytes, "UTF-8");
    try
    {
      this.log.debug_("Validating uploaded license");
      LicensingManager.getInstance().validateLicense(postedLicense);
      Configuration.setCustomerLicense(postedLicense);
      this.log.info("New license stored");
      
      LicensingManager.getInstance().updateLicense();
    }
    catch (InvalidLicenseException e)
    {
      this.log.warn("License is not stored because it's not valid: " + e.getMessage(), e);
      throw new ValidationException(e.getMessage(), 555);
    }
    return responseOk();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.server.LicenseUploadServerResource
 * JD-Core Version:    0.7.0.1
 */