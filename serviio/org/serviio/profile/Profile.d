module org.serviio.profile.Profile;

import java.lang;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.serviio.delivery.resource.transcode.TranscodingConfiguration;
import org.serviio.delivery.subtitles.SubtitlesConfiguration;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.ThumbnailResolution;
import org.serviio.upnp.DeviceDescription;
import org.serviio.upnp.protocol.http.transport.ResourceTransportProtocolHandler;
import org.serviio.upnp.service.contentdirectory.ProtocolInfo;
import org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionFilter;
import org.serviio.profile.DetectionDefinition;
import org.serviio.profile.DeliveryQuality;
import org.serviio.profile.H264LevelCheckType;
import org.serviio.profile.ImageResolutions;
import org.serviio.upnp.service.contentdirectory.ProtocolAdditionalInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Profile(T : ProtocolAdditionalInfo) : Comparable!(Profile)
{
    private static Logger log = LoggerFactory.getLogger!(Profile);
    public static immutable String DETECTION_FIELD_SERVER = "Server";
    public static immutable String DETECTION_FIELD_MODEL_NAME = "ModelName";
    public static immutable String DETECTION_FIELD_FRIENDLY_NAME = "FriendlyName";
    public static immutable String DETECTION_FIELD_MODEL_NUMBER = "ModelNumber";
    public static immutable String DETECTION_FIELD_PRODUCT_CODE = "ProductCode";
    public static immutable String DETECTION_FIELD_MANUFACTURER = "Manufacturer";
    private String id;
    private String name;
    private bool alwaysEnableTranscoding;
    private Class/*!(?)*/ contentDirectoryMessageBuilderClass;
    private List!(DetectionDefinition) detectionDefinitions;
    private Map!(MediaFormatProfile, ProtocolInfo!T) protocolInfo;
    private DeviceDescription deviceDescription;
    private ResourceTransportProtocolHandler resourceTransportProtocolHandler;
    private String protocolInfoType;
    private ContentDirectoryDefinitionFilter cdDefinitionFilter;
    private DeliveryQuality defaultDeliveryQuality;
    private bool automaticImageRotation;
    private bool limitImageResolution;
    private SubtitlesConfiguration subtitlesConfiguration;
    private List!(DeliveryQuality) deliveryQualities;
    private bool selectable;
    private H264LevelCheckType h264LevelCheck;
    private ThumbnailResolution thumbnailsResolution;
    private ImageResolutions allowedImageResolutions;

    public this(String id, String name, Class/*!(?)*/ contentDirectoryMessageBuilderClass, ResourceTransportProtocolHandler resourceTransportProtocolHandler, List!(DetectionDefinition) detectionDefinitions, Map!(MediaFormatProfile, ProtocolInfo!T) protocolInfo, String protocolInfoType, DeviceDescription deviceDescription, ContentDirectoryDefinitionFilter cdDefinitionFilter, TranscodingConfiguration transcodingConfiguration, TranscodingConfiguration onlineTranscodingConfiguration, TranscodingConfiguration hardSubsTranscodingConfiguration, bool automaticImageRotation, bool limitImageResolution, SubtitlesConfiguration subtitlesConfiguration, bool alwaysEnableTranscoding, bool selectable, List!(DeliveryQuality) deliveryQualities, H264LevelCheckType h264LevelCheck, ThumbnailResolution thumbnailsResolution, ImageResolutions allowedImageResolutions)
    {
        this.id = id;
        this.name = name;
        this.contentDirectoryMessageBuilderClass = contentDirectoryMessageBuilderClass;
        this.resourceTransportProtocolHandler = resourceTransportProtocolHandler;
        this.detectionDefinitions = detectionDefinitions;
        this.protocolInfo = protocolInfo;
        this.deviceDescription = deviceDescription;
        this.protocolInfoType = protocolInfoType;
        this.cdDefinitionFilter = cdDefinitionFilter;
        this.defaultDeliveryQuality = new DeliveryQuality(QualityType.ORIGINAL, transcodingConfiguration, onlineTranscodingConfiguration, hardSubsTranscodingConfiguration);
        this.automaticImageRotation = automaticImageRotation;
        this.limitImageResolution = limitImageResolution;
        this.subtitlesConfiguration = subtitlesConfiguration;
        this.alwaysEnableTranscoding = alwaysEnableTranscoding;
        this.deliveryQualities = deliveryQualities;
        this.selectable = selectable;
        this.h264LevelCheck = h264LevelCheck;
        this.thumbnailsResolution = thumbnailsResolution;
        this.allowedImageResolutions = allowedImageResolutions;
    }

    public this(String id, String name)
    {
        this.id = id;
        this.name = name;
    }

    public ProtocolInfo!T getResourceProtocolInfo(MediaFormatProfile mediaFormatProfile)
    {
        if (this.protocolInfo.containsKey(mediaFormatProfile)) {
            return cast(ProtocolInfo)this.protocolInfo.get(mediaFormatProfile);
        }
        log.warn("Unregistered media format profile requesed, returning null");
        return null;
    }

    public String getMimeType(MediaFormatProfile profile)
    {
        if (this.protocolInfo.containsKey(profile))
        {
            ProtocolInfo pi = cast(ProtocolInfo)this.protocolInfo.get(profile);
            return pi.getMimeType();
        }
        log.warn("Unregistered media format profile's mime-type requesed, returning null");
        return null;
    }

    public bool hasAnyTranscodingDefinitions()
    {
        bool hasDef = getDefaultDeliveryQuality().getTranscodingConfiguration() !is null;
        if (!hasDef) {
            foreach (DeliveryQuality quality ; getAlternativeDeliveryQualities()) {
                if (quality.getTranscodingConfiguration() !is null) {
                    return true;
                }
            }
        }
        return hasDef;
    }

    public bool hasAnyOnlineTranscodingDefinitions()
    {
        bool hasDef = getDefaultDeliveryQuality().getOnlineTranscodingConfiguration() !is null;
        if (!hasDef) {
            foreach (DeliveryQuality quality ; getAlternativeDeliveryQualities()) {
                if (quality.getOnlineTranscodingConfiguration() !is null) {
                    return true;
                }
            }
        }
        return hasDef;
    }

    public bool hasAnyHardSubsTranscodingDefinitions()
    {
        bool hasDef = getDefaultDeliveryQuality().getHardSubsTranscodingConfiguration() !is null;
        if (!hasDef) {
            foreach (DeliveryQuality quality ; getAlternativeDeliveryQualities()) {
                if (quality.getHardSubsTranscodingConfiguration() !is null) {
                    return true;
                }
            }
        }
        return hasDef;
    }

    public String getId()
    {
        return this.id;
    }

    public String getName()
    {
        return this.name;
    }

    public List!(DetectionDefinition) getDetectionDefinitions()
    {
        return this.detectionDefinitions;
    }

    public DeviceDescription getDeviceDescription()
    {
        return this.deviceDescription;
    }

    public Class/*!(?)*/ getContentDirectoryMessageBuilder()
    {
        return this.contentDirectoryMessageBuilderClass;
    }

    public ResourceTransportProtocolHandler getResourceTransportProtocolHandler()
    {
        return this.resourceTransportProtocolHandler;
    }

    public String getProtocolInfoType()
    {
        return this.protocolInfoType;
    }

    public Map!(MediaFormatProfile, ProtocolInfo!T) getProtocolInfo()
    {
        return this.protocolInfo;
    }

    public ContentDirectoryDefinitionFilter getContentDirectoryDefinitionFilter()
    {
        return this.cdDefinitionFilter;
    }

    public DeliveryQuality getDefaultDeliveryQuality()
    {
        return this.defaultDeliveryQuality;
    }

    public bool isAutomaticImageRotation()
    {
        return this.automaticImageRotation;
    }

    public bool isLimitImageResolution()
    {
        return this.limitImageResolution;
    }

    public SubtitlesConfiguration getSubtitlesConfiguration()
    {
        return this.subtitlesConfiguration;
    }

    public bool isAlwaysEnableTranscoding()
    {
        return this.alwaysEnableTranscoding;
    }

    public List!(DeliveryQuality) getAlternativeDeliveryQualities()
    {
        return Collections.unmodifiableList(this.deliveryQualities);
    }

    public bool isSelectable()
    {
        return this.selectable;
    }

    public H264LevelCheckType getH264LevelCheck()
    {
        return this.h264LevelCheck;
    }

    public ThumbnailResolution getThumbnailsResolution()
    {
        return this.thumbnailsResolution;
    }

    public ImageResolutions getAllowedImageResolutions()
    {
        return this.allowedImageResolutions;
    }

    public override hash_t toHash()
    {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.id is null ? super.hashCode() : this.id.hashCode());
        return result;
    }

    public override equals_t opEquals(Object obj)
    {
        if (this == obj) {
            return true;
        }
        if (obj is null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        Profile other = cast(Profile)obj;
        if (this.id is null)
        {
            if (other.id !is null) {
                return false;
            }
        }
        else if (!this.id.equals(other.id)) {
            return false;
        }
        return true;
    }

    override public String toString()
    {
        return this.name;
    }

    public int compareTo(Profile o)
    {
        if (o !is null)
        {
            if (getId().equals(o.getId())) {
                return 0;
            }
            if (o.getId().equals("1")) {
                return 1;
            }
            return getName().compareTo(o.getName());
        }
        return -1;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.profile.Profile
* JD-Core Version:    0.7.0.1
*/