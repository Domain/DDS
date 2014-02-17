module org.serviio.ui.resources.ReferenceDataResource;

import org.restlet.resource.Get;
import org.serviio.ui.representation.ReferenceDataRepresentation;

public abstract interface ReferenceDataResource
{
  @Get("xml|json")
  public abstract ReferenceDataRepresentation load();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.ReferenceDataResource
 * JD-Core Version:    0.7.0.1
 */