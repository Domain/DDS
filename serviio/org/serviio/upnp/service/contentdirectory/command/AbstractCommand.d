module org.serviio.upnp.service.contentdirectory.command.AbstractCommand;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.BrowseItemsHolder;
import org.serviio.upnp.service.contentdirectory.ObjectNotFoundException;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.definition.Definition;

public abstract class AbstractCommand(T : DirectoryObject)
  : Command!(T)
{
  protected String objectId;
  protected ObjectClassType containerClassType;
  protected SearchCriteria searchCriteria;
  protected ObjectClassType itemClassType;
  protected int startIndex;
  protected int count;
  protected String idPrefix;
  protected Profile rendererProfile;
  protected ObjectType objectType = ObjectType.ALL;
  protected AccessGroup accessGroup = AccessGroup.ANY;
  protected MediaFileType fileType;
  protected bool disablePresentationSettings;
  
  public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    this.objectId = objectId;
    this.containerClassType = containerClassType;
    this.itemClassType = itemClassType;
    this.startIndex = startIndex;
    this.count = count;
    this.idPrefix = idPrefix;
    this.rendererProfile = rendererProfile;
    this.objectType = objectType;
    this.accessGroup = accessGroup;
    this.fileType = fileType;
    this.searchCriteria = searchCriteria;
    this.disablePresentationSettings = disablePresentationSettings;
  }
  
  public BrowseItemsHolder!(T) retrieveItemList()
  {
    try
    {
      validateSupportedClassTypes();
      List!(T) items = getSupportedObjectTypes().contains(this.objectType) ? retrieveList() : new ArrayList();
      BrowseItemsHolder!(T) holder = new BrowseItemsHolder();
      holder.setItems(items);
      holder.setTotalMatched(getSupportedObjectTypes().contains(this.objectType) ? retrieveItemCount() : 0);
      return holder;
    }
    catch (Exception e)
    {
      throw new CommandExecutionException(String.format("Cannot execute library command for list: %s", cast(Object[])[ e.getMessage() ]), e);
    }
  }
  
  public T retrieveItem()
  {
    try
    {
      validateSupportedClassTypes();
      return retrieveSingleItem();
    }
    catch (Exception e)
    {
      if (( cast(ObjectNotFoundException)e !is null )) {
        throw (cast(ObjectNotFoundException)e);
      }
      throw new CommandExecutionException(String.format("Cannot execute library command for single item: %s", cast(Object[])[ e.getMessage() ]), e);
    }
  }
  
  protected abstract List!(T) retrieveList();
  
  protected abstract T retrieveSingleItem();
  
  protected abstract Set!(ObjectClassType) getSupportedClasses();
  
  protected abstract Set!(ObjectType) getSupportedObjectTypes();
  
  protected String generateRuntimeObjectId(Number entityId)
  {
    return generateRuntimeObjectId(entityId.toString());
  }
  
  protected String generateRuntimeObjectId(String objectIdentifier)
  {
    return NonRecursiveIdGenerator.generateId(this.objectId, this.idPrefix, objectIdentifier);
  }
  
  protected String getInternalObjectId()
  {
    if (this.objectId.indexOf("^") > 1) {
      return this.objectId.substring(this.objectId.lastIndexOf("_") + 1);
    }
    return "0";
  }
  
  protected List!(Resource) getContainerResources(Map!(ClassProperties, Object) entityValues, Long entityId, Profile rendererProfile)
  {
    Resource incompleteThumbnailResource = cast(Resource)entityValues.get(ClassProperties.ICON);
    if (incompleteThumbnailResource !is null)
    {
      Resource thumbnailResource = ResourceValuesBuilder.generateThumbnailResource(entityId, incompleteThumbnailResource.getResourceId(), rendererProfile, true);
      return Collections.singletonList(thumbnailResource);
    }
    return Collections.emptyList();
  }
  
  protected String getInternalObjectId(String objectId)
  {
    if (objectId.indexOf("^") > 1) {
      return objectId.substring(objectId.lastIndexOf("_") + 1);
    }
    return "0";
  }
  
  protected String getDisplayedContainerId(String objectId)
  {
    if (Definition.instance().isOnlyShowContentsOfContainer(objectId, this.disablePresentationSettings)) {
      return Definition.instance().getParentNodeId(objectId, this.disablePresentationSettings);
    }
    return objectId;
  }
  
  private void validateSupportedClassTypes()
  {
    if ((this.containerClassType !is null) && (!getSupportedClasses().contains(this.containerClassType))) {
      throw new CommandExecutionException(String.format("Class %s is not supported by the Command %s", cast(Object[])[ this.containerClassType.toString(), getClass().getName() ]));
    }
    if ((this.itemClassType !is null) && (!getSupportedClasses().contains(this.itemClassType))) {
      throw new CommandExecutionException(String.format("Class %s is not supported by the Command %s", cast(Object[])[ this.itemClassType.toString(), getClass().getName() ]));
    }
  }
  
  public String getContextIdentifier()
  {
    return this.objectId;
  }
  
  public ObjectClassType getContainerClassType()
  {
    return this.containerClassType;
  }
  
  public ObjectClassType getItemClassType()
  {
    return this.itemClassType;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractCommand
 * JD-Core Version:    0.7.0.1
 */