module org.serviio.library.online.ThumbnailCacheDecorator;

import org.apache.jcs.JCS;
import org.apache.jcs.access.exception.CacheException;
import org.serviio.cache.AbstractCacheDecorator;
import org.serviio.library.entities.CoverImage;
import org.slf4j.Logger;

public class ThumbnailCacheDecorator
  : AbstractCacheDecorator
  , OnlineCacheDecorator!(CoverImage)
{
  public this(String regionName)
  {
    super(regionName);
  }
  
  public CoverImage retrieve(String url)
  {
    CoverImage object = cast(CoverImage)this.cache.get(url);
    return object;
  }
  
  public void store(String url, CoverImage cachedValue)
  {
    try
    {
      this.cache.put(url, cachedValue);
      this.log.debug_(String.format("Stored entry in the cache (%s), returning it", cast(Object[])[ this.regionName ]));
    }
    catch (CacheException e)
    {
      this.log.warn(String.format("Could not store object to local cache(%s): %s", cast(Object[])[ this.regionName, e.getMessage() ]));
    }
  }
  
  public void evict(String url)
  {
    try
    {
      this.cache.remove(url);
      this.log.debug_(String.format("Removed thumbnail %s from cache (%s)", cast(Object[])[ url, this.regionName ]));
    }
    catch (CacheException e)
    {
      this.log.warn(String.format("Could not remove thumbnail %s from cache (%s): %s", cast(Object[])[ url, this.regionName, e.getMessage() ]));
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.ThumbnailCacheDecorator
 * JD-Core Version:    0.7.0.1
 */