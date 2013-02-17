module org.serviio.library.online.OnlineContentCacheDecorator;

import java.lang.String;
import org.apache.jcs.access.exception.CacheException;
import org.serviio.cache.AbstractCacheDecorator;
import org.serviio.library.online.metadata.OnlineCachable;
import org.serviio.library.online.OnlineCacheDecorator;

public class OnlineContentCacheDecorator : AbstractCacheDecorator, OnlineCacheDecorator!(OnlineCachable)
{
	public this(String regionName)
	{
		super(regionName);
	}

	public OnlineCachable retrieve(String url)
	{
		OnlineCachable object = cast(OnlineCachable)cache.get(url);
		return object;
	}

	public void store(String url, OnlineCachable cachedValue)
	{
		try
		{
			cache.put(url, cachedValue);
			log.debug_(String_format("Stored online content '%s' in the cache (%s), returning it", cast(Object[])[ url, regionName ]));
		} catch (CacheException e) {
			log.warn(String_format("Could not store object to local cache (%s): %s", cast(Object[])[ regionName, e.getMessage() ]));
		}
	}

	public void evict(String url)
	{
		try
		{
			cache.remove(url);
			log.debug_(String_format("Removed online content '%s' from cache (%s)", cast(Object[])[ url, regionName ]));
		} catch (CacheException e) {
			log.warn(String_format("Could not remove feed %s from cache (%s): %s", cast(Object[])[ url, regionName, e.getMessage() ]));
		}
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.library.online.OnlineContentCacheDecorator
* JD-Core Version:    0.6.2
*/