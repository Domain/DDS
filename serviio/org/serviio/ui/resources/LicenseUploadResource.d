module org.serviio.ui.resources.LicenseUploadResource;

import java.io.IOException;
import org.restlet.representation.InputRepresentation;
import org.restlet.resource.Put;
import org.serviio.restlet.ResultRepresentation;

public abstract interface LicenseUploadResource
{
  //@Put("txt:xml|txt:json")
  public abstract ResultRepresentation save(InputRepresentation paramInputRepresentation);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.LicenseUploadResource
 * JD-Core Version:    0.7.0.1
 */