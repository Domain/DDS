module org.serviio.upnp.protocol.http.transport.LGProtocolHandler;

import java.lang.Long;
import org.serviio.delivery.HttpResponseCodeException;
import org.serviio.delivery.RangeHeaders;
import org.serviio.delivery.RangeHeaders:RangeUnit;
import org.serviio.upnp.protocol.http.transport.DLNAProtocolHandler;

public class LGProtocolHandler : DLNAProtocolHandler
{
    override public bool supportsRangeHeader(RangeUnit type, bool http11, bool transcoded, RangeHeaders rangeHeaders)
    {
        if (type == RangeUnit.BYTES)
        {
            if (!transcoded) {
                return true;
            }
            return false;
        }
        return super.supportsRangeHeader(type, http11, transcoded, rangeHeaders);
    }

    override protected RangeHeaders unsupportedRangeHeader(RangeUnit type, RangeHeaders range, bool http11, bool transcoded, Long streamSize)
    {
        if ((type == RangeUnit.BYTES) && 
            (transcoded)) {
                return RangeHeaders.create(RangeUnit.BYTES, range.getStart(RangeUnit.BYTES).doubleValue(), range.getEnd(RangeUnit.BYTES) !is null ? range.getEnd(RangeUnit.BYTES).doubleValue() : streamSize.longValue(), -1L);
            }
        return super.unsupportedRangeHeader(type, range, http11, transcoded, streamSize);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.http.transport.LGProtocolHandler
* JD-Core Version:    0.7.0.1
*/