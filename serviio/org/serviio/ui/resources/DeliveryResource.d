module org.serviio.ui.resources.DeliveryResource;

import org.restlet.resource.Get;
import org.restlet.resource.Put;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.ui.representation.DeliveryRepresentation;

public abstract interface DeliveryResource
{
  @Put("xml|json")
  public abstract ResultRepresentation save(DeliveryRepresentation paramDeliveryRepresentation);
  
  @Get("xml|json")
  public abstract DeliveryRepresentation load();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.DeliveryResource
 * JD-Core Version:    0.7.0.1
 */