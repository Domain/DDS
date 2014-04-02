module org.serviio.ui.resources.ActionsResource;

import org.restlet.resource.Post;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.ui.representation.ActionRepresentation;

public abstract interface ActionsResource
{
  //@Post("xml|json")
  public abstract ResultRepresentation execute(ActionRepresentation paramActionRepresentation);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.ActionsResource
 * JD-Core Version:    0.7.0.1
 */