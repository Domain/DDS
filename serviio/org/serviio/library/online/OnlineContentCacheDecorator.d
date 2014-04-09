module org.serviio.library.online.OnlineContentCacheDecorator;

import java.lang.String;
import org.apache.jcs.JCS;
import org.apache.jcs.access.exception.CacheException;
import org.serviio.cache.AbstractCacheDecorator;
import org.serviio.library.online.metadata.OnlineCachable;
import org.serviio.library.online.OnlineCacheDecorator;
import org.slf4j.Logger;

public class OnlineContentCacheDecorator : AbstractCacheDecorator, OnlineCacheDecorator!(OnlineCachable)
{
    public this(String regionName)
    {
        super(regionName);
    }

    public OnlineCachable retrieve(String url)
    {
        OnlineCachable object = cast(OnlineCachable)this.cache.get(url);
        return object;
    }

    public void store(String url, OnlineCachable cachedValue)
    {
        try
        {
            this.cache.put(url, cachedValue);
            this.log.debug_(java.lang.String.format("Stored online content '%s' in the cache (%s), returning it", cast(Object[])[ url, this.regionName ]));
        }
        catch (CacheException e)
        {
            this.log.warn(java.lang.String.format("Could not store object to local cache (%s): %s", cast(Object[])[ this.regionName, e.getMessage() ]));
        }
    }

    public void evict(String url)
    {
        try
        {
            this.cache.remove(url);
            this.log.debug_(java.lang.String.format("Removed online content '%s' from cache (%s)", cast(Object[])[ url, this.regionName ]));
        }
        catch (CacheException e)
        {
            this.log.warn(java.lang.String.format("Could not remove feed %s from cache (%s): %s", cast(Object[])[ url, this.regionName, e.getMessage() ]));
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.OnlineContentCacheDecorator
* JD-Core Version:    0.7.0.1
*/