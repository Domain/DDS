module org.serviio.ui.resources.StatusResource;

import org.restlet.resource.Get;
import org.restlet.resource.Put;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.ui.representation.StatusRepresentation;

public abstract interface StatusResource
{
  //@Get("xml|json")
  public abstract StatusRepresentation load();
  
  //@Put("xml|json")
  public abstract ResultRepresentation save(StatusRepresentation paramStatusRepresentation);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.StatusResource
 * JD-Core Version:    0.7.0.1
 */