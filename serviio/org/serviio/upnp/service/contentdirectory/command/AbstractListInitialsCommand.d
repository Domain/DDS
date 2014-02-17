module org.serviio.upnp.service.contentdirectory.command.AbstractListInitialsCommand;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.Container;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObjectBuilder;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.util.StringUtils;

public abstract class AbstractListInitialsCommand
  : AbstractCommand!(Container)
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected abstract List!(String) getListOfInitials(int paramInt1, int paramInt2);
  
  public static String getInitialId(String letter)
  {
    return String.valueOf(StringUtils.getUnicodeCode(letter));
  }
  
  protected Set!(ObjectClassType) getSupportedClasses()
  {
    return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.STORAGE_FOLDER ]));
  }
  
  protected Set!(ObjectType) getSupportedObjectTypes()
  {
    return ObjectType.getContainerTypes();
  }
  
  protected List!(Container) retrieveList()
  {
    List!(Container) items = new ArrayList();
    
    List!(String) letters = getListOfInitials(this.startIndex, this.count);
    foreach (String letter ; letters)
    {
      String runtimeId = generateRuntimeObjectId(getInitialId(letter));
      Map!(ClassProperties, Object) values = ObjectValuesBuilder.instantiateValuesForContainer(letter, runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, this.accessGroup, null, this.disablePresentationSettings);
      items.add(cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, null, this.disablePresentationSettings));
    }
    return items;
  }
  
  protected Container retrieveSingleItem()
  {
    String title = StringUtils.getCharacterForCode(Integer.valueOf(getInternalObjectId()).intValue());
    Map!(ClassProperties, Object) values = ObjectValuesBuilder.instantiateValuesForContainer(title, this.objectId, Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings), this.objectType, this.searchCriteria, this.accessGroup, null, this.disablePresentationSettings);
    
    return cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, null, this.disablePresentationSettings);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractListInitialsCommand
 * JD-Core Version:    0.7.0.1
 */