module org.serviio.library.online.OnlineItemService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.CoverImage;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.metadata.MissingPluginException;
import org.serviio.library.online.metadata.NamedOnlineResource;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.library.online.metadata.OnlineResourceContainer;
import org.serviio.library.online.metadata.OnlineResourceParseException;
import org.serviio.library.online.metadata.SingleURLItem;
import org.serviio.library.online.service.OnlineRepositoryService;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.util.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OnlineItemService
{
    private static OnlineLibraryManager onlineLibraryManager = OnlineLibraryManager.getInstance();
    private static final Logger log = LoggerFactory.getLogger!(OnlineItemService);

    public static OnlineResourceContainer/*!(?, ?)*/ findContainerResourceById(Long onlineRepositoryId)
    {
        NamedOnlineResource/*!(OnlineResourceContainer!(?, ?))*/ resource = findNamedContainerResourceById(onlineRepositoryId);
        if (resource !is null) {
            return cast(OnlineResourceContainer)resource.getOnlineItem();
        }
        return null;
    }

    public static NamedOnlineResource/*!(OnlineResourceContainer!(?, ?))*/ findNamedContainerResourceById(Long onlineRepositoryId)
    {
        OnlineRepository onlineRepository = OnlineRepositoryService.getRepository(onlineRepositoryId);
        try
        {
            OnlineResourceContainer/*!(?, ?)*/ resource = findContainerResourceById(onlineRepository);
            if (resource !is null) {
                return new NamedOnlineResource(resource, onlineRepository.getRepositoryName());
            }
            return null;
        }
        catch (OnlineResourceParseException e)
        {
            log.warn(String.format("Unexpected error retrieving resource %s: %s", cast(Object[])[ onlineRepositoryId, e.getMessage() ]));
            return null;
        }
        catch (MissingPluginException e)
        {
            log.warn(String.format("Unexpected error retrieving resource %s: %s", cast(Object[])[ onlineRepositoryId, e.getMessage() ]));
        }
        return null;
    }

    public static SingleURLItem findSingleURLItemById(Long onlineRepositoryId)
    {
        OnlineRepository onlineRepository = OnlineRepositoryService.getRepository(onlineRepositoryId);
        return onlineLibraryManager.findSingleURLItemInCacheOrParse(onlineRepository);
    }

    public static OnlineItem findOnlineItemById(Long onlineItemId)
    {
        NamedOnlineResource!(OnlineItem) namedItem = findNamedOnlineItemById(onlineItemId);
        if (namedItem !is null) {
            return cast(OnlineItem)namedItem.getOnlineItem();
        }
        return null;
    }

    public static NamedOnlineResource!(OnlineItem) findNamedOnlineItemById(Long onlineItemId)
    {
        OnlineItemId itemId = OnlineItemId.parse(onlineItemId);
        OnlineRepository onlineRepository = OnlineRepositoryService.getRepository(Long.valueOf(itemId.getRepositoryId()));
        if (onlineRepository !is null)
        {
            if (getContainerResourceTypes().contains(onlineRepository.getRepoType()))
            {
                OnlineResourceContainer/*!(?, ?)*/ resource = findContainerResourceById(Long.valueOf(itemId.getRepositoryId()));
                if (resource !is null) {
                    try
                    {
                        OnlineItem resourceItem = cast(OnlineItem)resource.getItems().get(itemId.getSequence() - 1);
                        if (resourceItem !is null) {
                            return new NamedOnlineResource(resourceItem, resourceItem.getTitle());
                        }
                        return null;
                    }
                    catch (IndexOutOfBoundsException e)
                    {
                        return null;
                    }
                }
            }
            else
            {
                SingleURLItem item = OnlineLibraryManager.getInstance().findSingleURLItemInCacheOrParse(onlineRepository);
                if (item !is null) {
                    return new NamedOnlineResource(item, onlineRepository.getRepositoryName());
                }
                return null;
            }
        }
        else {
            log.warn("Cannot find online repository with id " + itemId.getRepositoryId());
        }
        return null;
    }

    public static CoverImage findThumbnail(Long onlineItemId)
    {
        OnlineItem onlineItem = findOnlineItemById(onlineItemId);
        if (onlineItem !is null) {
            try
            {
                CoverImage thumbnail = onlineLibraryManager.findThumbnail(onlineItem.getThumbnail(), onlineItem.getUserAgent());
                if (thumbnail !is null)
                {
                    thumbnail.setId(onlineItemId);
                    return thumbnail;
                }
            }
            catch (CannotRetrieveThumbnailException e)
            {
                log.warn(e.getMessage(), e);
                return null;
            }
        }
        return null;
    }

    public static List!(NamedOnlineResource!(OnlineItem)) getListOfFeedItems(OnlineResourceContainer/*!(?, ?)*/ resource, MediaFileType itemType, int start, int count)
    {
        List/*!(? : OnlineItem)*/ resourceItems = filterContainerResourceItems(resource.getItems(), itemType);
        if (resourceItems.size() >= start)
        {
            List/*!(? : OnlineItem)*/ requestedItems = CollectionUtils.getSubList(resourceItems, start, count);
            List!(NamedOnlineResource!(OnlineItem)) result = new ArrayList();
            foreach (OnlineItem item ; requestedItems) {
                result.add(new NamedOnlineResource(item, item.getTitle()));
            }
            return result;
        }
        return Collections.emptyList();
    }

    public static void removeOnlineContentFromCache(String repoUrl, Long onlineRepositoryId)
    {
        OnlineLibraryManager.getInstance().removeOnlineContentFromCache(repoUrl, onlineRepositoryId, true);
    }

    public static List/*!(NamedOnlineResource!(OnlineResourceContainer!(?, ?)))*/ getListOfParsedContainerResources(MediaFileType itemType, AccessGroup accessGroup, int start, int count, bool onlyEnabled)
    {
        List/*!(NamedOnlineResource!(OnlineResourceContainer!(?, ?)))*/ result = getAllParsedContainerResources(itemType, accessGroup, onlyEnabled);
        return CollectionUtils.getSubList(result, start, count);
    }

    public static int getCountOfParsedFeeds(MediaFileType itemType, AccessGroup accessGroup, bool onlyEnabled)
    {
        return getAllParsedContainerResources(itemType, accessGroup, onlyEnabled).size();
    }

    public static int getCountOfOnlineItemsAndRepositories(MediaFileType itemType, ObjectType objectType, Long onlineRepositoryId, AccessGroup accessGroup, bool onlyEnabled)
    {
        if (onlineRepositoryId is null)
        {
            int count = 0;
            if (objectType.supportsContainers()) {
                count += getCountOfParsedFeeds(itemType, accessGroup, onlyEnabled);
            }
            if (objectType.supportsItems()) {
                count += getCountOfSingleURLItems(itemType, accessGroup, onlyEnabled);
            }
            return count;
        }
        if (objectType.supportsItems())
        {
            OnlineResourceContainer/*!(?, ?)*/ resource = findContainerResourceById(onlineRepositoryId);
            return getCountOfContainerItems(resource, itemType);
        }
        return 0;
    }

    public static List!(NamedOnlineResource!(OnlineItem)) getListOfSingleURLItems(MediaFileType itemType, AccessGroup accessGroup, int start, int count, bool onlyEnabled)
    {
        List!(OnlineRepository) repositories = OnlineRepositoryService.getListOfRepositories(getSingleUrlRepositoryTypes(), itemType, accessGroup, onlyEnabled);
        List!(NamedOnlineResource!(OnlineItem)) onlineItems = new ArrayList();
        foreach (OnlineRepository repo ; repositories)
        {
            SingleURLItem item = onlineLibraryManager.findSingleURLItemInCacheOrParse(repo);
            if (item !is null)
            {
                SingleURLItem filteredItem = cast(SingleURLItem)filterFeedItem(item, itemType);
                if (filteredItem !is null) {
                    onlineItems.add(new NamedOnlineResource(filteredItem, repo.getRepositoryName()));
                }
            }
        }
        if (onlineItems.size() >= start)
        {
            List!(NamedOnlineResource!(OnlineItem)) requestedItems = CollectionUtils.getSubList(onlineItems, start, count);
            return requestedItems;
        }
        return Collections.emptyList();
    }

    public static int getCountOfSingleURLItems(MediaFileType itemType, AccessGroup accessGroup, bool onlyEnabled)
    {
        List!(OnlineRepository) repositories = OnlineRepositoryService.getListOfRepositories(getSingleUrlRepositoryTypes(), itemType, accessGroup, onlyEnabled);
        List!(SingleURLItem) onlineItems = convertOnlineRepositories(repositories);
        return filterContainerResourceItems(onlineItems, itemType).size();
    }

    private static int getCountOfContainerItems(OnlineResourceContainer/*!(?, ?)*/ resource, MediaFileType itemType)
    {
        List/*!(?)*/ items = filterContainerResourceItems(resource.getItems(), itemType);
        return items.size();
    }

    private static List/*!(NamedOnlineResource!(OnlineResourceContainer!(?, ?)))*/ getAllParsedContainerResources(MediaFileType itemType, AccessGroup accessGroup, bool onlyEnabled)
    {
        List!(OnlineRepository) allRepositories = OnlineRepositoryService.getListOfRepositories(getContainerResourceTypes(), itemType, accessGroup, onlyEnabled);
        List/*!(NamedOnlineResource!(OnlineResourceContainer!(?, ?)))*/ result = new ArrayList();
        foreach (OnlineRepository repo ; allRepositories) {
            try
            {
                OnlineResourceContainer/*!(?, ?)*/ parsedResource = onlineLibraryManager.findResource(repo, true);
                if (parsedResource !is null) {
                    result.add(new NamedOnlineResource(parsedResource, repo.getRepositoryName()));
                }
            }
            catch (MissingPluginException e) {}catch (OnlineResourceParseException e) {}
        }
        return result;
    }

    private static OnlineResourceContainer/*!(?, ?)*/ findContainerResourceById(OnlineRepository onlineRepository)
    {
        if (onlineRepository !is null) {
            return onlineLibraryManager.findResource(onlineRepository, true);
        }
        return null;
    }

    private static /*!(T : OnlineItem)*/ List/*!(T)*/ filterContainerResourceItems(List!(T) items, MediaFileType type)
    {
        List!(T) filteredItems = new ArrayList();
        foreach (T feedItem ; items)
        {
            T filteredItem = filterFeedItem(feedItem, type);
            if (filteredItem !is null) {
                filteredItems.add(filteredItem);
            }
        }
        return filteredItems;
    }

    private static /*!(T : OnlineItem)*/ T filterFeedItem(T)(T item, MediaFileType type)
    {
        if ((item.getType() == type) && (item.isCompletelyLoaded())) {
            return item;
        }
        return null;
    }

    private static List!(SingleURLItem) convertOnlineRepositories(List!(OnlineRepository) repositories)
    {
        List!(SingleURLItem) onlineItems = new ArrayList();
        foreach (OnlineRepository repo ; repositories)
        {
            SingleURLItem item = onlineLibraryManager.findSingleURLItemInCacheOrParse(repo);
            if (item !is null) {
                onlineItems.add(item);
            }
        }
        return onlineItems;
    }

    private static List!(OnlineRepositoryType) getSingleUrlRepositoryTypes()
    {
        return Collections.singletonList(OnlineRepositoryType.LIVE_STREAM);
    }

    private static List!(OnlineRepositoryType) getContainerResourceTypes()
    {
        return Arrays.asList(cast(OnlineRepositoryType[])[ OnlineRepositoryType.FEED, OnlineRepositoryType.WEB_RESOURCE ]);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.OnlineItemService
* JD-Core Version:    0.7.0.1
*/