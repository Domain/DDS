module org.serviio.delivery.resource.ImageDeliveryEngine;

import java.lang;
import java.awt.Dimension;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryContainer;
import org.serviio.delivery.ImageMediaInfo;
import org.serviio.delivery.StreamDeliveryContainer;
import org.serviio.delivery.resource.transcode.ImageTranscodingDefinition;
import org.serviio.delivery.resource.transcode.ImageTranscodingMatch;
import org.serviio.delivery.resource.transcode.ImageTranscodingProfilesProvider;
import org.serviio.delivery.resource.transcode.TranscodingCache;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.serviio.dlna.ImageContainer;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.MediaFormatProfileResolver;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.external.DCRawWrapper;
import org.serviio.library.entities.Image;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.local.service.MediaService;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.ImageResolutions;
import org.serviio.profile.Profile;
import org.serviio.util.FileUtils;
import org.serviio.util.ImageUtils;
import org.serviio.util.Tupple;
import org.serviio.delivery.resource.AbstractDeliveryEngine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ImageDeliveryEngine : AbstractDeliveryEngine!(ImageMediaInfo, Image)
{
    private static Logger log;
    private static List!(MediaFormatProfile) JPEG_PROFILES;
    private static TranscodingCache transcodingCache;
    private static ImageDeliveryEngine instance;

    static this()
    {
        log = LoggerFactory.getLogger!(ImageDeliveryEngine);
        JPEG_PROFILES = Arrays.asList(cast(MediaFormatProfile[])[ MediaFormatProfile.JPEG_LRG, MediaFormatProfile.JPEG_MED, MediaFormatProfile.JPEG_SM ]);
        transcodingCache = new TranscodingCache();
    }

    public static ImageDeliveryEngine getInstance()
    {
        if (instance is null) {
            instance = new ImageDeliveryEngine();
        }
        return instance;
    }

    override protected LinkedHashMap!(QualityType, List!(ImageMediaInfo)) retrieveTranscodedMediaInfo(Image mediaItem, Profile rendererProfile, Long fileSize)
    {
        log.debug_(String_format("Getting media info for transcoded versions of file %s", cast(Object[])[ mediaItem.getFileName() ]));
        LinkedHashMap!(QualityType, List!(ImageMediaInfo)) resourceInfos = new LinkedHashMap!(QualityType, List!(ImageMediaInfo))();
        try
        {
            auto originalWillBeTransformed = imageWillBeTransformed(mediaItem, rendererProfile, QualityType.ORIGINAL);
            if (originalWillBeTransformed) {
                try
                {
                    resourceInfos.put(getQualityType(MediaFormatProfile.JPEG_LRG), Collections.singletonList(createTranscodedImageInfoForProfile(mediaItem, MediaFormatProfile.JPEG_LRG, null, rendererProfile)));
                }
                catch (UnsupportedDLNAMediaFileFormatException ex)
                {
                    log.warn(String_format("Cannot get media info for resized original file %s: %s", cast(Object[])[ mediaItem.getFileName(), ex.getMessage() ]));
                }
            }
            List!(MediaFormatProfile) fileProfiles = MediaFormatProfileResolver.resolve(mediaItem);
            List!(MediaFormatProfile) optionalProfiles = ImageTranscodingProfilesProvider.getAvailableTranscodingProfiles(fileProfiles);
            if ((optionalProfiles !is null) && (imageIsResizable(mediaItem))) {
                foreach (MediaFormatProfile targetProfile ; optionalProfiles) {
                    if ((!originalWillBeTransformed) || ((originalWillBeTransformed) && (targetProfile != MediaFormatProfile.JPEG_LRG))) {
                        try
                        {
                            resourceInfos.put(getQualityType(targetProfile), Collections.singletonList(createTranscodedImageInfoForProfile(mediaItem, targetProfile, fileSize, rendererProfile)));
                        }
                        catch (UnsupportedDLNAMediaFileFormatException ex)
                        {
                            log.warn(String_format("Cannot get media info for transcoded file %s: %s", cast(Object[])[ mediaItem.getFileName(), ex.getMessage() ]));
                        }
                    }
                }
            }
        }
        catch (UnsupportedDLNAMediaFileFormatException ex1)
        {
            bool originalWillBeTransformed;
            log.warn(String_format("Unknown DLNA format profile of file %s: %s", cast(Object[])[ mediaItem.getFileName(), ex1.getMessage() ]));
        }
        return resourceInfos;
    }

    override protected ImageMediaInfo retrieveTranscodedMediaInfoForVersion(Image mediaItem, MediaFormatProfile selectedVersion, QualityType selectedQuality, Profile rendererProfile)
    {
        log.debug_(String_format("Getting media info for transcoded version of file %s", cast(Object[])[ mediaItem.getFileName() ]));
        return createTranscodedImageInfoForProfile(mediaItem, selectedVersion, null, rendererProfile);
    }

    override protected DeliveryContainer retrieveTranscodedResource(Image mediaItem, MediaFormatProfile selectedVersion, QualityType selectedQuality, Double timeOffsetInSeconds, Double durationInSeconds, Client client)
    {
        log.debug_(String_format("Retrieving transcoded version of file %s using format profile %s", cast(Object[])[ mediaItem.getFileName(), selectedVersion.toString() ]));
        byte[] transcodedImageBytes = null;
        synchronized (transcodingCache)
        {
            if (transcodingCache.isInCache(mediaItem.getId(), selectedVersion))
            {
                transcodedImageBytes = transcodingCache.getCachedBytes();
            }
            else
            {
                transcodedImageBytes = transcodeImage(mediaItem, selectedVersion, client.getRendererProfile());
                transcodingCache.storeInCache(mediaItem.getId(), selectedVersion, transcodedImageBytes);
            }
        }
        DeliveryContainer container = new StreamDeliveryContainer(new ByteArrayInputStream(transcodedImageBytes), createTranscodedImageInfoForProfile(mediaItem, selectedVersion, Long.valueOf(transcodedImageBytes.length), client.getRendererProfile()));


        return container;
    }

    override protected bool fileCanBeTranscoded(Image mediaItem, Profile rendererProfile)
    {
        return imageIsResizable(mediaItem);
    }

    override protected bool fileWillBeTranscoded(Image mediaItem, MediaFormatProfile selectedVersion, QualityType selectedQuality, Profile rendererProfile)
    {
        List!(MediaFormatProfile) fileProfiles = MediaFormatProfileResolver.resolve(mediaItem);

        bool imageWillBeTransformed = imageWillBeTransformed(mediaItem, rendererProfile, selectedQuality);
        if (/*(selectedVersion is null) ||*/ (fileProfiles.contains(selectedVersion)))
        {
            if (!imageWillBeTransformed) {
                return false;
            }
            return true;
        }
        List!(MediaFormatProfile) optionalProfiles = ImageTranscodingProfilesProvider.getAvailableTranscodingProfiles(fileProfiles);
        if ((optionalProfiles !is null) && (optionalProfiles.size() > 0)) {
            return true;
        }
        return false;
    }

    override protected LinkedHashMap!(QualityType, List!(ImageMediaInfo)) retrieveOriginalMediaInfo(Image image, Profile rendererProfile)
    {
        if (!transcodeNeeded(image, rendererProfile, QualityType.ORIGINAL))
        {
            if (imageWillRotate(image, rendererProfile, false)) {
                return null;
            }
            List!(MediaFormatProfile) fileProfiles = MediaFormatProfileResolver.resolve(image);
            LinkedHashMap!(QualityType, List!(ImageMediaInfo)) result = new LinkedHashMap!(QualityType, List!(ImageMediaInfo))();
            foreach (MediaFormatProfile fileProfile ; fileProfiles) {
                result.put(QualityType.ORIGINAL, Collections.singletonList(new ImageMediaInfo(image.getId(), fileProfile, image.getFileSize(), image.getWidth(), image.getHeight(), false, rendererProfile.getMimeType(fileProfile), QualityType.ORIGINAL)));
            }
            return result;
        }
        return null;
    }

    override protected TranscodingDefinition getMatchingTranscodingDefinition(List!(TranscodingDefinition) tDefs, Image mediaItem)
    {
        Iterator!(TranscodingDefinition) i;
        if ((tDefs !is null) && (tDefs.size() > 0)) {
            for (i = tDefs.iterator(); i.hasNext();)
            {
                TranscodingDefinition tDef;
                tDef = cast(TranscodingDefinition)i.next();
                List!(ImageTranscodingMatch) matches = (cast(ImageTranscodingDefinition)tDef).getMatches();
                foreach (ImageTranscodingMatch match ; matches) {
                    if (match.matches(mediaItem.getContainer(), mediaItem.getChromaSubsampling())) {
                        return cast(ImageTranscodingDefinition)tDef;
                    }
                }
            }
        }
        return null;
    }

    private bool imageWillBeTransformed(Image mediaItem, Profile rendererProfile, QualityType quality)
    {
        bool originalTranscoded = transcodeNeeded(mediaItem, rendererProfile, quality);
        bool imageRotated = imageWillRotate(mediaItem, rendererProfile, originalTranscoded);
        return (originalTranscoded) || (imageRotated);
    }

    private ImageMediaInfo createTranscodedImageInfoForProfile(Image originalImage, MediaFormatProfile selectedVersion, Long fileSize, Profile rendererProfile)
    {
        if (isTranscodingValid(originalImage, selectedVersion))
        {
            int maxWidth = 0;
            int maxHeight = 0;
            QualityType quality = getQualityType(selectedVersion);
            if (selectedVersion == MediaFormatProfile.JPEG_SM)
            {
                maxWidth = (cast(Integer)rendererProfile.getAllowedImageResolutions().getSmall().getValueA()).intValue();
                maxHeight = (cast(Integer)rendererProfile.getAllowedImageResolutions().getSmall().getValueB()).intValue();
            }
            else if (selectedVersion == MediaFormatProfile.JPEG_MED)
            {
                maxWidth = (cast(Integer)rendererProfile.getAllowedImageResolutions().getMedium().getValueA()).intValue();
                maxHeight = (cast(Integer)rendererProfile.getAllowedImageResolutions().getMedium().getValueB()).intValue();
            }
            else
            {
                maxWidth = (cast(Integer)rendererProfile.getAllowedImageResolutions().getLarge().getValueA()).intValue();
                maxHeight = (cast(Integer)rendererProfile.getAllowedImageResolutions().getLarge().getValueB()).intValue();
            }
            Dimension newDimension = ImageUtils.getResizedDimensions(originalImage.getWidth().intValue(), originalImage.getHeight().intValue(), maxWidth, maxHeight);
            if (imageWillRotate(originalImage, rendererProfile, true)) {
                return new ImageMediaInfo(originalImage.getId(), selectedVersion, fileSize, Integer.valueOf(cast(int)newDimension.getHeight()), Integer.valueOf(cast(int)newDimension.getWidth()), true, rendererProfile.getMimeType(selectedVersion), quality);
            }
            return new ImageMediaInfo(originalImage.getId(), selectedVersion, fileSize, Integer.valueOf(cast(int)newDimension.getWidth()), Integer.valueOf(cast(int)newDimension.getHeight()), true, rendererProfile.getMimeType(selectedVersion), quality);
        }
        throw new UnsupportedDLNAMediaFileFormatException("Images can only be transformed to JPEG continer");
    }

    private QualityType getQualityType(MediaFormatProfile mediaFormatProfile)
    {
        if (mediaFormatProfile == MediaFormatProfile.JPEG_SM) {
            return QualityType.LOW;
        }
        if (mediaFormatProfile == MediaFormatProfile.JPEG_MED) {
            return QualityType.MEDIUM;
        }
        return QualityType.ORIGINAL;
    }

    private byte[] transcodeImage(Image originalImage, MediaFormatProfile selectedVersion, Profile rendererProfile)
    {
        byte[] originalImageBytes = getImageBytes(originalImage);
        if (isTranscodingValid(originalImage, selectedVersion)) {
            try
            {
                byte[] transcodedImage = null;
                if (selectedVersion == MediaFormatProfile.JPEG_SM) {
                    transcodedImage = ImageUtils.resizeImageAsJPG(originalImageBytes, (cast(Integer)rendererProfile.getAllowedImageResolutions().getSmall().getValueA()).intValue(), (cast(Integer)rendererProfile.getAllowedImageResolutions().getSmall().getValueB()).intValue()).getImageData();
                } else if (selectedVersion == MediaFormatProfile.JPEG_MED) {
                    transcodedImage = ImageUtils.resizeImageAsJPG(originalImageBytes, (cast(Integer)rendererProfile.getAllowedImageResolutions().getMedium().getValueA()).intValue(), (cast(Integer)rendererProfile.getAllowedImageResolutions().getMedium().getValueB()).intValue()).getImageData();
                } else if (selectedVersion == MediaFormatProfile.JPEG_LRG) {
                    transcodedImage = ImageUtils.resizeImageAsJPG(originalImageBytes, (cast(Integer)rendererProfile.getAllowedImageResolutions().getLarge().getValueA()).intValue(), (cast(Integer)rendererProfile.getAllowedImageResolutions().getLarge().getValueB()).intValue()).getImageData();
                } else {
                    throw new UnsupportedDLNAMediaFileFormatException(String_format("Unsupported transcoding profile requested: %s", cast(Object[])[ selectedVersion.toString() ]));
                }
                if (imageWillRotate(originalImage, rendererProfile, true)) {}
                return ImageUtils.rotateImage(transcodedImage, originalImage.getRotation().intValue()).getImageData();
            }
            catch (Throwable e)
            {
                throw new IOException("Cannot transcode image: " ~ e.toString(), e);
            }
        }
        throw new UnsupportedDLNAMediaFileFormatException("Only JPEG can be usedas a target container for image trancoding at the moment");
    }

    private byte[] getImageBytes(Image image)
    {
        try
        {
            if (image.isLocalMedia())
            {
                File imageFile = MediaService.getFile(image.getId());
                if (image.getContainer() == ImageContainer.RAW) {
                    return DCRawWrapper.retrieveThumbnailFromRawFile(FileUtils.getProperFilePath(imageFile));
                }
                return FileUtils.readFileBytes(imageFile);
            }
            InputStream onlineStream = getOnlineInputStream(image);
            return FileUtils.readFileBytes(onlineStream);
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }

    private bool transcodeNeeded(Image image, Profile rendererProfile, QualityType quality)
    {
        if (getMatchingTranscodingDefinitions(image, rendererProfile, false).get(quality) !is null) {
            return true;
        }
        if ((imageIsResizable(image)) && 
            (rendererProfile.isLimitImageResolution()))
        {
            if (image.getContainer() == ImageContainer.JPEG)
            {
                if ((image.getWidth().intValue() <= (cast(Integer)rendererProfile.getAllowedImageResolutions().getLarge().getValueA()).intValue()) && (image.getHeight().intValue() <= (cast(Integer)rendererProfile.getAllowedImageResolutions().getLarge().getValueB()).intValue())) {
                    return false;
                }
                return true;
            }
            if (image.getContainer() == ImageContainer.PNG)
            {
                if ((image.getWidth().intValue() <= (cast(Integer)rendererProfile.getAllowedImageResolutions().getLarge().getValueA()).intValue()) && (image.getHeight().intValue() <= (cast(Integer)rendererProfile.getAllowedImageResolutions().getLarge().getValueB()).intValue())) {
                    return false;
                }
                return true;
            }
            if (image.getContainer() == ImageContainer.GIF)
            {
                if ((image.getWidth().intValue() <= 1600) && (image.getHeight().intValue() <= 1200)) {
                    return false;
                }
                return true;
            }
            return false;
        }
        return false;
    }

    private bool imageWillRotate(Image image, Profile profile, bool willBeResized)
    {
        if ((image.getRotation() !is null) && (!(image.getRotation() == (new Integer(0)))) && ((profile.isAutomaticImageRotation()) || (willBeResized))) {
            return true;
        }
        return false;
    }

    private bool isTranscodingValid(Image originalImage, MediaFormatProfile targetFormat)
    {
        return ((originalImage.getContainer() == ImageContainer.JPEG) || (originalImage.getContainer() == ImageContainer.PNG) || (originalImage.getContainer() == ImageContainer.GIF) || (originalImage.getContainer() == ImageContainer.RAW)) && (JPEG_PROFILES.contains(targetFormat));
    }

    private bool imageIsResizable(Image image)
    {
        if ((image.getWidth() is null) || (image.getHeight() is null)) {
            return false;
        }
        return true;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.ImageDeliveryEngine
* JD-Core Version:    0.7.0.1
*/