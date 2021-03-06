module org.serviio.delivery.GETMethodProcessor;

import java.lang;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.TreeMap;
import org.apache.http.ProtocolVersion;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.resource.transcode.TranscodingJobListener:ProgressData;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.upnp.protocol.http.transport.TransferMode;
import org.serviio.delivery;
import org.slf4j.Logger;

public class GETMethodProcessor : AbstractMethodProcessor
{
    override protected HttpMethod getMethod()
    {
        return HttpMethod.GET;
    }

    override protected HttpDeliveryContainer buildDeliveryContainer(ResourceRetrievalStrategy resourceRetrievalStrategy, ResourceInfo resourceInfo, MediaFormatProfile selectedVersion, QualityType quality, String path, TransferMode transferMode, Client client, long skipBytes, long streamSize, Double timeOffsetInSeconds, Double requestedDurationInSeconds, bool partialContent, bool deliverStream, ProtocolVersion requestHttpVersion, RangeHeaders requestRangeHeaders)
    {
        bool markAsRead = markAsReadRequired(requestRangeHeaders);

        return retrieveResource(resourceRetrievalStrategy, resourceInfo, selectedVersion, quality, path, transferMode, client, markAsRead, skipBytes, streamSize, timeOffsetInSeconds, requestedDurationInSeconds, partialContent, deliverStream, requestHttpVersion);
    }

    override protected HttpDeliveryContainer buildDeliveryContainerForTimeSeek(ResourceRetrievalStrategy resourceRetrievalStrategy, ResourceInfo resourceInfo, MediaFormatProfile selectedVersion, QualityType quality, String path, TransferMode transferMode, Client client, ProtocolVersion requestHttpVersion, Long fileSize, RangeHeaders fixedRange)
    {
        bool markAsRead = markAsReadRequired(fixedRange);

        DeliveryContainer deliveryContainer = resourceRetrievalStrategy.retrieveResource(resourceInfo.getResourceId(), selectedVersion, quality, path, null, null, client, markAsRead);

        TranscodingJobListener jobListener = deliveryContainer.getTranscodingJobListener();
        if ((jobListener is null) || (jobListener.getFilesizeMap().size() == 0))
        {
            this.log.debug_("Unsupported time range request because current filesize is_ not available, sending back 406");
            throw new HttpResponseCodeException(406);
        }
        TreeMap!(Double, ProgressData) filesizeMap = jobListener.getFilesizeMap();
        Long startByte = convertSecondsToBytes(new Double(fixedRange.getStart(RangeUnit.SECONDS).doubleValue()), filesizeMap);
        this.log.debug_(String_format("Delivering bytes %s - %s from transcoded file, based on time range %s - %s", cast(Object[])[ startByte.toString(), fileSize.toString(), fixedRange.getStart(RangeUnit.SECONDS).toString(), fixedRange.getEnd(RangeUnit.SECONDS).toString() ]));
        return super.retrieveResource(deliveryContainer, resourceInfo, transferMode, client, startByte.longValue(), fileSize.longValue(), true, true, requestHttpVersion);
    }

    override protected HttpDeliveryContainer prepareContainer(Map!(String, String) responseHeaders, DeliveryContainer container, TransferMode transferMode, Long skip, Long fileSize, bool partialContent, ProtocolVersion requestHttpVersion, bool transcoded, bool alwaysCloseConnection, bool deliverStream)
    {
        InputStream is_ = deliverStream ? (cast(StreamDeliveryContainer)container).getFileStream() : new ByteArrayInputStream(new byte[0]);
        Long contentLengthToRead = Long.valueOf(deliverStream ? new Long(fileSize.longValue()).longValue() : 0L);
        if ((container.getResourceInfo().isTranscoded()) && (alwaysCloseConnection))
        {
            contentLengthToRead = Long.valueOf(-1L);
            this.log.debug_("Entity will be consumed till the end");
        }
        this.log.debug_(String_format("Stream entity has length: %s", cast(Object[])[ contentLengthToRead ]));
        seekInInputStream(is_, skip);
        return new HttpDeliveryContainer(responseHeaders, is_, partialContent, requestHttpVersion, transferMode, transcoded, contentLengthToRead);
    }

    private bool markAsReadRequired(RangeHeaders rangeHeaders)
    {
        bool offsetRequested = false;
        if (rangeHeaders !is null)
        {
            Long start = rangeHeaders.hasHeaders(RangeUnit.BYTES) ? rangeHeaders.getStartAsLong(RangeUnit.BYTES) : null;
            start = (start is null) && (rangeHeaders.hasHeaders(RangeUnit.SECONDS)) ? rangeHeaders.getStartAsLong(RangeUnit.SECONDS) : null;
            offsetRequested = (start !is null) && (!start.opEquals(new Long(0L)));
        }
        if (!offsetRequested) {
            return true;
        }
        return false;
    }

    private HttpDeliveryContainer retrieveResource(ResourceRetrievalStrategy resourceRetrievalStrategy, ResourceInfo resourceInfo, MediaFormatProfile selectedVersion, QualityType quality, String path, TransferMode transferMode, Client client, bool markAsRead, long skipBytes, long streamSize, Double timeOffsetInSeconds, Double requestedDurationInSeconds, bool partialContent, bool deliverStream, ProtocolVersion requestHttpVersion)
    {
        DeliveryContainer deliveryContainer = resourceRetrievalStrategy.retrieveResource(resourceInfo.getResourceId(), selectedVersion, quality, path, timeOffsetInSeconds, requestedDurationInSeconds, client, markAsRead);
        Long deliveredSize = deliveryContainer.getResourceInfo().getFileSize();
        Long realStreamSize = Long.valueOf((!partialContent) && (deliveredSize !is null) ? deliveredSize.longValue() : streamSize);
        return super.retrieveResource(deliveryContainer, resourceInfo, transferMode, client, skipBytes, realStreamSize.longValue(), partialContent, deliverStream, requestHttpVersion);
    }

    private void seekInInputStream(InputStream is_, Long skip)
    {
        try
        {
            is_.skip(skip.longValue());
        }
        catch (IOException e)
        {
            this.log.error("Cannot set starting index for the transport");
            throw new RuntimeException("Cannot skip file stream to requested byte: " ~ e.getMessage());
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.GETMethodProcessor
* JD-Core Version:    0.7.0.1
*/