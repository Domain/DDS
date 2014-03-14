module org.serviio.upnp.service.contentdirectory.definition.WMPContentDirectoryDefinitionFilter;

import java.lang.String;
import java.util.Map;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionFilter;

public class WMPContentDirectoryDefinitionFilter : ContentDirectoryDefinitionFilter
{
    public String filterObjectId(String requestedNodeId, bool isSearch)
    {
        if (requestedNodeId.equals("2")) {
            return "V";
        }
        if (requestedNodeId.equals("3")) {
            return "I";
        }
        if (requestedNodeId.equals("1")) {
            return "A";
        }
        return requestedNodeId;
    }

    public ObjectClassType filterContainerClassType(ObjectClassType requestedObjectClass, String objectId)
    {
        if ((requestedObjectClass !is null) && (requestedObjectClass.getClassName().startsWith("object.container")) && (!objectId.startsWith("A"))) {
            return ObjectClassType.CONTAINER;
        }
        return requestedObjectClass;
    }

    public void filterClassProperties(String objectId, Map!(ClassProperties, Object) values) {}
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.WMPContentDirectoryDefinitionFilter
* JD-Core Version:    0.7.0.1
*/