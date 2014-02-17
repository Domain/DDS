module org.serviio.upnp.service.contentdirectory.rest.resources.FlowPlayerKeyGeneratorResource;

import java.io.IOException;
import org.restlet.representation.StringRepresentation;
import org.restlet.resource.Get;

public abstract interface FlowPlayerKeyGeneratorResource
{
  @Get
  public abstract StringRepresentation generate();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.FlowPlayerKeyGeneratorResource
 * JD-Core Version:    0.7.0.1
 */