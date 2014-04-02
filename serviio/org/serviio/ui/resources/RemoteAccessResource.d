module org.serviio.ui.resources.RemoteAccessResource;

import org.restlet.resource.Get;
import org.restlet.resource.Put;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.ui.representation.RemoteAccessRepresentation;

public abstract interface RemoteAccessResource
{
  //@Put("xml|json")
  public abstract ResultRepresentation save(RemoteAccessRepresentation paramRemoteAccessRepresentation);
  
  //@Get("xml|json")
  public abstract RemoteAccessRepresentation load();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.RemoteAccessResource
 * JD-Core Version:    0.7.0.1
 */