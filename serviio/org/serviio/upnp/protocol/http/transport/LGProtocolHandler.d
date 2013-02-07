module org.serviio.upnp.protocol.http.transport.LGProtocolHandler;

import java.lang.Long;
import org.serviio.delivery.HttpResponseCodeException;
import org.serviio.delivery.RangeHeaders;
import org.serviio.upnp.protocol.http.transport.DLNAProtocolHandler;

public class LGProtocolHandler : DLNAProtocolHandler
{
	override public bool supportsRangeHeader(RangeHeaders.RangeUnit type, bool http11, bool transcoded)
	{
		if (type == RangeHeaders.RangeUnit.BYTES) {
			if (!transcoded) {
				return true;
			}
			return false;
		}

		return super.supportsRangeHeader(type, http11, transcoded);
	}

	override protected RangeHeaders unsupportedRangeHeader(RangeHeaders.RangeUnit type, RangeHeaders range, bool http11, bool transcoded, Long streamSize)
	{
		if ((type == RangeHeaders.RangeUnit.BYTES) && 
			(transcoded))
		{
			return RangeHeaders.create(RangeHeaders.RangeUnit.BYTES, range.getStart(RangeHeaders.RangeUnit.BYTES).longValue(), (range.getEnd(RangeHeaders.RangeUnit.BYTES) !is null ? range.getEnd(RangeHeaders.RangeUnit.BYTES) : streamSize).longValue(), -1L);
		}

		return super.unsupportedRangeHeader(type, range, http11, transcoded, streamSize);
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.http.transport.LGProtocolHandler
* JD-Core Version:    0.6.2
*/