module org.serviio.upnp.service.contentdirectory.definition.SimpleContainerContentDirectoryDefinitionFilter;

import java.lang.String;
import java.util.Map;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionFilter;

public class SimpleContainerContentDirectoryDefinitionFilter : ContentDirectoryDefinitionFilter
{
    public String filterObjectId(String requestedNodeId, bool isSearch)
    {
        return requestedNodeId;
    }

    public ObjectClassType filterContainerClassType(ObjectClassType requestedObjectClass, String objectId)
    {
        if (requestedObjectClass !is null) {
            return ObjectClassType.CONTAINER;
        }
        return requestedObjectClass;
    }

    public void filterClassProperties(String objectId, Map!(ClassProperties, Object) values) {}
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.SimpleContainerContentDirectoryDefinitionFilter
* JD-Core Version:    0.7.0.1
*/