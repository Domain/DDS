module org.serviio.upnp.protocol.http.transport.RequestedResourceDescriptor;

import java.util.regex.Pattern;
import org.serviio.profile.DeliveryQuality;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.upnp.webserver.AbstractRequestHandler;
import org.serviio.util.StringUtils;

public class RequestedResourceDescriptor
{
    private static final Pattern URL_EXTENSION_REMOVAL_PATTERN = Pattern.compile("(\\.srt|\\.m3u8)");
    private Long resourceId;
    private Resource.ResourceType resourceType;
    private String targetProfileName;
    private Integer protocolInfoIndex;
    private QualityType quality;
    private String path;

    public this(String requestUri)
    {
        try
        {
            String[] requestFields = AbstractRequestHandler.getRequestPathFields(requestUri, "/resource", URL_EXTENSION_REMOVAL_PATTERN);

            this.path = requestUri.substring(requestUri.indexOf("/resource") + "/resource".length() + 1);
            this.resourceId = new Long(requestFields[0]);
            String resourceTypeParam = requestFields[1];
            this.resourceType = Resource.ResourceType.valueOf(StringUtils.localeSafeToUppercase(resourceTypeParam));
            if ((requestFields.length > 2) && (this.resourceType != Resource.ResourceType.SEGMENT))
            {
                String[] protocolFields = requestFields[2].split("\\-");
                this.targetProfileName = protocolFields[0];
                this.protocolInfoIndex = Integer.valueOf(Integer.parseInt(protocolFields[1].trim()));
                this.quality = QualityType.valueOf(requestFields[3]);
            }
        }
        catch (Exception e)
        {
            throw new InvalidResourceRequestException(String.format("Invalid incoming request: %s", cast(Object[])[ requestUri ]), e);
        }
    }

    public Long getResourceId()
    {
        return this.resourceId;
    }

    public Resource.ResourceType getResourceType()
    {
        return this.resourceType;
    }

    public String getTargetProfileName()
    {
        return this.targetProfileName;
    }

    public Integer getProtocolInfoIndex()
    {
        return this.protocolInfoIndex;
    }

    public QualityType getQuality()
    {
        return this.quality;
    }

    public String getPath()
    {
        return this.path;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.http.transport.RequestedResourceDescriptor
* JD-Core Version:    0.7.0.1
*/