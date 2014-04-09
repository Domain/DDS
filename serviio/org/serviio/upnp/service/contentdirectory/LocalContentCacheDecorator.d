module org.serviio.upnp.service.contentdirectory.LocalContentCacheDecorator;

import java.lang.String;
import org.apache.jcs.JCS;
import org.apache.jcs.access.exception.CacheException;
import org.serviio.cache.AbstractCacheDecorator;
import org.serviio.library.entities.AccessGroup;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.CDSCacheDecorator;
import org.serviio.upnp.service.contentdirectory.BrowseItemsHolder;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.slf4j.Logger;

public class LocalContentCacheDecorator : AbstractCacheDecorator, CDSCacheDecorator
{
    public this(String regionName)
    {
        super(regionName);
    }

    public BrowseItemsHolder!(DirectoryObject) retrieve(String objectID, ObjectType objectType, String browseFlag, String filter, int startingIndex, int requestedCount, String sortCriteria, Profile rendererProfile, AccessGroup accessGroup, bool disablePresentationSettings)
    {
        BrowseItemsHolder!(DirectoryObject) object = cast(BrowseItemsHolder)this.cache.get(generateKey(objectID, objectType, browseFlag, filter, startingIndex, requestedCount, sortCriteria, rendererProfile, accessGroup, disablePresentationSettings));
        if (object !is null) {
            this.log.debug_(java.lang.String.format("Found entry in the cache (%s), returning it", cast(Object[])[ this.regionName ]));
        }
        return object;
    }

    public void store(BrowseItemsHolder!(DirectoryObject) object, String objectID, ObjectType objectType, String browseFlag, String filter, int startingIndex, int requestedCount, String sortCriteria, Profile rendererProfile, AccessGroup accessGroup, bool disablePresentationSettings)
    {
        try
        {
            this.cache.put(generateKey(objectID, objectType, browseFlag, filter, startingIndex, requestedCount, sortCriteria, rendererProfile, accessGroup, disablePresentationSettings), object);

            this.log.debug_(java.lang.String.format("Stored entry in the cache (%s), returning it", cast(Object[])[ this.regionName ]));
        }
        catch (CacheException e)
        {
            this.log.warn(java.lang.String.format("Could not store object to local cache(%s): %s", cast(Object[])[ this.regionName, e.getMessage() ]));
        }
    }

    private String generateKey(String containerID, ObjectType objectType, String browseFlag, String filter, int startingIndex, int requestedCount, String sortCriteria, Profile rendererProfile, AccessGroup accessGroup, bool disablePresentationSettings)
    {
        StringBuffer sb = new StringBuffer();
        sb.append(containerID).append(":").append(browseFlag).append(":").append(objectType.toString()).append(":").append(filter).append(":").append(startingIndex).append(":").append(requestedCount).append(":").append(sortCriteria).append(":").append(rendererProfile.getId()).append(":").append(accessGroup.getId() !is null ? accessGroup.getId() : "any").append(":").append(disablePresentationSettings);

        return sb.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.LocalContentCacheDecorator
* JD-Core Version:    0.7.0.1
*/