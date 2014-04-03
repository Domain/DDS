module org.serviio.upnp.protocol.http.transport.CDSProtocolHandler;

import java.lang;
import java.util.Map;
import org.apache.http.ProtocolVersion;
import org.serviio.delivery.Client;
import org.serviio.delivery.HttpResponseCodeException;
import org.serviio.delivery.RangeHeaders;
import org.serviio.delivery.RangeHeaders:RangeUnit;
import org.serviio.delivery.ResourceDeliveryProcessor:HttpMethod;
import org.serviio.delivery.ResourceInfo;
import org.serviio.upnp.protocol.http.transport.AbstractProtocolHandler;
import org.serviio.upnp.protocol.http.transport.TransferMode;

public class CDSProtocolHandler : AbstractProtocolHandler
{
    public static immutable String RANGE_HEADER = "Content-Range";

    public void handleResponse(Map!(String, String) requestHeaders, Map!(String, String) responseHeaders, HttpMethod httpMethod, ProtocolVersion requestHttpVersion, ResourceInfo resourceInfo, Integer protocolInfoIndex, TransferMode transferMode, Client client, Long streamSize, RangeHeaders range)
    {
        if (range !is null) {
            responseHeaders.put("Content-Range", range);
        }
    }

    override public bool supportsRangeHeader(RangeUnit type, bool http11, bool transcoded, RangeHeaders rangeHeaders)
    {
        if (type == RangeUnit.BYTES)
        {
            if (!transcoded) {
                return true;
            }
            return false;
        }
        return true;
    }

    override protected RangeHeaders unsupportedRangeHeader(RangeUnit type, RangeHeaders range, bool http11, bool transcoded, Long streamSize)
    {
        if (type == RangeUnit.BYTES) {
            return null;
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.http.transport.CDSProtocolHandler
* JD-Core Version:    0.7.0.1
*/