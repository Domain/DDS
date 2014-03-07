module org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultRepresentation;

import java.lang.String;
import org.serviio.upnp.service.contentdirectory.rest.representation.AbstractCDSObjectRepresentation;

public class SearchResultRepresentation : AbstractCDSObjectRepresentation
{
    private String context;

    public this(DirectoryObjectType type, String title, String id)
    {
        super(type, title, id);
    }

    public String getContext()
    {
        return this.context;
    }

    public void setContext(String context)
    {
        this.context = context;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultRepresentation
* JD-Core Version:    0.7.0.1
*/