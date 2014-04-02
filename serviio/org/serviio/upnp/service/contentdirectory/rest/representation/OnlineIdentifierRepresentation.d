module org.serviio.upnp.service.contentdirectory.rest.representation.OnlineIdentifierRepresentation;

import java.lang.String;
import com.thoughtworks.xstream.annotations.XStreamConverter;
import com.thoughtworks.xstream.converters.extended.ToAttributedValueConverter;

//@XStreamConverter(/*value=*/ToAttributedValueConverter.class_, /*strings={*/"id"/*}*/)
public class OnlineIdentifierRepresentation
{
    private String type;
    private String id;

    public this(String type, String id)
    {
        this.type = type;
        this.id = id;
    }

    public String getType()
    {
        return this.type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.OnlineIdentifierRepresentation
* JD-Core Version:    0.7.0.1
*/