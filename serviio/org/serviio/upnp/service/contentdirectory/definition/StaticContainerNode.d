module org.serviio.upnp.service.contentdirectory.definition.StaticContainerNode;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObjectBuilder;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.definition.i18n.BrowsingCategoriesMessages;
import org.serviio.util.ObjectValidator;

public class StaticContainerNode
  : ContainerNode
  , StaticDefinitionNode
{
  private static final Set!(ObjectClassType) supportedClasses = new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.STORAGE_FOLDER ]));
  private String id;
  private String titleKey;
  private bool browsable = true;
  private bool editable = false;
  
  public this(String id, String titleKey, ObjectClassType objectClass, DefinitionNode parent, String cacheRegion)
  {
    super(objectClass, parent, cacheRegion);
    this.id = id;
    this.titleKey = titleKey;
  }
  
  public DirectoryObject retrieveDirectoryObject(String objectId, ObjectType objectType, Profile rendererProfile, AccessGroup userProfile, bool disablePresentationSettings)
  {
    Map!(ClassProperties, Object) values = new HashMap();
    values.put(ClassProperties.ID, getId());
    values.put(ClassProperties.TITLE, getBrowsableTitle(disablePresentationSettings));
    values.put(ClassProperties.CHILD_COUNT, Integer.valueOf(retrieveContainerItemsCount(objectId, objectType, null, userProfile, disablePresentationSettings)));
    values.put(ClassProperties.PARENT_ID, Definition.instance().getParentNodeId(objectId, disablePresentationSettings));
    values.put(ClassProperties.SEARCHABLE, Boolean.FALSE);
    ObjectClassType containerClassType = this.containerClass;
    ContentDirectoryDefinitionFilter definitionFilter = rendererProfile.getContentDirectoryDefinitionFilter();
    if (definitionFilter !is null)
    {
      definitionFilter.filterClassProperties(objectId, values);
      containerClassType = definitionFilter.filterContainerClassType(containerClassType, objectId);
    }
    return DirectoryObjectBuilder.createInstance(containerClassType, values, null, null, disablePresentationSettings);
  }
  
  public void validate()
  {
    super.validate();
    if (ObjectValidator.isEmpty(this.id)) {
      throw new ContentDirectoryDefinitionException("Node ID not provided.");
    }
    if (ObjectValidator.isEmpty(this.titleKey)) {
      throw new ContentDirectoryDefinitionException("Node Title not provided.");
    }
    if (!supportedClasses.contains(this.containerClass)) {
      throw new ContentDirectoryDefinitionException("Unsupported container class.");
    }
    if (ObjectValidator.isEmpty(this.cacheRegion)) {
      throw new ContentDirectoryDefinitionException("Node CacheRegion not provided.");
    }
  }
  
  private String getBrowsableTitle(bool disablePresentationSettings)
  {
    String parentsTitle = Definition.instance().getContentOnlyParentTitles(this.id, disablePresentationSettings);
    if (parentsTitle !is null) {
      return String.format("%s %s", cast(Object[])[ getTitle(), parentsTitle ]);
    }
    return getTitle();
  }
  
  public String getId()
  {
    return this.id;
  }
  
  public void setId(String id)
  {
    this.id = id;
  }
  
  public String getTitle()
  {
    return BrowsingCategoriesMessages.getMessage(this.titleKey, new Object[0]);
  }
  
  public bool isBrowsable()
  {
    return this.browsable;
  }
  
  public void setBrowsable(bool visible)
  {
    this.browsable = visible;
  }
  
  public bool isEditable()
  {
    return this.editable;
  }
  
  public void setEditable(bool editable)
  {
    this.editable = editable;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.StaticContainerNode
 * JD-Core Version:    0.7.0.1
 */