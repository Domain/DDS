module org.serviio.delivery.AbstractMethodProcessor;

import java.lang;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map:Entry;
import java.util.TreeMap;
import org.apache.http.ProtocolVersion;
import org.serviio.delivery.resource.transcode.TranscodingJobListener:ProgressData;
import org.serviio.delivery.subtitles.SubtitlesInfo;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.upnp.protocol.http.transport.ResourceTransportProtocolHandler;
import org.serviio.upnp.protocol.http.transport.TransferMode;
import org.serviio.util.ObjectValidator;
import org.serviio.delivery.HttpDeliveryContainer;
import org.serviio.delivery.ResourceInfo;
import org.serviio.delivery.Client;
import org.serviio.delivery.RangeHeaders;
import org.serviio.delivery.DeliveryContainer;
import org.serviio.delivery.ResourceRetrievalStrategy;
import org.serviio.delivery.ImageMediaInfo;
import org.serviio.delivery.AudioMediaInfo;
import org.serviio.delivery.VideoMediaInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractMethodProcessor
{
    protected Logger log;
    private static Long TRANSCODED_VIDEO_CONTENT_LENGTH;
    private static Long TRANSCODED_AUDIO_CONTENT_LENGTH;
    private static Long TRANSCODED_IMAGE_CONTENT_LENGTH;
    private static Long TRANSCODED_SUBTITLE_CONTENT_LENGTH;

    static this()
    {
        TRANSCODED_VIDEO_CONTENT_LENGTH = new Long(50000000000L);
        TRANSCODED_AUDIO_CONTENT_LENGTH = new Long(900000000L);
        TRANSCODED_IMAGE_CONTENT_LENGTH = new Long(9000000L);
        TRANSCODED_SUBTITLE_CONTENT_LENGTH = new Long(300000L);
    }

    public this()
    {
        log = LoggerFactory.getLogger!AbstractMethodProcessor();
    }

    protected abstract HttpDeliveryContainer buildDeliveryContainer(ResourceRetrievalStrategy paramResourceRetrievalStrategy, ResourceInfo paramResourceInfo, MediaFormatProfile paramMediaFormatProfile, QualityType paramQualityType, String paramString, TransferMode paramTransferMode, Client paramClient, long paramLong1, long paramLong2, Double paramDouble1, Double paramDouble2, bool paramBoolean1, bool paramBoolean2, ProtocolVersion paramProtocolVersion, RangeHeaders paramRangeHeaders);

    protected abstract HttpDeliveryContainer buildDeliveryContainerForTimeSeek(ResourceRetrievalStrategy paramResourceRetrievalStrategy, ResourceInfo paramResourceInfo, MediaFormatProfile paramMediaFormatProfile, QualityType paramQualityType, String paramString, TransferMode paramTransferMode, Client paramClient, ProtocolVersion paramProtocolVersion, Long paramLong, RangeHeaders paramRangeHeaders);

    protected abstract HttpDeliveryContainer prepareContainer(Map!(String, String) paramMap, DeliveryContainer paramDeliveryContainer, TransferMode paramTransferMode, Long paramLong1, Long paramLong2, bool paramBoolean1, ProtocolVersion paramProtocolVersion, bool paramBoolean2, bool paramBoolean3, bool paramBoolean4);

    protected abstract HttpMethod getMethod();

    public HttpDeliveryContainer handleRequest(ResourceRetrievalStrategy resourceRetrievalStrategy, ResourceInfo resourceInfo, MediaFormatProfile selectedVersion, QualityType quality, String path, Map!(String, String) requestHeaders, RangeHeaders requestRangeHeaders, ProtocolVersion requestHttpVersion, Integer protocolInfoIndex, Client client, ResourceTransportProtocolHandler protocolHandler)
    {
        TransferMode transferMode = getTransferMode(requestHeaders, resourceInfo);

        HttpDeliveryContainer responseContainer = null;
        Long fileSize = computeFileSize(resourceInfo);
        RangeHeaders range = null;
        if (requestRangeHeaders !is null) {
            if (!resourceInfo.isLive())
            {
                if (requestRangeHeaders.hasHeaders(RangeUnit.BYTES))
                {
                    range = protocolHandler.handleByteRange(requestRangeHeaders, requestHttpVersion, resourceInfo, fileSize);
                    if (range !is null) {
                        responseContainer = buildDeliveryContainer(resourceRetrievalStrategy, resourceInfo, selectedVersion, quality, path, transferMode, client, range.getStartAsLong(RangeUnit.BYTES).longValue(), range.getEndAsLong(RangeUnit.BYTES).longValue() - range.getStartAsLong(RangeUnit.BYTES).longValue() + 1L, null, null, true, range.getTotal(RangeUnit.BYTES).longValue() != -1L, requestHttpVersion, requestRangeHeaders);
                    }
                }
                if ((responseContainer is null) && (requestRangeHeaders.hasHeaders(RangeUnit.SECONDS)) && (resourceInfo.getDuration() !is null))
                {
                    range = protocolHandler.handleTimeRange(requestRangeHeaders, requestHttpVersion, resourceInfo);
                    if (range !is null) {
                        if ((range.getStart(RangeUnit.SECONDS).longValue() == 0L) && (range.getEnd(RangeUnit.SECONDS).longValue() == new Long(resourceInfo.getDuration().intValue()).longValue()))
                        {
                            responseContainer = buildDeliveryContainer(resourceRetrievalStrategy, resourceInfo, selectedVersion, quality, path, transferMode, client, 0L, fileSize.longValue(), null, null, false, true, requestHttpVersion, requestRangeHeaders);
                        }
                        else if (resourceInfo.getFileSize() is null)
                        {
                            if (client.isSupportsRandomTimeSeek())
                            {
                                Double requestedTimeOffset = range.getStart(RangeUnit.SECONDS);
                                Double requestedDuration = Double.valueOf(range.getEnd(RangeUnit.SECONDS).doubleValue() - range.getStart(RangeUnit.SECONDS).doubleValue());
                                responseContainer = buildDeliveryContainer(resourceRetrievalStrategy, resourceInfo, selectedVersion, quality, path, transferMode, client, 0L, fileSize.longValue(), requestedTimeOffset, requestedDuration, true, true, requestHttpVersion, requestRangeHeaders);
                            }
                            else
                            {
                                responseContainer = buildDeliveryContainerForTimeSeek(resourceRetrievalStrategy, resourceInfo, selectedVersion, quality, path, transferMode, client, requestHttpVersion, fileSize, range);
                            }
                        }
                        else
                        {
                            this.log.debug_(String_format("Delivering bytes %s - %s from native file, based on time range %s - %s", cast(Object[])[ range.getStart(RangeUnit.BYTES), range.getEnd(RangeUnit.BYTES), range.getStart(RangeUnit.SECONDS), range.getEnd(RangeUnit.SECONDS) ]));
                            responseContainer = buildDeliveryContainer(resourceRetrievalStrategy, resourceInfo, selectedVersion, quality, path, transferMode, client, range.getStartAsLong(RangeUnit.BYTES).longValue(), range.getEndAsLong(RangeUnit.BYTES).longValue() - range.getStartAsLong(RangeUnit.BYTES).longValue() + 1L, null, null, true, true, requestHttpVersion, requestRangeHeaders);
                        }
                    }
                }
            }
            else
            {
                this.log.warn("A range header was found on the incoming request for a live stream, sending back the whole stream");
            }
        }
        if (responseContainer is null) {
            responseContainer = buildDeliveryContainer(resourceRetrievalStrategy, resourceInfo, selectedVersion, quality, path, transferMode, client, 0L, fileSize.longValue(), null, null, false, true, requestHttpVersion, requestRangeHeaders);
        }
        protocolHandler.handleResponse(requestHeaders, responseContainer.getResponseHeaders(), getMethod(), requestHttpVersion, resourceInfo, protocolInfoIndex, transferMode, client, responseContainer.getFileSize(), range);
        return responseContainer;
    }

    protected TransferMode getTransferMode(Map!(String, String) headers, ResourceInfo resourceInfo)
    {
        String requestedTransferMode = cast(String)headers.get("transferMode.dlna.org");
        if ((requestedTransferMode !is null) && (ObjectValidator.isNotEmpty(requestedTransferMode))) {
            return /*TransferMode.*/getValueByHttpHeaderValue(requestedTransferMode);
        }
        if ((( cast(ImageMediaInfo)resourceInfo !is null )) || (( cast(SubtitlesInfo)resourceInfo !is null ))) {
            return TransferMode.INTERACTIVE;
        }
        return TransferMode.STREAMING;
    }

    protected Long computeFileSize(ResourceInfo resourceInfo)
    {
        if (resourceInfo.getFileSize() !is null) {
            return resourceInfo.getFileSize();
        }
        if (( cast(ImageMediaInfo)resourceInfo !is null )) {
            return TRANSCODED_IMAGE_CONTENT_LENGTH;
        }
        if (( cast(AudioMediaInfo)resourceInfo !is null )) {
            return TRANSCODED_AUDIO_CONTENT_LENGTH;
        }
        if (( cast(VideoMediaInfo)resourceInfo !is null )) {
            return TRANSCODED_VIDEO_CONTENT_LENGTH;
        }
        if (( cast(SubtitlesInfo)resourceInfo !is null )) {
            return TRANSCODED_SUBTITLE_CONTENT_LENGTH;
        }
        return null;
    }

    protected HttpDeliveryContainer retrieveResource(DeliveryContainer deliveryContainer, ResourceInfo resourceInfo, TransferMode transferMode, Client client, long skipBytes, long streamSize, bool partialContent, bool deliverStream, ProtocolVersion requestHttpVersion)
    {
        Map!(String, String) responseHeaders = new LinkedHashMap!(String, String)();
        responseHeaders.put("Content-Type", resourceInfo.getMimeType());
        if (resourceInfo.isLive()) {
            responseHeaders.put("Accept-Ranges", "none");
        }
        return prepareContainer(responseHeaders, deliveryContainer, transferMode, Long.valueOf(skipBytes), Long.valueOf(streamSize), partialContent, requestHttpVersion, resourceInfo.isTranscoded(), client.isExpectsClosedConnection(), deliverStream);
    }

    protected Long convertSecondsToBytes(Double seconds, TreeMap!(Double, ProgressData) filesizeMap)
    {
        if (seconds.doubleValue() == 0.0) {
            return Long.valueOf(0L);
        }
        if (seconds.doubleValue() <= (cast(Double)filesizeMap.lastKey()).doubleValue())
        {
            Entry!(Double, ProgressData) upperBoundary = filesizeMap.ceilingEntry(seconds);
            Entry!(Double, ProgressData) lowerBoundary = filesizeMap.floorEntry(seconds);
            if (lowerBoundary is null) {
                return convertSecondsToBytes((cast(ProgressData)upperBoundary.getValue()).getFileSize(), cast(Double)upperBoundary.getKey(), Long.valueOf(0L), Double.valueOf(0.0), seconds);
            }
            return convertSecondsToBytes((cast(ProgressData)upperBoundary.getValue()).getFileSize(), cast(Double)upperBoundary.getKey(), (cast(ProgressData)lowerBoundary.getValue()).getFileSize(), cast(Double)lowerBoundary.getKey(), seconds);
        }
        Entry!(Double, ProgressData) lastEntry = filesizeMap.lastEntry();
        Double secondsFromLast = Double.valueOf(seconds.doubleValue() - (cast(Double)lastEntry.getKey()).doubleValue());
        Double approxFileSizeSinceLastEntry = Double.valueOf((cast(ProgressData)lastEntry.getValue()).getBitrate().floatValue() * secondsFromLast.doubleValue() / 8.0 * 1024.0);
        return Long.valueOf((cast(ProgressData)lastEntry.getValue()).getFileSize().longValue() + approxFileSizeSinceLastEntry.longValue());
    }

    private Long convertSecondsToBytes(Long upperFileSize, Double upperTime, Long lowerFilesize, Double lowerTime, Double seconds)
    {
        if (upperTime == lowerTime) {
            return Long.valueOf(upperFileSize.longValue() * 1024L);
        }
        Long segmentFilesize = Long.valueOf(upperFileSize.longValue() - lowerFilesize.longValue());
        Double segmentDuration = Double.valueOf(upperTime.doubleValue() - lowerTime.doubleValue());
        Double kBytesPerSecond = Double.valueOf(segmentFilesize.longValue() / segmentDuration.doubleValue());
        Double approxkBytes = Double.valueOf(lowerFilesize.longValue() + kBytesPerSecond.doubleValue() * (seconds.doubleValue() - lowerTime.doubleValue()));
        return Long.valueOf(approxkBytes.longValue() * 1024L);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.AbstractMethodProcessor
* JD-Core Version:    0.7.0.1
*/