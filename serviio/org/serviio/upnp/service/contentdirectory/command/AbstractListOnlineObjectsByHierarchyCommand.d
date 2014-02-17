module org.serviio.upnp.service.contentdirectory.command.AbstractListOnlineObjectsByHierarchyCommand;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.OnlineItemService;
import org.serviio.library.online.metadata.NamedOnlineResource;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.library.online.metadata.OnlineResourceContainer;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectNotFoundException;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObjectBuilder;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.definition.Definition;

public abstract class AbstractListOnlineObjectsByHierarchyCommand
  : AbstractCommand!(DirectoryObject)
{
  public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected Set!(ObjectClassType) getSupportedClasses()
  {
    return new HashSet(Arrays.asList(ObjectClassType.values()));
  }
  
  protected Set!(ObjectType) getSupportedObjectTypes()
  {
    return ObjectType.getAllTypes();
  }
  
  protected List!(DirectoryObject) retrieveList()
  {
    List!(DirectoryObject) objects = new ArrayList();
    Long folderId = getFolderId();
    int returnedFoldersCount = 0;
    int existingFoldersCount = 0;
    if (this.objectType.supportsContainers())
    {
      existingFoldersCount = folderId is null ? OnlineItemService.getCountOfParsedFeeds(this.fileType, this.accessGroup, true) : 0;
      if (this.startIndex < existingFoldersCount)
      {
        List/*!(NamedOnlineResource!(OnlineResourceContainer!(?, ?)*/)) resources = OnlineItemService.getListOfParsedContainerResources(this.fileType, this.accessGroup, this.startIndex, this.count, true);
        foreach (NamedOnlineResource/*!(OnlineResourceContainer!(?, ?)*/) folder ; resources)
        {
          OnlineResourceContainer/*!(?, ?)*/ resource = cast(OnlineResourceContainer)folder.getOnlineItem();
          String runtimeId = generateFolderObjectId(resource.getOnlineRepositoryId());
          Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(resource.toOnlineRepository(), runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, resource.getDisplayName(folder.getRepositoryName()), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);
          
          objects.add(DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, resource.getOnlineRepositoryId(), this.disablePresentationSettings));
        }
        returnedFoldersCount = resources.size();
      }
    }
    if ((this.count > returnedFoldersCount) && (this.objectType.supportsItems()))
    {
      int itemStartIndex = this.startIndex - existingFoldersCount + returnedFoldersCount;
      List!(NamedOnlineResource!(OnlineItem)) items = getItemsForMediaType(folderId, itemStartIndex, this.count - returnedFoldersCount);
      foreach (NamedOnlineResource!(OnlineItem) namedItem ; items)
      {
        OnlineItem item = cast(OnlineItem)namedItem.getOnlineItem();
        String runtimeId = generateItemObjectId(item.getId());
        MediaItem mediaItem = item.toMediaItem();
        Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(mediaItem, runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, item.getDisplayTitle(namedItem.getRepositoryName()), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);
        
        List!(Resource) res = ResourceValuesBuilder.buildResources(mediaItem, this.rendererProfile);
        objects.add(DirectoryObjectBuilder.createInstance(this.itemClassType, values, res, item.getId(), this.disablePresentationSettings));
      }
    }
    return objects;
  }
  
  protected DirectoryObject retrieveSingleItem()
  {
    Long itemId = getMediaItemId();
    if (itemId !is null)
    {
      NamedOnlineResource!(OnlineItem) namedItem = getItem(itemId);
      if (namedItem !is null)
      {
        OnlineItem item = cast(OnlineItem)namedItem.getOnlineItem();
        MediaItem mediaItem = item.toMediaItem();
        Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(mediaItem, this.objectId, OnlineRecursiveIdGenerator.getRecursiveParentId(this.objectId), this.objectType, this.searchCriteria, item.getDisplayTitle(namedItem.getRepositoryName()), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);
        
        List!(Resource) res = ResourceValuesBuilder.buildResources(mediaItem, this.rendererProfile);
        return DirectoryObjectBuilder.createInstance(this.itemClassType, values, res, itemId, this.disablePresentationSettings);
      }
      throw new ObjectNotFoundException(String.format("OnlineItem with id %s not found in CDS", cast(Object[])[ itemId ]));
    }
    Long folderId = getFolderId();
    if (folderId !is null)
    {
      NamedOnlineResource/*!(OnlineResourceContainer!(?, ?)*/) resource = OnlineItemService.findNamedContainerResourceById(folderId);
      if (resource !is null)
      {
        OnlineResourceContainer/*!(?, ?)*/ feed = cast(OnlineResourceContainer)resource.getOnlineItem();
        Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(feed.toOnlineRepository(), this.objectId, Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings), this.objectType, this.searchCriteria, feed.getDisplayName(resource.getRepositoryName()), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);
        

        return DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, folderId, this.disablePresentationSettings);
      }
      throw new ObjectNotFoundException(String.format("Folder with id %s not found in CDS", cast(Object[])[ folderId ]));
    }
    throw new ObjectNotFoundException(String.format("Error retrieving object %s from CDS", cast(Object[])[ this.objectId ]));
  }
  
  public int retrieveItemCount()
  {
    return OnlineItemService.getCountOfOnlineItemsAndRepositories(this.fileType, this.objectType, getFolderId(), this.accessGroup, true);
  }
  
  private String generateFolderObjectId(Number entityId)
  {
    return OnlineRecursiveIdGenerator.generateFolderObjectId(entityId, this.objectId, this.idPrefix);
  }
  
  private String generateItemObjectId(Number entityId)
  {
    if (this.objectId.indexOf("^") == -1) {
      return NonRecursiveIdGenerator.generateId(this.objectId, this.idPrefix, "$OI" + entityId.toString());
    }
    return OnlineRecursiveIdGenerator.generateItemObjectId(entityId, this.objectId, this.idPrefix);
  }
  
  private Long getFolderId()
  {
    if (this.objectId.indexOf("FD") > -1)
    {
      String strippedId = this.objectId.substring(this.objectId.indexOf("FD"));
      if (strippedId.indexOf("$") > -1) {
        strippedId = strippedId.substring(0, strippedId.indexOf("$"));
      }
      return Long.valueOf(Long.parseLong(strippedId.substring("FD".length())));
    }
    return null;
  }
  
  private Long getMediaItemId()
  {
    String itemPrefix = "$OI";
    if (this.objectId.indexOf(itemPrefix) > -1)
    {
      String strippedId = this.objectId.substring(this.objectId.lastIndexOf(itemPrefix));
      return Long.valueOf(Long.parseLong(strippedId.substring(itemPrefix.length())));
    }
    return null;
  }
  
  private List!(NamedOnlineResource!(OnlineItem)) getItemsForMediaType(Long folderId, int startIndex, int count)
  {
    if (folderId is null) {
      return OnlineItemService.getListOfSingleURLItems(this.fileType, this.accessGroup, startIndex, count, true);
    }
    OnlineResourceContainer/*!(?, ?)*/ cachedContainerResource = OnlineItemService.findContainerResourceById(folderId);
    return OnlineItemService.getListOfFeedItems(cachedContainerResource, this.fileType, startIndex, count);
  }
  
  private NamedOnlineResource!(OnlineItem) getItem(Long itemId)
  {
    return OnlineItemService.findNamedOnlineItemById(itemId);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractListOnlineObjectsByHierarchyCommand
 * JD-Core Version:    0.7.0.1
 */