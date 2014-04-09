module org.serviio.library.online.WebResourceParser;

import java.lang;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.config.Configuration;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.metadata.MissingPluginException;
import org.serviio.library.online.metadata.OnlineResourceParseException;
import org.serviio.library.online.metadata.WebResourceFeed;
import org.serviio.library.online.metadata.WebResourceFeedItem;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.serviio.library.online.AbstractOnlineItemParser;
import org.serviio.library.online.WebResourceItem;
import org.serviio.library.online.WebResourceUrlExtractor;
import org.serviio.library.online.WebResourceContainer;
import org.slf4j.Logger;

public class WebResourceParser : AbstractOnlineItemParser
{
    private static Map!(String, Set!(CachedItem)) parsedItemsCache;

    static this()
    {
        parsedItemsCache = Collections.synchronizedMap(new HashMap());
    }

    public WebResourceFeed parse(URL resourceUrl, Long onlineRepositoryId, MediaFileType fileType)
    {
        this.log.debug_(java.lang.String.format("Parsing web resource '%s'", cast(Object[])[ resourceUrl ]));
        WebResourceFeed resource = new WebResourceFeed(onlineRepositoryId);

        WebResourceUrlExtractor suitablePlugin = cast(WebResourceUrlExtractor)findSuitableExtractorPlugin(resourceUrl, OnlineRepositoryType.WEB_RESOURCE);
        if (suitablePlugin !is null)
        {
            WebResourceContainer container = null;
            try
            {
                container = suitablePlugin.parseWebResource(resourceUrl, Configuration.getMaxNumberOfItemsForOnlineFeeds().intValue());
            }
            catch (Throwable e)
            {
                throw new OnlineResourceParseException(java.lang.String.format("Unexpected error while invoking plugin (%s): %s", cast(Object[])[ suitablePlugin.getExtractorName(), e.getMessage() ]), e);
            }
            if (container !is null)
            {
                resource.setTitle(StringUtils.trim(container.getTitle()));
                resource.setDomain(resourceUrl.getHost());
                resource.setUsedExtractor(suitablePlugin);
                setContainerThumbnail(resource, container);
                if (container.getItems() !is null)
                {
                    int itemOrder = 1;
                    for (int i = 0; (i < container.getItems().size()) && (this.isAlive); i++)
                    {
                        bool added = addResourceItem(resourceUrl, resource, fileType, cast(WebResourceItem)container.getItems().get(i), itemOrder, suitablePlugin);
                        if (added) {
                            itemOrder++;
                        }
                    }
                }
            }
            else
            {
                throw new OnlineResourceParseException(java.lang.String.format("Plugin %s returned null container", cast(Object[])[ suitablePlugin.getExtractorName() ]));
            }
        }
        else
        {
            throw new MissingPluginException(java.lang.String.format("No plugin for web resource %s has been found.", cast(Object[])[ resourceUrl.toString() ]));
        }
        return resource;
    }

    public synchronized void cleanItemCache(String resourceUrl)
    {
        this.log.debug_(java.lang.String.format("Removing all items from parsed items' cache for resource: %s", cast(Object[])[ resourceUrl ]));
        parsedItemsCache.remove(resourceUrl);
    }

    public synchronized void cleanItemCache(URL resourceUrl, WebResourceFeedItem item)
    {
        Set!(CachedItem) cItems = cast(Set)parsedItemsCache.get(resourceUrl.toString());
        if (cItems !is null)
        {
            Iterator!(CachedItem) it = cItems.iterator();
            while (it.hasNext())
            {
                CachedItem cItem = cast(CachedItem)it.next();
                if (cItem.cacheKey.opEquals(item.getParsedItemCacheKey()))
                {
                    this.log.debug_(java.lang.String.format("Removing item with key '%s' from parsedItemsCache cache for resource: %s", cast(Object[])[ item.getCacheKey(), resourceUrl.toString() ]));
                    it.remove();
                    break;
                }
            }
        }
    }

    private bool addResourceItem(URL resourceUrl, WebResourceFeed resource, MediaFileType fileType, WebResourceItem item, int order, WebResourceUrlExtractor suitablePlugin)
    {
        WebResourceFeedItem resourceItem = findInCache(resourceUrl, item.getCacheKey());
        if (resourceItem !is null)
        {
            this.log.debug_(java.lang.String.format("Item with key '%s' already found in the cache, skipping URL extraction", cast(Object[])[ item.getCacheKey() ]));
            if (resourceItem.getOrder() != order) {
                resourceItem.setOrder(order);
            }
            if (!resourceItem.isValidEssence())
            {
                this.log.debug_(java.lang.String.format("The cached item '%s' had its essence marked as invalid, setting it back to default to re-try essence validation", cast(Object[])[ resourceItem.getCacheKey() ]));
                resourceItem.setValidEssence(true);
            }
            resource.getItems().add(resourceItem);
            this.log.debug_(java.lang.String.format("Added cached resource item %s: '%s' (%s)", cast(Object[])[ Integer.valueOf(order), resourceItem.getTitle(), resourceItem.getContentUrl() ]));
            return true;
        }
        resourceItem = new WebResourceFeedItem(resource, order);
        try
        {
            try
            {
                extractContentUrlViaPlugin(resourceUrl, suitablePlugin, resourceItem, item);
            }
            catch (Throwable e)
            {
                this.log.debug_(java.lang.String.format("Unexpected error during url extractor plugin invocation (%s) for item %s: %s", cast(Object[])[ suitablePlugin.getExtractorName(), resourceItem.getTitle(), e.getMessage() ]), e);

                return false;
            }
            resourceItem.setDate(item.getReleaseDate());
            resourceItem.setTitle(StringUtils.trim(item.getTitle()));
            if (fileType == resourceItem.getType())
            {
                resourceItem.fillInUnknownEntries();
                resourceItem.validateMetadata();
                if (ObjectValidator.isNotEmpty(item.getCacheKey()))
                {
                    resourceItem.setParsedItemCacheKey(item.getCacheKey());
                    storeInCache(resourceUrl, resourceItem);
                    this.log.debug_(java.lang.String.format("Stored item with key '%s' to cache", cast(Object[])[ item.getCacheKey() ]));
                }
                this.log.debug_(java.lang.String.format("Added resource item %s: '%s' (%s)", cast(Object[])[ Integer.valueOf(order), resourceItem.getTitle(), resourceItem.getContentUrl() ]));
                resource.getItems().add(resourceItem);
                return true;
            }
            this.log.debug_(java.lang.String.format("Skipping web resource item '%s' because it's not of type %s", cast(Object[])[ resourceItem.getTitle(), fileType ]));
            return false;
        }
        catch (InvalidMetadataException e)
        {
            this.log.debug_(java.lang.String.format("Cannot add item of web resource %s because of invalid metadata. Message: %s", cast(Object[])[ resource.getTitle(), e.getMessage() ]));
        }
        return false;
    }

    private void extractContentUrlViaPlugin(URL resourceUrl, WebResourceUrlExtractor urlExtractor, WebResourceFeedItem resourceItem, WebResourceItem extractedItem)
    {
        ContentURLContainer extractedUrl = urlExtractor.extractItemUrl(extractedItem);
        if (extractedUrl !is null)
        {
            resourceItem.applyContentUrlContainer(extractedUrl, urlExtractor);
            resourceItem.getAdditionalInfo().putAll(extractedItem.getAdditionalInfo());
        }
        else
        {
            this.log.warn(java.lang.String.format("Plugin %s returned no value for resource item '%s'", cast(Object[])[ urlExtractor.getExtractorName(), resourceItem.getTitle() ]));
        }
    }

    private void setContainerThumbnail(WebResourceFeed resource, WebResourceContainer container)
    {
        if ((container !is null) && (ObjectValidator.isNotEmpty(container.getThumbnailUrl()))) {
            try
            {
                ImageDescriptor thumbnail = new ImageDescriptor(new URL(container.getThumbnailUrl()));
                resource.setThumbnail(thumbnail);
            }
            catch (MalformedURLException e)
            {
                this.log.warn(java.lang.String.format("Malformed url of a web resource thumbnail (%s), skipping this thumbnail", cast(Object[])[ container.getThumbnailUrl() ]));
            }
        }
    }

    protected static synchronized WebResourceFeedItem findInCache(URL resourceUrl, String cacheKey)
    {
        if (cacheKey !is null)
        {
            Set!(CachedItem) feedItems = cast(Set)parsedItemsCache.get(resourceUrl.toString());
            if (feedItems !is null) {
                foreach (CachedItem cItem ; feedItems) {
                    if (cItem.cacheKey.opEquals(cacheKey)) {
                        return cItem.item;
                    }
                }
            }
        }
        return null;
    }

    protected static synchronized void storeInCache(URL resourceUrl, WebResourceFeedItem item)
    {
        String feedKey = resourceUrl.toString();
        if (!parsedItemsCache.containsKey(feedKey)) {
            parsedItemsCache.put(feedKey, new HashSet());
        }
        (cast(Set)parsedItemsCache.get(feedKey)).add(new CachedItem(item.getParsedItemCacheKey(), item));
    }

    private static class CachedItem
    {
        immutable String cacheKey;
        WebResourceFeedItem item;

        public this(String cacheKey, WebResourceFeedItem item)
        {
            this.cacheKey = cacheKey;
            this.item = item;
        }

        public override hash_t toHash()
        {
            int prime = 31;
            int result = 1;
            result = 31 * result + (this.cacheKey is null ? 0 : this.cacheKey.hashCode());
            return result;
        }

        public override equals_t opEquals(Object obj)
        {
            if (this == obj) {
                return true;
            }
            if (obj is null) {
                return false;
            }
            if (getClass() != obj.getClass()) {
                return false;
            }
            CachedItem other = cast(CachedItem)obj;
            if (this.cacheKey is null)
            {
                if (other.cacheKey !is null) {
                    return false;
                }
            }
            else if (!this.cacheKey.opEquals(other.cacheKey)) {
                return false;
            }
            return true;
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.WebResourceParser
* JD-Core Version:    0.7.0.1
*/