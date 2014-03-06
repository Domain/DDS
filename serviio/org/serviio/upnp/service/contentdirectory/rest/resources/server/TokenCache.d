module org.serviio.upnp.service.contentdirectory.rest.resources.server.TokenCache;

import java.lang.String;
import org.apache.jcs.JCS;
import org.apache.jcs.access.exception.CacheException;
import org.serviio.cache.AbstractCacheDecorator;
import org.slf4j.Logger;

public class TokenCache : AbstractCacheDecorator
{
    public this(String regionName)
    {
        super(regionName);
    }

    public String retrieveToken(String token)
    {
        return cast(String)this.cache.get(token);
    }

    public void storeToken(String token)
    {
        try
        {
            this.cache.put(token, token);
        }
        catch (CacheException e)
        {
            this.log.warn(String.format("Could not store token to local cache(%s): %s", cast(Object[])[ this.regionName, e.getMessage() ]));
        }
    }

    public void evictToken(String token)
    {
        try
        {
            this.cache.remove(token);
        }
        catch (CacheException e)
        {
            this.log.debug_(String.format("Could not evict token from local cache(%s): %s", cast(Object[])[ this.regionName, e.getMessage() ]));
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.TokenCache
* JD-Core Version:    0.7.0.1
*/