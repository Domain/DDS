module org.serviio.cache.AbstractCacheDecorator;

import java.lang;

import org.apache.jcs.JCS;
import org.apache.jcs.access.exception.CacheException;
import org.serviio.cache.CacheDecorator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractCacheDecorator : CacheDecorator
{
    protected Logger log;
    protected JCS cache;
    protected String regionName;

    public this(String regionName)
    {
        log = LoggerFactory.getLogger!(AbstractCacheDecorator);
        try
        {
            this.cache = JCS.getInstance(regionName);
            this.regionName = regionName;
        }
        catch (CacheException e)
        {
            throw new RuntimeException(e);
        }
    }

    public void evictAll()
    {
        try
        {
            this.cache.clear();
            this.log.debug_(String_format("Cleared cache (%s)", cast(Object[])[ this.regionName ]));
        }
        catch (CacheException e)
        {
            this.log.warn(String_format("Could not clean local cache (%s): %s", cast(Object[])[ this.regionName, e.getMessage() ]));
        }
    }

    public void shutdown()
    {
        this.cache.dispose();
    }
}
