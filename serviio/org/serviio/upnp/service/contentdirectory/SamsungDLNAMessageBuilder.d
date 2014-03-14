module org.serviio.upnp.service.contentdirectory.SamsungDLNAMessageBuilder;

import java.lang.String;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.upnp.service.contentdirectory.GenericDLNAMessageBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

public class SamsungDLNAMessageBuilder : GenericDLNAMessageBuilder
{
    public this(String filter)
    {
        super(filter);
    }

    override protected Node storeRootNode(Document document)
    {
        Element node = cast(Element)super.storeRootNode(document);
        node.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:sec", "http://www.sec.co.kr/");
        return node;
    }

    override protected void storeItemFields(Node itemNode, DirectoryObject object)
    {
        super.storeItemFields(itemNode, object);

        Node subtitlesNode = storeNode(itemNode, object, ClassProperties.SUBTITLES_URL, "sec:CaptionInfoEx", false);
        storeStaticAttribute(subtitlesNode, "sec:type", "http://www.sec.co.kr/", "srt");

        storeNode(itemNode, object, ClassProperties.DCM_INFO, false);
        if (isResourceRequired())
        {
            bool smResourceExists = false;
            Resource newThumbnailResource = null;
            foreach (Resource resource ; object.getResources()) {
                if (resource.getResourceType() == ResourceType.COVER_IMAGE)
                {
                    newThumbnailResource = new Resource(resource.getResourceType(), resource.getResourceId(), MediaFormatProfile.JPEG_SM, resource.getProtocolInfoIndex(), resource.getQuality(), resource.isTranscoded());

                    newThumbnailResource.setProtocolInfo(resource.getProtocolInfo().replaceFirst(MediaFormatProfile.JPEG_TN.toString(), MediaFormatProfile.JPEG_SM.toString()));
                    newThumbnailResource.setResolution(resource.getResolution());
                }
                else if (resource.getVersion() == MediaFormatProfile.JPEG_SM)
                {
                    smResourceExists = true;
                }
            }
            if ((!smResourceExists) && (newThumbnailResource !is null)) {
                storeResource(itemNode, newThumbnailResource);
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.SamsungDLNAMessageBuilder
* JD-Core Version:    0.7.0.1
*/