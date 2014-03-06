module org.serviio.delivery.RangeHeaders;

import java.lang;
import java.util.HashMap;
import java.util.Map;
import org.serviio.util.ObjectValidator;

public enum RangeUnit
{
    BYTES,  SECONDS
}

public enum RangeDefinition
{
    DLNA,  CDS
}

public class RangeHeaders
{
    public static immutable long UNSPECIFIED = -1L;
    private Map!(RangeUnit, RangeTupple) headers;

    private this(Map!(RangeUnit, RangeTupple) headers)
    {
        this.headers = headers;
    }

    public static RangeHeaders parseHttpRange(RangeDefinition definition, String bytesRangeHeaderValue, String timeRangeHeaderValue)
    {
        if ((ObjectValidator.isNotEmpty(bytesRangeHeaderValue)) || (ObjectValidator.isNotEmpty(timeRangeHeaderValue)))
        {
            Map!(RangeUnit, RangeTupple) headers = new HashMap();
            if (ObjectValidator.isNotEmpty(bytesRangeHeaderValue)) {
                headers.put(RangeUnit.BYTES, parseHttpBytesRange(bytesRangeHeaderValue));
            }
            if (ObjectValidator.isNotEmpty(timeRangeHeaderValue)) {
                if (definition == RangeDefinition.DLNA) {
                    headers.put(RangeUnit.SECONDS, parseHttpDLNATimeRange(timeRangeHeaderValue));
                } else if (definition == RangeDefinition.CDS) {
                    headers.put(RangeUnit.SECONDS, parseHttpCDSTimeRange(timeRangeHeaderValue));
                }
            }
            return new RangeHeaders(headers);
        }
        return null;
    }

    public static RangeHeaders create(RangeUnit unit, long from, long to, long total)
    {
        Map!(RangeUnit, RangeTupple) headers = new HashMap();
        headers.put(unit, new RangeTupple(from, to, total));
        return new RangeHeaders(headers);
    }

    public static RangeHeaders create(RangeUnit unit, double from, double to, long total)
    {
        Map!(RangeUnit, RangeTupple) headers = new HashMap();
        headers.put(unit, new RangeTupple(from, to, total));
        return new RangeHeaders(headers);
    }

    public void add(RangeUnit unit, long from, long to, long total)
    {
        this.headers.put(unit, new RangeTupple(from, to, total));
    }

    private static RangeTupple parseHttpBytesRange(String headerValue)
    {
        String rangeDefinition = headerValue.substring(headerValue.indexOf("=") + 1);
        Long startByte = Long.valueOf(rangeDefinition.substring(0, rangeDefinition.indexOf("-")));
        String endByteString = rangeDefinition.substring(rangeDefinition.indexOf("-") + 1);
        Long endByte = !endByteString.equals("") ? Long.valueOf(endByteString) : null;
        return new RangeTupple(Double.valueOf(startByte.doubleValue()), endByte !is null ? Double.valueOf(endByte.doubleValue()) : null);
    }

    private static RangeTupple parseHttpDLNATimeRange(String headerValue)
    {
        String nptDefinition = headerValue.substring(headerValue.indexOf("=") + 1);
        String startTime = nptDefinition.substring(0, nptDefinition.indexOf("-"));
        String endTime = nptDefinition.substring(nptDefinition.indexOf("-") + 1);
        Double startSecond = null;
        Double endSecond = null;

        startSecond = convertNPTToSeconds(startTime);
        endSecond = !endTime.equals("") ? convertNPTToSeconds(endTime) : null;
        return new RangeTupple(startSecond, endSecond);
    }

    private static RangeTupple parseHttpCDSTimeRange(String headerValue)
    {
        String startTime = headerValue;
        Double startSecond = Double.valueOf(startTime);
        return new RangeTupple(startSecond, null);
    }

    protected static Double convertNPTToSeconds(String npt)
    {
        if (npt.indexOf(":") > -1)
        {
            String[] timeFields = npt.split(":");
            if (timeFields.length != 3) {
                throw new NumberFormatException();
            }
            Double seconds = Double.valueOf(Double.valueOf(timeFields[0]).doubleValue() * 3600.0 + Double.valueOf(timeFields[1]).doubleValue() * 60.0 + Double.valueOf(timeFields[2]).doubleValue());

            return seconds;
        }
        return Double.valueOf(npt);
    }

    public Double getStart(RangeUnit unit)
    {
        return this.headers.containsKey(unit) ? (cast(RangeTupple)this.headers.get(unit)).getStart() : null;
    }

    public Long getStartAsLong(RangeUnit unit)
    {
        Double value = getStart(unit);
        return value !is null ? Long.valueOf(value.longValue()) : null;
    }

    public String getStartAsString(RangeUnit unit)
    {
        Double value = getStart(unit);
        return formatDoubleToString(value);
    }

    public String getEndAsString(RangeUnit unit)
    {
        Double value = getEnd(unit);
        return formatDoubleToString(value);
    }

    public Double getEnd(RangeUnit unit)
    {
        return this.headers.containsKey(unit) ? null : (cast(RangeTupple)this.headers.get(unit)).getEnd() !is null ? (cast(RangeTupple)this.headers.get(unit)).getEnd() : null;
    }

    public Long getEndAsLong(RangeUnit unit)
    {
        Double value = getEnd(unit);
        return value !is null ? Long.valueOf(value.longValue()) : null;
    }

    public Long getTotal(RangeUnit unit)
    {
        return this.headers.containsKey(unit) ? Long.valueOf((cast(RangeTupple)this.headers.get(unit)).getTotal().longValue()) : null;
    }

    public bool hasHeaders(RangeUnit unit)
    {
        return this.headers.containsKey(unit);
    }

    private String formatDoubleToString(Double value)
    {
        if (value !is null)
        {
            if (value.doubleValue() == value.doubleValue()) {
                return Long.toString(value.longValue());
            }
            return value.toString();
        }
        return null;
    }

    public static class RangeTupple
    {
        private Double start;
        private Double end;
        private Double total;

        public this(Double start, Double end)
        {
            this.start = start;
            this.end = end;
        }

        public this(long start, long end, long total)
        {
            this(new Double(Long.toString(start)), new Double(Long.toString(end)));
            this.total = new Double(Long.toString(total));
        }

        public this(double start, double end, long total)
        {
            this(Double.valueOf(start), Double.valueOf(end));
            this.total = new Double(Long.toString(total));
        }

        public Double getStart()
        {
            return this.start;
        }

        public Double getEnd()
        {
            return this.end;
        }

        public Double getTotal()
        {
            return this.total;
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.RangeHeaders
* JD-Core Version:    0.7.0.1
*/