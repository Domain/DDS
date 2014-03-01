module org.serviio.delivery.DefaultResourceURLGenerator;

import java.lang.String;
import java.net.MalformedURLException;
import java.net.URL;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.profile.DeliveryQuality;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.util.ObjectValidator;
import org.serviio.delivery.ResourceURLGenerator;
import org.serviio.delivery.HostInfo;

public class DefaultResourceURLGenerator : ResourceURLGenerator
{
    public static immutable String RESOURCE_SEPARATOR = "-";

    public String getGeneratedURL(HostInfo hostInfo, Resource.ResourceType resourceType, Long resourceId, MediaFormatProfile ver, Integer protocolInfoIndex, QualityType quality)
    {
        validate(resourceType, resourceId, ver, protocolInfoIndex, quality);
        StringBuffer file = new StringBuffer();
        file.append(resourceId.toString());
        file.append("/").append(resourceType.toString());
        if ((resourceType == Resource.ResourceType.MEDIA_ITEM) || (resourceType == Resource.ResourceType.MANIFEST))
        {
            file.append("/").append(ver.toString());
            file.append("-").append(protocolInfoIndex);
            file.append("/").append(quality.toString());
        }
        if (Resource.ResourceType.SUBTITLE == resourceType) {
            file.append(".srt");
        } else if ((Resource.ResourceType.MANIFEST == resourceType) || ((ver !is null) && (ver.isManifestFormat()))) {
            file.append(".m3u8");
        }
        return generateUrl(hostInfo, generatePath(hostInfo, file.toString()));
    }

    public String getGeneratedURL(HostInfo hostInfo, Resource.ResourceType resourceType, Long resourceId, String path)
    {
        validate(resourceType, resourceId, null, null, null);
        StringBuffer file = new StringBuffer();
        file.append(resourceId.toString());
        file.append("/").append(resourceType.toString());
        file.append("/").append(path);
        return generateUrl(hostInfo, generatePath(hostInfo, file.toString()));
    }

    private String generatePath(HostInfo hostInfo, String path)
    {
        StringBuffer file = new StringBuffer();
        file.append(hostInfo.getContext()).append("/").append(path);
        if (hostInfo.getURLParameters() !is null)
        {
            String queryString = hostInfo.getURLParameters().get();
            if (ObjectValidator.isNotEmpty(queryString))
            {
                if (path.indexOf('?') > -1) {
                    file.append("&");
                } else {
                    file.append("?");
                }
                file.append(queryString);
            }
        }
        return file.toString();
    }

    private String generateUrl(HostInfo hostInfo, String path)
    {
        if (hostInfo.getHost() !is null) {
            try
            {
                return new URL("http", hostInfo.getHost(), hostInfo.getPort().intValue(), path).toString();
            }
            catch (MalformedURLException e)
            {
                throw new RuntimeException("Cannot resolve Resource URL address.");
            }
        }
        return path;
    }

    private void validate(Resource.ResourceType resourceType, Long resourceId, MediaFormatProfile ver, Integer protocolInfoIndex, QualityType quality)
    {
        if ((resourceId is null) || (resourceType is null) || ((resourceType == Resource.ResourceType.MEDIA_ITEM) && ((ver is null) || (quality is null) || (protocolInfoIndex is null)))) {
            throw new InvalidResourceException("Resource is not valid.");
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.DefaultResourceURLGenerator
* JD-Core Version:    0.7.0.1
*/