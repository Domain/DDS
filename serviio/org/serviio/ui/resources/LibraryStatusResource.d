module org.serviio.ui.resources.LibraryStatusResource;

import org.restlet.resource.Get;
import org.serviio.ui.representation.LibraryStatusRepresentation;

public abstract interface LibraryStatusResource
{
  //@Get("xml|json")
  public abstract LibraryStatusRepresentation load();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.LibraryStatusResource
 * JD-Core Version:    0.7.0.1
 */