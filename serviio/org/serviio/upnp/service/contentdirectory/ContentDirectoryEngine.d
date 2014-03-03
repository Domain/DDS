module org.serviio.upnp.service.contentdirectory.ContentDirectoryEngine;

import java.lang.String;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Map:Entry;
import org.serviio.library.entities.AccessGroup;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.definition.ContainerNode;
import org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionFilter;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.upnp.service.contentdirectory.CDSCacheDecorator;
import org.serviio.upnp.service.contentdirectory.BrowseItemsHolder;
import org.serviio.upnp.service.contentdirectory.ObjectType;

public class ContentDirectoryEngine
{
    private static immutable String CACHE_REGION_LOCAL_DEFAULT = "local_default";
    private static immutable String CACHE_REGION_LOCAL_RESET_AFTER_PLAY = "local_resetafterplay";
    private static immutable String CACHE_REGION_NO_CACHE = "no_cache";
    private static immutable String BROWSE_FLAG_BrowseMetadata = "BrowseMetadata";
    private static immutable String BROWSE_FLAG_BrowseDirectChildren = "BrowseDirectChildren";
    private static ContentDirectoryEngine instance;
    private Map!(String, CDSCacheDecorator) cacheRegions;

    private this()
    {
        setupCache();
    }

    public static ContentDirectoryEngine getInstance()
    {
        if (instance is null) {
            instance = new ContentDirectoryEngine();
        }
        return instance;
    }

    public BrowseItemsHolder!(DirectoryObject) browse(String objectID, ObjectType objectType, String browseFlag, String filter, int startingIndex, int requestedCount, String sortCriteria, Profile rendererProfile, AccessGroup accessGroup, bool disablePresentationSettings)
    {
        if ((!browseFlag.equals("BrowseMetadata")) && (!browseFlag.equals("BrowseDirectChildren"))) {
            throw new InvalidBrowseFlagException(String.format("Unsupported browse flag: %s", cast(Object[])[ browseFlag ]));
        }
        if (rendererProfile.getContentDirectoryDefinitionFilter() !is null) {
            objectID = rendererProfile.getContentDirectoryDefinitionFilter().filterObjectId(objectID, false);
        }
        ContainerNode container = Definition.instance().getContainer(objectID);
        if (container is null) {
            throw new ObjectNotFoundException();
        }
        BrowseItemsHolder!(DirectoryObject) itemsHolder = getCacheRegion(container.getCacheRegion()).retrieve(objectID, objectType, browseFlag, filter, startingIndex, requestedCount, sortCriteria, rendererProfile, accessGroup, disablePresentationSettings);
        if (itemsHolder is null)
        {
            bool storeInCache = true;

            itemsHolder = new BrowseItemsHolder();
            if (browseFlag.equals("BrowseDirectChildren"))
            {
                itemsHolder = container.retrieveContainerItems(objectID, objectType, null, startingIndex, requestedCount, rendererProfile, accessGroup, disablePresentationSettings);
            }
            else
            {
                DirectoryObject object = container.retrieveDirectoryObject(objectID, objectType, rendererProfile, accessGroup, disablePresentationSettings);
                if (object !is null)
                {
                    itemsHolder.setTotalMatched(1);
                    itemsHolder.setItems(Collections.singletonList(object));
                }
                else
                {
                    storeInCache = false;
                }
            }
            if (storeInCache) {
                getCacheRegion(container.getCacheRegion()).store(itemsHolder, objectID, objectType, browseFlag, filter, startingIndex, requestedCount, sortCriteria, rendererProfile, accessGroup, disablePresentationSettings);
            }
        }
        return itemsHolder;
    }

    public void evictItemsAfterPlay()
    {
        (cast(CDSCacheDecorator)this.cacheRegions.get("local_resetafterplay")).evictAll();
    }

    void clearAllCacheRegions()
    {
        foreach (Map.Entry!(String, CDSCacheDecorator) entry ; this.cacheRegions.entrySet()) {
            (cast(CDSCacheDecorator)entry.getValue()).evictAll();
        }
    }

    private void setupCache()
    {
        this.cacheRegions = new HashMap();
        this.cacheRegions.put("local_default", new LocalContentCacheDecorator("local_default"));
        this.cacheRegions.put("local_resetafterplay", new LocalContentCacheDecorator("local_resetafterplay"));
        this.cacheRegions.put("no_cache", new NoCacheDecorator());
    }

    private CDSCacheDecorator getCacheRegion(String regionName)
    {
        return cast(CDSCacheDecorator)this.cacheRegions.get(regionName);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.ContentDirectoryEngine
* JD-Core Version:    0.7.0.1
*/