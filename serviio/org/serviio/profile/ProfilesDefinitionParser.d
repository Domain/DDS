module org.serviio.profile.ProfilesDefinitionParser;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.net.InetAddress;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map:Entry;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.serviio.MediaServer;
import org.serviio.delivery.resource.transcode.AudioTranscodingDefinition;
import org.serviio.delivery.resource.transcode.AudioTranscodingMatch;
import org.serviio.delivery.resource.transcode.ImageTranscodingDefinition;
import org.serviio.delivery.resource.transcode.ImageTranscodingMatch;
import org.serviio.delivery.resource.transcode.TranscodingConfiguration;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.serviio.delivery.resource.transcode.VideoTranscodingDefinition;
import org.serviio.delivery.resource.transcode.VideoTranscodingMatch;
import org.serviio.delivery.subtitles.SubtitlesConfiguration;
import org.serviio.dlna.AudioCodec;
import org.serviio.dlna.AudioContainer;
import org.serviio.dlna.DisplayAspectRatio;
import org.serviio.dlna.H264Profile;
import org.serviio.dlna.ImageContainer;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.SamplingMode;
import org.serviio.dlna.ThumbnailResolution;
import org.serviio.dlna.VideoCodec;
import org.serviio.dlna.VideoContainer;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.DeviceDescription;
import org.serviio.upnp.protocol.http.transport.ResourceTransportProtocolHandler;
import org.serviio.upnp.service.contentdirectory.ContentDirectoryMessageBuilder;
import org.serviio.upnp.service.contentdirectory.DLNAProtocolAdditionalInfo;
import org.serviio.upnp.service.contentdirectory.ProtocolAdditionalInfo;
import org.serviio.upnp.service.contentdirectory.ProtocolInfo;
import org.serviio.upnp.service.contentdirectory.SimpleProtocolInfo;
import org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionFilter;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.serviio.util.XmlUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProfilesDefinitionParser
{
    private static final Logger log = LoggerFactory.getLogger!(ProfilesDefinitionParser);
    private static immutable String PROFILES_XSD = "Profiles.xsd";
    private static immutable String TAG_PROFILE = "Profile";
    private static immutable String TAG_CONTENT_DIRECTORY_MESSAGE_BUILDER = "ContentDirectoryMessageBuilder";
    private static immutable String TAG_RESOURCE_TRANSPORT_PROTOCOL_HANDLER = "ResourceTransportProtocolHandler";
    private static immutable String TAG_CONTENT_DIRECTORY_DEFINITION_FILTER = "ContentDirectoryDefinitionFilter";
    private static immutable String TAG_DETECTION = "Detection";
    private static immutable String TAG_PROTOCOL_INFO = "ProtocolInfo";
    private static immutable String TAG_MEDIA_PROFILES = "MediaFormatProfiles";
    private static immutable String TAG_MEDIA_PROFILE = "MediaFormatProfile";
    private static immutable String TAG_DEVICE_DESCRIPTION = "DeviceDescription";
    private static immutable String TAG_UPNP_SEARCH = "UPnPSearch";
    private static immutable String TAG_HTTP_HEADERS = "HttpHeaders";
    private static immutable String TAG_FRIENDLY_NAME = "FriendlyName";
    private static immutable String TAG_MODEL_NAME = "ModelName";
    private static immutable String TAG_MODEL_NUMBER = "ModelNumber";
    private static immutable String TAG_MANUFACTURER = "Manufacturer";
    private static immutable String TAG_EXTRA_ELEMENTS = "ExtraElements";
    private static immutable String TAG_TRANSCODING = "Transcoding";
    private static immutable String TAG_ONLINE_TRANSCODING = "OnlineTranscoding";
    private static immutable String TAG_HARDSUBS_TRANSCODING = "HardSubsTranscoding";
    private static immutable String TAG_ALTERNATIVE_QUALITIES = "AlternativeQualities";
    private static immutable String TAG_QUALITY = "Quality";
    private static immutable String TAG_TRANSCODING_VIDEO = "Video";
    private static immutable String TAG_TRANSCODING_AUDIO = "Audio";
    private static immutable String TAG_TRANSCODING_IMAGE = "Image";
    private static immutable String TAG_TRANSCODING_MATCHES = "Matches";
    private static immutable String TAG_AUTOMATIC_IMAGE_ROTATION = "AutomaticImageRotation";
    private static immutable String TAG_LIMIT_IMAGE_RESOLUTION = "LimitImageResolution";
    private static immutable String TAG_AVAILABLE_IMAGE_RESOLUTIONS = "AllowedImageResolutions";
    private static immutable String TAG_H264_LEVEL_CHECK = "H264LevelCheck";
    private static immutable String TAG_SUBTITLES = "Subtitles";
    private static immutable String TAG_SUBTITLES_HARDSUBS = "HardSubs";
    private static immutable String TAG_SUBTITLES_HARDSUBS_REQUIRED_FOR = "RequiredFor";
    private static immutable String TAG_SUBTITLES_SOFTSUBS = "SoftSubs";
    private static immutable String TAG_THUMBNAILS_RESOLUTION = "ThumbnailsResolution";
    private static immutable String PROTOCOL_INFO_SIMPLE = "simple";
    private static immutable String PROTOCOL_INFO_DLNA = "DLNA";
    private static immutable String COMP_NAME_VARIABLE = "\\{computerName\\}";
    private static String COMP_NAME;

    static this()
    {
        try
        {
            COMP_NAME = InetAddress.getLocalHost().getHostName();
        }
        catch (UnknownHostException e)
        {
            log.warn(String.format("Cannot get name of the local computer: %s", cast(Object[])[ e.getMessage() ]));
        }
    }

    public static List!(Profile) parseDefinition(InputStream definitionStream, List!(Profile) currentProfiles)
    {
        if (definitionStream is null) {
            throw new ProfilesDefinitionException("Profiles definition is not present.");
        }
        try
        {
            String xml = StringUtils.readStreamAsString(definitionStream, "UTF-8");


            validateXML(xml);

            Document document = parser(xml);
            Element profilesNode = document.getRootElement();
            if (profilesNode is null) {
                throw new ProfilesDefinitionException("Profiles definition doesn't contain a root Profiles node.");
            }
            log.info("Parsing Profiles definition");

            List!(Profile) profiles = new ArrayList(currentProfiles);
            List!(Element) profileNodes = profilesNode.getChildren("Profile");
            for (int i = 0; i < profileNodes.size(); i++)
            {
                Profile profile = processProfileNode(cast(Element)profileNodes.get(i), profiles);
                profiles.add(profile);
            }
            return profiles;
        }
        catch (JDOMException e)
        {
            throw new ProfilesDefinitionException(String.format("Cannot read Profiles XML. Reason: %s", cast(Object[])[ e.getMessage() ]));
        }
        catch (IOException e)
        {
            throw new ProfilesDefinitionException(String.format("Cannot read Profiles XML. Reason: %s", cast(Object[])[ e.getMessage() ]));
        }
    }

    private static Document parser(String xmlDocument)
    {
        SAXBuilder saxBuilder = new SAXBuilder();
        return saxBuilder.build(new StringReader(xmlDocument));
    }

    private static Profile processProfileNode(Element profileNode, List!(Profile) profiles)
    {
        String id = profileNode.getAttributeValue("id");
        if (ObjectValidator.isNotEmpty(id))
        {
            log.debug_(String.format("Parsing profile definition for profile %s", cast(Object[])[ id ]));
            if (getProfileById(profiles, id) !is null) {
                throw new ProfilesDefinitionException(String.format("Duplicate profile id %s", cast(Object[])[ id ]));
            }
            Profile parentProfile = null;
            String extendsProfileId = profileNode.getAttributeValue("extendsProfileId");
            if (ObjectValidator.isNotEmpty(extendsProfileId))
            {
                parentProfile = getProfileById(profiles, extendsProfileId);
                if (parentProfile is null) {
                    throw new ProfilesDefinitionException(String.format("Profile %s cannot find profile with id %s to extend from. The parent profile must be defined before this profile.", cast(Object[])[ id, extendsProfileId ]));
                }
            }
            String h264LevelCheckTypeValue = profileNode.getChildText("H264LevelCheck");
            H264LevelCheckType h264LevelCheckType = null;
            if (ObjectValidator.isNotEmpty(h264LevelCheckTypeValue)) {
                h264LevelCheckType = H264LevelCheckType.valueOf(h264LevelCheckTypeValue);
            }
            h264LevelCheckType = (h264LevelCheckType is null) && (parentProfile !is null) ? parentProfile.getH264LevelCheck() : h264LevelCheckType;
            String name = profileNode.getAttributeValue("name");
            List!(DetectionDefinition) detectionDefinitions = getDetectionDefinitions(id, profileNode);
            Class/*!(?)*/ cdMessageBuilderClass = getContentDirectoryMessageBuilderClass(id, profileNode);
            ResourceTransportProtocolHandler resourceTrasportProtocolHandler = getResourceTransportProtocolHandler(id, profileNode);
            ContentDirectoryDefinitionFilter contentDirectoryDefinitionFilter = getContentDirectoryDefinitionFilter(id, profileNode);
            TranscodingConfiguration onlineTranscodeConfig = getTranscodingConfiguration(id, profileNode.getChild("OnlineTranscoding"), parentProfile !is null ? parentProfile.getDefaultDeliveryQuality().getOnlineTranscodingConfiguration() : null, h264LevelCheckType, false, true);

            TranscodingConfiguration transcodeConfig = getTranscodingConfiguration(id, profileNode.getChild("Transcoding"), parentProfile !is null ? parentProfile.getDefaultDeliveryQuality().getTranscodingConfiguration() : null, h264LevelCheckType, false, false);

            TranscodingConfiguration hardSubsTranscodeConfig = getTranscodingConfiguration(id, profileNode.getChild("HardSubsTranscoding"), parentProfile !is null ? parentProfile.getDefaultDeliveryQuality().getHardSubsTranscodingConfiguration() : null, h264LevelCheckType, true, true);

            DeviceDescription deviceDescription = getDeviceDescription(id, profileNode, parentProfile);
            SubtitlesConfiguration subtitlesConfiguration = getSubtitlesConfig(id, profileNode);
            String protocolInfoType = profileNode.getChildTextTrim("ProtocolInfo");
            String automaticImageRotation = profileNode.getChildTextTrim("AutomaticImageRotation");
            String limitImageResolution = profileNode.getChildTextTrim("LimitImageResolution");
            String thumbnailsResolutionType = profileNode.getChildTextTrim("ThumbnailsResolution");
            String alwaysEnableTranscoding = profileNode.getAttributeValue("alwaysEnableTranscoding");
            String selectable = profileNode.getAttributeValue("selectable");
            if (ObjectValidator.isEmpty(protocolInfoType)) {
                protocolInfoType = null;
            }
            protocolInfoType = (protocolInfoType is null) && (parentProfile !is null) ? parentProfile.getProtocolInfoType() : protocolInfoType;
            ThumbnailResolution thumbnailsResolution = (thumbnailsResolutionType is null) && (parentProfile !is null) ? parentProfile.getThumbnailsResolution() : ThumbnailResolution.valueOf(thumbnailsResolutionType);
            Map!(MediaFormatProfile, ProtocolInfo) protocolInfos = getProtocolInfoMap(id, profileNode, protocolInfoType, parentProfile);
            Profile profile = new Profile(id, name, (cdMessageBuilderClass is null) && (parentProfile !is null) ? parentProfile.getContentDirectoryMessageBuilder() : cdMessageBuilderClass, (resourceTrasportProtocolHandler is null) && (parentProfile !is null) ? parentProfile.getResourceTransportProtocolHandler() : resourceTrasportProtocolHandler, detectionDefinitions, protocolInfos, protocolInfoType, deviceDescription, (contentDirectoryDefinitionFilter is null) && (parentProfile !is null) ? parentProfile.getContentDirectoryDefinitionFilter() : contentDirectoryDefinitionFilter, transcodeConfig, onlineTranscodeConfig, hardSubsTranscodeConfig, (ObjectValidator.isEmpty(automaticImageRotation)) && (parentProfile !is null) ? parentProfile.isAutomaticImageRotation() : Boolean.parseBoolean(automaticImageRotation), (ObjectValidator.isEmpty(limitImageResolution)) && (parentProfile !is null) ? parentProfile.isLimitImageResolution() : Boolean.parseBoolean(limitImageResolution), (subtitlesConfiguration is null) && (parentProfile !is null) ? parentProfile.getSubtitlesConfiguration() : subtitlesConfiguration, Boolean.parseBoolean(alwaysEnableTranscoding), selectable !is null ? Boolean.parseBoolean(selectable) : true, getAlternativeDeliveryQualities(id, profileNode, h264LevelCheckType), h264LevelCheckType, thumbnailsResolution, getAllowedImageResolutions(profileNode, parentProfile));
            if (validateProfile(profile))
            {
                log.info(String.format("Added profile '%s' (id=%s)", cast(Object[])[ name, id ]));
                return profile;
            }
            throw new ProfilesDefinitionException("Profile validation failed. Check the log.");
        }
        throw new ProfilesDefinitionException("Invalid profiles definition. A profile is missing id attribute.");
    }

    private static Class/*!(?)*/ getContentDirectoryMessageBuilderClass(String profileId, Element profileNode)
    {
        String className = profileNode.getChildTextTrim("ContentDirectoryMessageBuilder");
        if (ObjectValidator.isNotEmpty(className)) {
            try
            {
                Class/*!(?)*/ clazz = Class.forName(className.trim());
                if (!ContentDirectoryMessageBuilder.class_.isAssignableFrom(clazz)) {
                    throw new ProfilesDefinitionException(String.format("Class %s defining ContentDirectoryMessageBuilder for profile %s is not of a proper type", cast(Object[])[ className, profileId ]));
                }
                return clazz;
            }
            catch (ClassNotFoundException e)
            {
                throw new ProfilesDefinitionException(String.format("Class %s defining ContentDirectoryMessageBuilder of profile %s does not exist", cast(Object[])[ className, profileId ]));
            }
        }
        return null;
    }

    private static ResourceTransportProtocolHandler getResourceTransportProtocolHandler(String profileId, Element profileNode)
    {
        String className = profileNode.getChildTextTrim("ResourceTransportProtocolHandler");
        if (ObjectValidator.isNotEmpty(className)) {
            try
            {
                Class/*!(?)*/ clazz = Class.forName(className);
                if (!ResourceTransportProtocolHandler.class_.isAssignableFrom(clazz)) {
                    throw new ProfilesDefinitionException(String.format("Class %s defining ResourceTransportProtocolHandler for profile %s is not of a proper type", cast(Object[])[ className, profileId ]));
                }
                return cast(ResourceTransportProtocolHandler)clazz.newInstance();
            }
            catch (ClassNotFoundException e)
            {
                throw new ProfilesDefinitionException(String.format("Class %s defining ResourceTransportProtocolHandler of profile %s does not exist", cast(Object[])[ className, profileId ]));
            }
            catch (InstantiationException e)
            {
                throw new ProfilesDefinitionException(String.format("Cannot instantiate ResourceTransportProtocolHandler of profile %s", cast(Object[])[ profileId ]));
            }
            catch (IllegalAccessException e)
            {
                throw new ProfilesDefinitionException(String.format("Cannot instantiate ResourceTransportProtocolHandler of profile %s", cast(Object[])[ profileId ]));
            }
        }
        return null;
    }

    private static ContentDirectoryDefinitionFilter getContentDirectoryDefinitionFilter(String profileId, Element profileNode)
    {
        String className = profileNode.getChildTextTrim("ContentDirectoryDefinitionFilter");
        if (ObjectValidator.isNotEmpty(className)) {
            try
            {
                Class/*!(?)*/ clazz = Class.forName(className);
                if (!ContentDirectoryDefinitionFilter.class_.isAssignableFrom(clazz)) {
                    throw new ProfilesDefinitionException(String.format("Class %s defining ContentDirectoryDefinitionFilter for profile %s is not of a proper type", cast(Object[])[ className, profileId ]));
                }
                return cast(ContentDirectoryDefinitionFilter)clazz.newInstance();
            }
            catch (ClassNotFoundException e)
            {
                throw new ProfilesDefinitionException(String.format("Class %s defining ContentDirectoryDefinitionFilter of profile %s does not exist", cast(Object[])[ className, profileId ]));
            }
            catch (InstantiationException e)
            {
                throw new ProfilesDefinitionException(String.format("Cannot instantiate ContentDirectoryDefinitionFilter of profile %s", cast(Object[])[ profileId ]));
            }
            catch (IllegalAccessException e)
            {
                throw new ProfilesDefinitionException(String.format("Cannot instantiate ContentDirectoryDefinitionFilter of profile %s", cast(Object[])[ profileId ]));
            }
        }
        return null;
    }

    private static DeviceDescription getDeviceDescription(String profileId, Element profileNode, Profile parentProfile)
    {
        Element ddNode = profileNode.getChild("DeviceDescription");
        if (ddNode !is null)
        {
            String friendlyName = ddNode.getChildTextTrim("FriendlyName");
            if (friendlyName !is null) {
                friendlyName = friendlyName.replaceFirst("\\{computerName\\}", COMP_NAME);
            } else {
                friendlyName = parentProfile !is null ? parentProfile.getDeviceDescription().getFriendlyName() : null;
            }
            String modelName = ddNode.getChildTextTrim("ModelName");
            if (modelName is null) {
                modelName = parentProfile !is null ? parentProfile.getDeviceDescription().getModelName() : null;
            }
            String modelNumber = ddNode.getChildTextTrim("ModelNumber");
            if (modelNumber is null) {
                modelNumber = parentProfile !is null ? parentProfile.getDeviceDescription().getModelNumber() : null;
            }
            String manufacturer = ddNode.getChildTextTrim("Manufacturer");
            if (manufacturer is null) {
                manufacturer = parentProfile !is null ? parentProfile.getDeviceDescription().getManufacturer() : null;
            }
            String extraElements = ddNode.getChildTextTrim("ExtraElements");
            if (extraElements is null) {
                extraElements = parentProfile !is null ? parentProfile.getDeviceDescription().getExtraElements() : null;
            } else {
                extraElements = XmlUtils.decodeXml(extraElements.trim());
            }
            if ((ObjectValidator.isNotEmpty(friendlyName)) && (ObjectValidator.isNotEmpty(modelName)) && (ObjectValidator.isNotEmpty(manufacturer)))
            {
                String number = ObjectValidator.isEmpty(modelNumber) ? MediaServer.VERSION : modelNumber;
                return new DeviceDescription(friendlyName, modelName, number, manufacturer, extraElements);
            }
            throw new ProfilesDefinitionException(String.format("Profile %s has incomplete device description", cast(Object[])[ profileId ]));
        }
        return parentProfile.getDeviceDescription();
    }

    private static ImageResolutions getAllowedImageResolutions(Element profileNode, Profile parentProfile)
    {
        Element airNode = profileNode.getChild("AllowedImageResolutions");
        if (airNode !is null) {
            return new ImageResolutions(airNode.getAttributeValue("large"), airNode.getAttributeValue("medium"), airNode.getAttributeValue("small"));
        }
        if (parentProfile !is null) {
            return parentProfile.getAllowedImageResolutions();
        }
        throw new ProfilesDefinitionException("Missing element AllowedImageResolutions");
    }

    private static List!(DetectionDefinition) getDetectionDefinitions(String profileId, Element profileNode)
    {
        Element ddNode = profileNode.getChild("Detection");
        if (ddNode !is null)
        {
            List!(DetectionDefinition) result = new ArrayList();
            Element upnpSearchNode = ddNode.getChild("UPnPSearch");
            Element httpHeadersNode = ddNode.getChild("HttpHeaders");
            if (upnpSearchNode !is null)
            {
                DetectionDefinition dd = new DetectionDefinition(DetectionDefinition.DetectionType.UPNP_SEARCH);
                dd.getFieldValues().putAll(getAllDetectionFields(upnpSearchNode));
                result.add(dd);
            }
            if (httpHeadersNode !is null)
            {
                DetectionDefinition dd = new DetectionDefinition(DetectionDefinition.DetectionType.HTTP_HEADERS);
                dd.getFieldValues().putAll(getAllDetectionFields(httpHeadersNode));
                result.add(dd);
            }
            return result;
        }
        return null;
    }

    private static Map!(String, String) getAllDetectionFields(Element parentNode)
    {
        List!(Element) headerNodes = parentNode.getChildren();
        Map!(String, String) headers = new HashMap();
        for (int i = 0; i < headerNodes.size(); i++)
        {
            Element headerNode = cast(Element)headerNodes.get(i);
            headers.put(headerNode.getName(), headerNode.getTextTrim());
        }
        return headers;
    }

    private static TranscodingConfiguration getTranscodingConfiguration(String profileId, Element trNode, TranscodingConfiguration parentTranscodingConfig, H264LevelCheckType h264LevelCheck, bool addDefaultMatcher, bool inherits)
    {
        if ((trNode is null) && (inherits)) {
            return parentTranscodingConfig;
        }
        if ((trNode !is null) || (transcodingConfigIncludesForcedItems(parentTranscodingConfig)))
        {
            TranscodingConfiguration trConfig = new TranscodingConfiguration();

            bool keepStreamOpen = (parentTranscodingConfig !is null) && (trNode is null) ? parentTranscodingConfig.isKeepStreamOpen() : true;
            if (trNode !is null)
            {
                String keepStreamOpenValue = trNode.getAttributeValue("keepStreamOpen");
                if (ObjectValidator.isNotEmpty(keepStreamOpenValue)) {
                    keepStreamOpen = Boolean.valueOf(keepStreamOpenValue).boolValue();
                }
            }
            trConfig.setKeepStreamOpen(keepStreamOpen);


            getVideoTranscodingConfiguration(profileId, trNode, trConfig, parentTranscodingConfig, h264LevelCheck, addDefaultMatcher);
            getAudioTranscodingConfiguration(profileId, trNode, trConfig, parentTranscodingConfig);
            getImageTranscodingConfiguration(profileId, trNode, trConfig, parentTranscodingConfig);
            return trConfig;
        }
        return null;
    }

    private static void getVideoTranscodingConfiguration(String profileId, Element trNode, TranscodingConfiguration trConfig, TranscodingConfiguration parentTrConfig, H264LevelCheckType h264LevelCheck, bool addDefaultMatcher)
    {
        if (trNode !is null)
        {
            List!(Element) videoNodes = trNode.getChildren("Video");
            for (int i = 0; i < videoNodes.size(); i++)
            {
                Element videoNode = cast(Element)videoNodes.get(i);

                VideoContainer targetContainer = VideoContainer.getByFFmpegValue(videoNode.getAttributeValue("targetContainer"), null);
                if (targetContainer is null) {
                    throw new ProfilesDefinitionException(String.format("Profile %s has unsupported target container in video transcoding definition", cast(Object[])[ profileId ]));
                }
                String vCodecName = videoNode.getAttributeValue("targetVCodec");
                String aCodecName = videoNode.getAttributeValue("targetACodec");
                String maxVideoBitrateValue = videoNode.getAttributeValue("maxVBitrate");
                String maxHeightValue = videoNode.getAttributeValue("maxHeight");
                String audioBitrateValue = videoNode.getAttributeValue("aBitrate");
                String audioSampleRateValue = videoNode.getAttributeValue("aSamplerate");
                String forceVTranscodingValue = videoNode.getAttributeValue("forceVTranscoding");
                String forceStereoValue = videoNode.getAttributeValue("forceStereo");
                String forceInheritanceValue = videoNode.getAttributeValue("forceInheritance");
                String darName = videoNode.getAttributeValue("DAR");
                VideoCodec targetVCodec = null;
                AudioCodec targetACodec = null;
                Integer maxVideoBitrate = null;
                Integer maxHeight = null;
                Integer audioBitrate = null;
                Integer audioSamplerate = null;
                Boolean forceVTranscoding = Boolean.FALSE;
                Boolean forceStereo = Boolean.FALSE;
                Boolean forceInheritance = Boolean.FALSE;
                DisplayAspectRatio dar = null;
                if (ObjectValidator.isNotEmpty(vCodecName))
                {
                    targetVCodec = VideoCodec.getByFFmpegValue(vCodecName);
                    if (targetVCodec is null) {
                        throw new ProfilesDefinitionException(String.format("Profile %s has unsupported target video codec '%s' in transcoding definition", cast(Object[])[ profileId, vCodecName ]));
                    }
                }
                if (ObjectValidator.isNotEmpty(aCodecName))
                {
                    targetACodec = AudioCodec.getByFFmpegDecoderName(aCodecName);
                    if (targetACodec is null) {
                        throw new ProfilesDefinitionException(String.format("Profile %s has unsupported target audio codec '%s' in transcoding definition", cast(Object[])[ profileId, aCodecName ]));
                    }
                }
                if (ObjectValidator.isNotEmpty(maxVideoBitrateValue)) {
                    maxVideoBitrate = Integer.valueOf(maxVideoBitrateValue);
                }
                if (ObjectValidator.isNotEmpty(maxHeightValue)) {
                    maxHeight = Integer.valueOf(maxHeightValue);
                }
                if (ObjectValidator.isNotEmpty(audioBitrateValue)) {
                    audioBitrate = Integer.valueOf(audioBitrateValue);
                }
                if (ObjectValidator.isNotEmpty(audioSampleRateValue)) {
                    audioSamplerate = Integer.valueOf(audioSampleRateValue);
                }
                if (ObjectValidator.isNotEmpty(forceVTranscodingValue)) {
                    forceVTranscoding = Boolean.valueOf(forceVTranscodingValue);
                }
                if (ObjectValidator.isNotEmpty(forceStereoValue)) {
                    forceStereo = Boolean.valueOf(forceStereoValue);
                }
                if (ObjectValidator.isNotEmpty(forceInheritanceValue)) {
                    forceInheritance = Boolean.valueOf(forceInheritanceValue);
                }
                if (ObjectValidator.isNotEmpty(darName)) {
                    dar = DisplayAspectRatio.fromString(darName);
                }
                VideoTranscodingDefinition td = new VideoTranscodingDefinition(trConfig, targetContainer, targetVCodec, targetACodec, maxVideoBitrate, maxHeight, audioBitrate, audioSamplerate, forceVTranscoding.boolValue(), forceStereo.boolValue(), forceInheritance.boolValue(), dar);


                List!(Element) matcherNodes = videoNode.getChildren("Matches");
                for (int j = 0; j < matcherNodes.size(); j++)
                {
                    Element matcherNode = cast(Element)matcherNodes.get(j);

                    VideoContainer container = VideoContainer.getByFFmpegValue(matcherNode.getAttributeValue("container"), null);
                    if (container is null) {
                        throw new ProfilesDefinitionException(String.format("Profile %s has unsupported matcher video container in transcoding definition", cast(Object[])[ profileId ]));
                    }
                    String vcName = matcherNode.getAttributeValue("vCodec");
                    String acName = matcherNode.getAttributeValue("aCodec");
                    String h264ProfileName = matcherNode.getAttributeValue("profile");
                    String h264LevelGTValue = matcherNode.getAttributeValue("levelGreaterThan");
                    String ftypNotInValue = matcherNode.getAttributeValue("ftypNotIn");
                    String vFourCCValue = matcherNode.getAttributeValue("vFourCC");
                    String squarePixelsValue = matcherNode.getAttributeValue("squarePixels");
                    String onlineContentTypeValue = matcherNode.getAttributeValue("contentType");
                    H264Profile h264Profile = null;
                    Float h264LevelGT = null;
                    VideoCodec vCodec = null;
                    AudioCodec aCodec = null;
                    Boolean squarePixels = null;
                    OnlineContentType onlineContentType = OnlineContentType.ANY;
                    if (ObjectValidator.isNotEmpty(vcName))
                    {
                        vCodec = VideoCodec.getByFFmpegValue(vcName);
                        if (vCodec is null) {
                            throw new ProfilesDefinitionException(String.format("Profile %s has unsupported video codec '%s' in transcoding definition", cast(Object[])[ profileId, vcName ]));
                        }
                    }
                    if (ObjectValidator.isNotEmpty(acName))
                    {
                        aCodec = AudioCodec.getByFFmpegDecoderName(acName);
                        if (aCodec is null) {
                            throw new ProfilesDefinitionException(String.format("Profile %s has unsupported audio codec '%s' in transcoding definition", cast(Object[])[ profileId, acName ]));
                        }
                    }
                    if (ObjectValidator.isNotEmpty(h264ProfileName)) {
                        h264Profile = H264Profile.valueOf(StringUtils.localeSafeToUppercase(h264ProfileName));
                    }
                    if (ObjectValidator.isNotEmpty(h264LevelGTValue)) {
                        h264LevelGT = new Float(h264LevelGTValue);
                    }
                    if (ObjectValidator.isNotEmpty(onlineContentTypeValue)) {
                        onlineContentType = OnlineContentType.valueOf(StringUtils.localeSafeToUppercase(onlineContentTypeValue));
                    }
                    if (ObjectValidator.isNotEmpty(squarePixelsValue)) {
                        squarePixels = new Boolean(squarePixelsValue);
                    }
                    td.getMatches().add(new VideoTranscodingMatch(container, vCodec, aCodec, h264Profile, h264LevelGT, StringUtils.localeSafeToLowercase(ftypNotInValue), onlineContentType, squarePixels, StringUtils.localeSafeToLowercase(vFourCCValue), h264LevelCheck));
                }
                if (addDefaultMatcher) {
                    td.getMatches().add(new VideoTranscodingMatch(VideoContainer.ANY));
                }
                trConfig.addDefinition(MediaFileType.VIDEO, td);
            }
        }
        addInheritedTranscodingConfigs(MediaFileType.VIDEO, trConfig, parentTrConfig);
    }

    private static void getAudioTranscodingConfiguration(String profileId, Element trNode, TranscodingConfiguration trConfig, TranscodingConfiguration parentTrConfig)
    {
        if (trNode !is null)
        {
            List!(Element) audioNodes = trNode.getChildren("Audio");
            for (int i = 0; i < audioNodes.size(); i++)
            {
                Element audioNode = cast(Element)audioNodes.get(i);

                AudioContainer targetContainer = AudioContainer.getByName(audioNode.getAttributeValue("targetContainer"));
                if (targetContainer is null) {
                    throw new ProfilesDefinitionException(String.format("Profile %s has unsupported target container in audio transcoding definition", cast(Object[])[ profileId ]));
                }
                String audioBitrateValue = audioNode.getAttributeValue("aBitrate");
                String audioSampleRateValue = audioNode.getAttributeValue("aSamplerate");
                String forceInheritanceValue = audioNode.getAttributeValue("forceInheritance");
                Integer audioBitrate = null;
                Integer audioSamplerate = null;
                Boolean forceInheritance = Boolean.FALSE;
                if (ObjectValidator.isNotEmpty(audioBitrateValue)) {
                    audioBitrate = Integer.valueOf(audioBitrateValue);
                }
                if (ObjectValidator.isNotEmpty(audioSampleRateValue)) {
                    audioSamplerate = Integer.valueOf(audioSampleRateValue);
                }
                if (ObjectValidator.isNotEmpty(forceInheritanceValue)) {
                    forceInheritance = Boolean.valueOf(forceInheritanceValue);
                }
                AudioTranscodingDefinition td = new AudioTranscodingDefinition(trConfig, targetContainer, audioBitrate, audioSamplerate, forceInheritance.boolValue());

                List!(Element) matcherNodes = audioNode.getChildren("Matches");
                for (int j = 0; j < matcherNodes.size(); j++)
                {
                    Element matcherNode = cast(Element)matcherNodes.get(j);

                    AudioContainer container = AudioContainer.getByName(matcherNode.getAttributeValue("container"));
                    if (container is null) {
                        throw new ProfilesDefinitionException(String.format("Profile %s has unsupported matcher audio container in transcoding definition", cast(Object[])[ profileId ]));
                    }
                    String onlineContentTypeValue = matcherNode.getAttributeValue("contentType");
                    OnlineContentType onlineContentType = OnlineContentType.ANY;
                    if (ObjectValidator.isNotEmpty(onlineContentTypeValue)) {
                        onlineContentType = OnlineContentType.valueOf(StringUtils.localeSafeToUppercase(onlineContentTypeValue));
                    }
                    td.getMatches().add(new AudioTranscodingMatch(container, onlineContentType));
                }
                trConfig.addDefinition(MediaFileType.AUDIO, td);
            }
        }
        addInheritedTranscodingConfigs(MediaFileType.AUDIO, trConfig, parentTrConfig);
    }

    private static void getImageTranscodingConfiguration(String profileId, Element trNode, TranscodingConfiguration trConfig, TranscodingConfiguration parentTrConfig)
    {
        if (trNode !is null)
        {
            List!(Element) imageNodes = trNode.getChildren("Image");
            for (int i = 0; i < imageNodes.size(); i++)
            {
                Element imageNode = cast(Element)imageNodes.get(i);
                String forceInheritanceValue = imageNode.getAttributeValue("forceInheritance");
                Boolean forceInheritance = Boolean.FALSE;
                if (ObjectValidator.isNotEmpty(forceInheritanceValue)) {
                    forceInheritance = Boolean.valueOf(forceInheritanceValue);
                }
                ImageTranscodingDefinition td = new ImageTranscodingDefinition(trConfig, forceInheritance.boolValue());

                List!(Element) matcherNodes = imageNode.getChildren("Matches");
                for (int j = 0; j < matcherNodes.size(); j++)
                {
                    Element matcherNode = cast(Element)matcherNodes.get(j);

                    ImageContainer container = ImageContainer.getByName(matcherNode.getAttributeValue("container"));
                    if (container is null) {
                        throw new ProfilesDefinitionException(String.format("Profile %s has unsupported matcher image container in transcoding definition", cast(Object[])[ profileId ]));
                    }
                    String subsamplingValue = matcherNode.getAttributeValue("subsampling");
                    SamplingMode samplingMode = null;
                    if (ObjectValidator.isNotEmpty(subsamplingValue)) {
                        samplingMode = SamplingMode.valueOf(subsamplingValue);
                    }
                    td.getMatches().add(new ImageTranscodingMatch(container, samplingMode));
                }
                trConfig.addDefinition(MediaFileType.IMAGE, td);
            }
        }
        addInheritedTranscodingConfigs(MediaFileType.IMAGE, trConfig, parentTrConfig);
    }

    private static void addInheritedTranscodingConfigs(MediaFileType type, TranscodingConfiguration trConfig, TranscodingConfiguration parentTrConfig)
    {
        if (parentTrConfig !is null) {
            foreach (TranscodingDefinition td ; parentTrConfig.getDefinitions(type)) {
                if (td.isForceInheritance()) {
                    trConfig.addDefinition(type, td);
                }
            }
        }
    }

    private static bool transcodingConfigIncludesForcedItems(TranscodingConfiguration trConfig)
    {
        if (trConfig !is null) {
            foreach (TranscodingDefinition def ; trConfig.getDefinitions()) {
                if (def.isForceInheritance()) {
                    return true;
                }
            }
        }
        return false;
    }

    private static Map!(MediaFormatProfile, ProtocolInfo) getProtocolInfoMap(String profileId, Element profileNode, String protocolInfoType, Profile parentProfile)
    {
        Map!(MediaFormatProfile, ProtocolInfo) protocolInfos = new LinkedHashMap();
        if ((parentProfile !is null) && (ObjectValidator.isEmpty(protocolInfoType))) {
            protocolInfoType = parentProfile.getProtocolInfoType();
        }
        if (ObjectValidator.isNotEmpty(protocolInfoType))
        {
            Element formatsNode = profileNode.getChild("MediaFormatProfiles");
            if (formatsNode !is null)
            {
                List!(Element) formatNodes = formatsNode.getChildren("MediaFormatProfile");
                for (int i = 0; i < formatNodes.size(); i++)
                {
                    Element formatNode = cast(Element)formatNodes.get(i);
                    String mimeType = formatNode.getAttributeValue("mime-type");
                    String formatName = formatNode.getTextTrim();
                    if (ObjectValidator.isEmpty(mimeType)) {
                        throw new ProfilesDefinitionException(String.format("Profile %s has invalid (missing mime-type) media format profile", cast(Object[])[ profileId ]));
                    }
                    if (ObjectValidator.isEmpty(formatName)) {
                        throw new ProfilesDefinitionException(String.format("Profile %s has invalid (missing value) media format profile", cast(Object[])[ profileId ]));
                    }
                    try
                    {
                        MediaFormatProfile formatProfile = MediaFormatProfile.valueOf(formatName);
                        String profileFormatNames = formatNode.getAttributeValue("name");
                        List/*!(? : ProtocolAdditionalInfo)*/ protocolAdditionalInfos = createProtocolInfos(profileId, protocolInfoType, formatProfile, profileFormatNames);

                        protocolInfos.put(formatProfile, new ProtocolInfo(mimeType, protocolAdditionalInfos));
                    }
                    catch (IllegalArgumentException e)
                    {
                        throw new ProfilesDefinitionException(String.format("Profile %s has invalid media format profile %s", cast(Object[])[ profileId, formatName ]));
                    }
                }
            }
            if (parentProfile !is null) {
                foreach (Map.Entry!(MediaFormatProfile, ProtocolInfo) parentPI ; parentProfile.getProtocolInfo().entrySet()) {
                    if (!protocolInfos.containsKey(parentPI.getKey())) {
                        if (parentProfile.getProtocolInfoType().equals(protocolInfoType))
                        {
                            protocolInfos.put(parentPI.getKey(), parentPI.getValue());
                        }
                        else
                        {
                            List/*!(? : ProtocolAdditionalInfo)*/ protocolAdditionalInfos = createProtocolInfos(profileId, protocolInfoType, cast(MediaFormatProfile)parentPI.getKey(), null);

                            protocolInfos.put(parentPI.getKey(), new ProtocolInfo((cast(ProtocolInfo)parentPI.getValue()).getMimeType(), protocolAdditionalInfos));
                        }
                    }
                }
            }
        }
        return protocolInfos;
    }

    private static List/*!(? : ProtocolAdditionalInfo)*/ createProtocolInfos(String profileId, String protocolInfoType, MediaFormatProfile formatProfile, String profileFormatNames)
    {
        if (protocolInfoType.equals("simple")) {
            return Collections.singletonList(new SimpleProtocolInfo());
        }
        if (protocolInfoType.equals("DLNA"))
        {
            if (ObjectValidator.isEmpty(profileFormatNames))
            {
                String profileFormatName = profileFormatNames !is null ? null : formatProfile.toString();

                return Collections.singletonList(new DLNAProtocolAdditionalInfo(profileFormatName));
            }
            List!(ProtocolAdditionalInfo) protocolAdditionalInfos = new ArrayList();
            String[] names = profileFormatNames.split(",");
            foreach (String name ; names) {
                protocolAdditionalInfos.add(new DLNAProtocolAdditionalInfo(name.trim()));
            }
            return protocolAdditionalInfos;
        }
        throw new ProfilesDefinitionException(String.format("Profile %s has invalid (%s) type of ProtocolInfo", cast(Object[])[ profileId ]));
    }

    private static Profile getProfileById(List!(Profile) profiles, String profileId)
    {
        foreach (Profile profile ; profiles) {
            if (profile.getId().equals(profileId)) {
                return profile;
            }
        }
        return null;
    }

    private static List!(DeliveryQuality) getAlternativeDeliveryQualities(String profileId, Element profileNode, H264LevelCheckType h264LevelCheck)
    {
        Element qualitiesNode = profileNode.getChild("AlternativeQualities");
        List!(DeliveryQuality) qualities = new ArrayList();
        if (qualitiesNode !is null)
        {
            List!(Element) qualityNodes = qualitiesNode.getChildren("Quality");
            foreach (Element qualityNode ; qualityNodes)
            {
                TranscodingConfiguration onlineTranscodeConfig = getTranscodingConfiguration(profileId, qualityNode.getChild("OnlineTranscoding"), null, h264LevelCheck, false, false);
                TranscodingConfiguration transcodeConfig = getTranscodingConfiguration(profileId, qualityNode.getChild("Transcoding"), null, h264LevelCheck, false, false);
                TranscodingConfiguration hardSubsTranscodeConfig = getTranscodingConfiguration(profileId, qualityNode.getChild("HardSubsTranscoding"), null, h264LevelCheck, true, false);
                QualityType type = QualityType.valueOf(qualityNode.getAttributeValue("type"));
                qualities.add(new DeliveryQuality(type, transcodeConfig, onlineTranscodeConfig, hardSubsTranscodeConfig));
            }
        }
        return qualities;
    }

    private static SubtitlesConfiguration getSubtitlesConfig(String profileId, Element profileNode)
    {
        Element subtitlesNode = profileNode.getChild("Subtitles");
        if (subtitlesNode !is null)
        {
            List!(VideoContainer) hardsubsFor = new ArrayList();
            String softSubsMimeType = null;
            Element softsubsNode = subtitlesNode.getChild("SoftSubs");
            Element hardsubsNode = subtitlesNode.getChild("HardSubs");
            if (softsubsNode !is null) {
                softSubsMimeType = softsubsNode.getAttributeValue("mime-type");
            }
            bool hardSubsSupported = true;
            if (hardsubsNode !is null)
            {
                String hardSubsSupportedString = hardsubsNode.getAttributeValue("supported");
                hardSubsSupported = hardSubsSupportedString is null ? true : Boolean.valueOf(hardSubsSupportedString).boolValue();
                List!(Element) requiredForNodes = hardsubsNode.getChildren("RequiredFor");
                foreach (Element requiredForNode ; requiredForNodes)
                {
                    VideoContainer container = VideoContainer.getByFFmpegValue(requiredForNode.getAttributeValue("container"), null);
                    if (container is null) {
                        throw new ProfilesDefinitionException(String.format("Profile %s has unsupported hardsubs container in subtitles definition", cast(Object[])[ profileId ]));
                    }
                    hardsubsFor.add(container);
                }
            }
            return new SubtitlesConfiguration(softSubsMimeType, hardsubsFor, hardSubsSupported);
        }
        return null;
    }

    private static bool validateProfile(Profile profile)
    {
        if (ObjectValidator.isEmpty(profile.getId()))
        {
            log.error("Profile validation failed: id missing");
            return false;
        }
        if (profile.getContentDirectoryMessageBuilder() is null)
        {
            log.error("Profile validation failed: ContentDirectoryMessageBuilder missing");
            return false;
        }
        if ((profile.getDeviceDescription() is null) || (ObjectValidator.isEmpty(profile.getDeviceDescription().getFriendlyName())) || (ObjectValidator.isEmpty(profile.getDeviceDescription().getModelName())))
        {
            log.error("Profile validation failed: DeviceDescription missing");
            return false;
        }
        if (ObjectValidator.isEmpty(profile.getName()))
        {
            log.error("Profile validation failed: name missing");
            return false;
        }
        if (ObjectValidator.isEmpty(profile.getProtocolInfoType()))
        {
            log.error("Profile validation failed: ProtocolInfo missing");
            return false;
        }
        return true;
    }

    private static void validateXML(String profilesXML)
    {
        URL schemaURL = ProfilesDefinitionParser.class_.getResource("Profiles.xsd");
        bool valid = XmlUtils.validateXML("Profiles.xsd", schemaURL, profilesXML);
        if (!valid) {
            throw new ProfilesDefinitionException("Profiles XML file is not valid (according to the schema). Check the log.");
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.profile.ProfilesDefinitionParser
* JD-Core Version:    0.7.0.1
*/