module org.serviio.upnp.service.contentdirectory.SonyDLNAMessageBuilder;

import java.lang.String;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.GenericDLNAMessageBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

public class SonyDLNAMessageBuilder : GenericDLNAMessageBuilder
{
    public this(String filter)
    {
        super(filter);
    }

    override protected Node storeRootNode(Document document)
    {
        Element node = cast(Element)super.storeRootNode(document);
        node.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:av", "urn:schemas-sony-com:av");
        return node;
    }

    override protected void storeContainerFields(Node containerNode, DirectoryObject object)
    {
        super.storeContainerFields(containerNode, object);
        storeNode(containerNode, object, ClassProperties.MEDIA_CLASS, false);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.SonyDLNAMessageBuilder
* JD-Core Version:    0.7.0.1
*/