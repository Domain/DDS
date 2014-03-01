module org.serviio.delivery.HEADMethodProcessor;

import java.io.IOException;
import java.util.Map;
import org.apache.http.ProtocolVersion;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.upnp.protocol.http.transport.TransferMode;

public class HEADMethodProcessor
  : AbstractMethodProcessor
{
  protected ResourceDeliveryProcessor.HttpMethod getMethod()
  {
    return ResourceDeliveryProcessor.HttpMethod.HEAD;
  }
  
  protected HttpDeliveryContainer buildDeliveryContainer(ResourceRetrievalStrategy resourceRetrievalStrategy, ResourceInfo resourceInfo, MediaFormatProfile selectedVersion, QualityType quality, String path, TransferMode transferMode, Client client, long skipBytes, long streamSize, Double timeOffsetInSeconds, Double requestedDurationInSeconds, bool partialContent, bool deliverStream, ProtocolVersion requestHttpVersion, RangeHeaders requestRangeHeaders)
  {
    return retrieveResource(null, resourceInfo, transferMode, client, skipBytes, streamSize, partialContent, deliverStream, requestHttpVersion);
  }
  
  protected HttpDeliveryContainer buildDeliveryContainerForTimeSeek(ResourceRetrievalStrategy resourceRetrievalStrategy, ResourceInfo resourceInfo, MediaFormatProfile selectedVersion, QualityType quality, String path, TransferMode transferMode, Client client, ProtocolVersion requestHttpVersion, Long fileSize, RangeHeaders fixedRange)
  {
    return retrieveResource(null, resourceInfo, transferMode, client, 0L, fileSize.longValue(), true, true, requestHttpVersion);
  }
  
  protected HttpDeliveryContainer prepareContainer(Map!(String, Object) responseHeaders, DeliveryContainer container, TransferMode transferMode, Long skip, Long fileSize, bool partialContent, ProtocolVersion requestHttpVersion, bool transcoded, bool alwaysCloseConnection, bool deliverStream)
  {
    return new HttpDeliveryContainer(responseHeaders, null, partialContent, requestHttpVersion, transferMode, transcoded, fileSize);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.HEADMethodProcessor
 * JD-Core Version:    0.7.0.1
 */