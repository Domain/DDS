module org.serviio.upnp.protocol.http.transport.LGProtocolHandler;

import org.serviio.delivery.HttpResponseCodeException;
import org.serviio.delivery.RangeHeaders;
import org.serviio.delivery.RangeHeaders:RangeUnit;

public class LGProtocolHandler : DLNAProtocolHandler
{
    public bool supportsRangeHeader(RangeHeaders.RangeUnit type, bool http11, bool transcoded, RangeHeaders rangeHeaders)
    {
        if (type == RangeHeaders.RangeUnit.BYTES)
        {
            if (!transcoded) {
                return true;
            }
            return false;
        }
        return super.supportsRangeHeader(type, http11, transcoded, rangeHeaders);
    }

    protected RangeHeaders unsupportedRangeHeader(RangeHeaders.RangeUnit type, RangeHeaders range, bool http11, bool transcoded, Long streamSize)
    {
        if ((type == RangeHeaders.RangeUnit.BYTES) && 
            (transcoded)) {
                return RangeHeaders.create(RangeHeaders.RangeUnit.BYTES, range.getStart(RangeHeaders.RangeUnit.BYTES).doubleValue(), range.getEnd(RangeHeaders.RangeUnit.BYTES) !is null ? range.getEnd(RangeHeaders.RangeUnit.BYTES).doubleValue() : streamSize.longValue(), -1L);
            }
        return super.unsupportedRangeHeader(type, range, http11, transcoded, streamSize);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.http.transport.LGProtocolHandler
* JD-Core Version:    0.7.0.1
*/