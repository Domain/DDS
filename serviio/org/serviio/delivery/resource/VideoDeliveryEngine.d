module org.serviio.delivery.resource.VideoDeliveryEngine;

import java.lang.Long;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map:Entry;
import org.serviio.delivery.VideoMediaInfo;
import org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryEngine;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.serviio.delivery.resource.transcode.VideoTranscodingDefinition;
import org.serviio.delivery.resource.transcode.VideoTranscodingMatch;
import org.serviio.dlna.AudioCodec;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.MediaFormatProfileResolver;
import org.serviio.dlna.SourceAspectRatio;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.dlna.VideoCodec;
import org.serviio.dlna.VideoContainer;
import org.serviio.external.FFMPEGWrapper;
import org.serviio.external.ResizeDefinition;
import org.serviio.library.entities.Video;
import org.serviio.library.local.metadata.TransportStreamTimestamp;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.Profile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VideoDeliveryEngine
: AbstractTranscodingDeliveryEngine!(VideoMediaInfo, Video)
{
    private static VideoDeliveryEngine instance;
    private static final Logger log = LoggerFactory.getLogger!(VideoDeliveryEngine);

    public static VideoDeliveryEngine getInstance()
    {
        if (instance is null) {
            instance = new VideoDeliveryEngine();
        }
        return instance;
    }

    override protected LinkedHashMap!(QualityType, List!(VideoMediaInfo)) retrieveOriginalMediaInfo(Video mediaItem, Profile rendererProfile)
    {
        List!(MediaFormatProfile) fileProfiles = MediaFormatProfileResolver.resolve(mediaItem);
        LinkedHashMap!(QualityType, List!(VideoMediaInfo)) mediaInfoMap = new LinkedHashMap();
        List!(VideoMediaInfo) mediaInfos = new ArrayList();
        foreach (MediaFormatProfile fileProfile ; fileProfiles) {
            mediaInfos.add(new VideoMediaInfo(mediaItem.getId(), fileProfile, mediaItem.getFileSize(), mediaItem.getWidth(), mediaItem.getHeight(), mediaItem.getBitrate(), false, mediaItem.isLive(), mediaItem.getDuration(), rendererProfile.getMimeType(fileProfile), QualityType.ORIGINAL));
        }
        mediaInfoMap.put(QualityType.ORIGINAL, mediaInfos);
        return mediaInfoMap;
    }

    override protected LinkedHashMap!(QualityType, List!(VideoMediaInfo)) retrieveTranscodedMediaInfo(Video mediaItem, Profile rendererProfile, Long fileSize)
    {
        LinkedHashMap!(QualityType, List!(VideoMediaInfo)) transcodedMI = new LinkedHashMap();
        Map!(QualityType, TranscodingDefinition) trDefs = getMatchingTranscodingDefinitions(mediaItem, rendererProfile, false);
        if (trDefs.size() > 0)
        {
            foreach (Map.Entry!(QualityType, TranscodingDefinition) trDefEntry ; trDefs.entrySet())
            {
                QualityType qualityType = cast(QualityType)trDefEntry.getKey();
                VideoTranscodingDefinition trDef = cast(VideoTranscodingDefinition)trDefEntry.getValue();

                AudioCodec targetAudioCodec = (mediaItem.getAudioCodec() !is null) && (trDef.getTargetAudioCodec() !is null) ? trDef.getTargetAudioCodec() : mediaItem.getAudioCodec();
                VideoCodec targetVideoCodec = FFMPEGWrapper.getTargetVideoCodec(mediaItem, trDef);
                Integer targetBitrate = trDef.getMaxVideoBitrate() !is null ? trDef.getMaxVideoBitrate() : mediaItem.getBitrate();
                ResizeDefinition targetDimensions = FFMPEGWrapper.getTargetVideoDimensions(mediaItem, trDef.getMaxHeight(), trDef.getDar(), trDef.getTargetContainer());
                try
                {
                    List!(VideoMediaInfo) mediaInfos = new ArrayList();
                    List!(MediaFormatProfile) transcodedProfiles = MediaFormatProfileResolver.resolveVideoFormat(mediaItem.getFileName(), trDef.getTargetContainer(), targetVideoCodec, targetAudioCodec, Integer.valueOf(targetDimensions.width), Integer.valueOf(targetDimensions.height), targetBitrate, trDef.getTargetContainer() == VideoContainer.M2TS ? TransportStreamTimestamp.VALID : TransportStreamTimestamp.NONE);
                    foreach (MediaFormatProfile transcodedProfile ; transcodedProfiles)
                    {
                        log.debug_(String.format("Found Format profile for transcoded file %s: %s", cast(Object[])[ mediaItem.getFileName(), transcodedProfile ]));

                        mediaInfos.add(new VideoMediaInfo(mediaItem.getId(), transcodedProfile, fileSize, Integer.valueOf(targetDimensions.width), Integer.valueOf(targetDimensions.height), targetBitrate, true, mediaItem.isLive(), mediaItem.getDuration(), rendererProfile.getMimeType(transcodedProfile), qualityType));
                    }
                    transcodedMI.put(qualityType, mediaInfos);
                }
                catch (UnsupportedDLNAMediaFileFormatException e)
                {
                    log.warn(String.format("Cannot get media info for transcoded file %s: %s", cast(Object[])[ mediaItem.getFileName(), e.getMessage() ]));
                }
            }
            return transcodedMI;
        }
        log.warn(String.format("Cannot find matching transcoding definition for file %s", cast(Object[])[ mediaItem.getFileName() ]));
        return new LinkedHashMap();
    }

    override public TranscodingDefinition getMatchingTranscodingDefinition(List!(TranscodingDefinition) tDefs, Video mediaItem)
    {
        Iterator i;
        if ((tDefs !is null) && (tDefs.size() > 0)) {
            for (i = tDefs.iterator(); i.hasNext();)
            {
                tDef = cast(TranscodingDefinition)i.next();
                List!(VideoTranscodingMatch) matches = (cast(VideoTranscodingDefinition)tDef).getMatches();
                foreach (VideoTranscodingMatch match ; matches) {
                    if (match.matches(mediaItem.getContainer(), mediaItem.getVideoCodec(), mediaItem.getAudioCodec(), mediaItem.getH264Profile(), mediaItem.getH264Levels(), mediaItem.getFtyp(), getOnlineContentType(mediaItem), mediaItem.getSar().isSquarePixels(), mediaItem.getVideoFourCC())) {
                        return cast(VideoTranscodingDefinition)tDef;
                    }
                }
            }
        }
        TranscodingDefinition tDef;
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.VideoDeliveryEngine
* JD-Core Version:    0.7.0.1
*/