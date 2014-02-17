module org.serviio.upnp.service.contentdirectory.command.image.ListImagesCreationMonthsCommand;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.local.service.ImageService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.Container;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObjectBuilder;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractCommand;
import org.serviio.upnp.service.contentdirectory.command.CommandExecutionException;
import org.serviio.upnp.service.contentdirectory.command.ObjectValuesBuilder;
import org.serviio.upnp.service.contentdirectory.definition.Definition;

public class ListImagesCreationMonthsCommand
  : AbstractCommand!(Container)
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.IMAGE, idPrefix, startIndex, count, disablePresentationSettings);
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
    Integer year = Integer.valueOf(Integer.parseInt(getInternalObjectId()));
    
    List!(Integer) months = ImageService.getListOfImagesCreationMonths(year, this.accessGroup, this.startIndex, this.count);
    foreach (Integer month ; months)
    {
      String runtimeId = generateRuntimeObjectId(month);
      Map!(ClassProperties, Object) values = ObjectValuesBuilder.instantiateValuesForContainer(month.toString(), runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, this.accessGroup, null, this.disablePresentationSettings);
      
      items.add(cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, null, this.disablePresentationSettings));
    }
    return items;
  }
  
  protected Container retrieveSingleItem()
  {
    Map!(ClassProperties, Object) values = ObjectValuesBuilder.instantiateValuesForContainer(getInternalObjectId(), this.objectId, Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings), this.objectType, this.searchCriteria, this.accessGroup, null, this.disablePresentationSettings);
    

    return cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, null, this.disablePresentationSettings);
  }
  
  public int retrieveItemCount()
  {
    Integer year = Integer.valueOf(Integer.parseInt(getInternalObjectId()));
    return ImageService.getNumberOfImagesCreationMonths(year, this.accessGroup);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.image.ListImagesCreationMonthsCommand
 * JD-Core Version:    0.7.0.1
 */