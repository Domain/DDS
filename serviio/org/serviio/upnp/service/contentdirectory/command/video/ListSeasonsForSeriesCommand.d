module org.serviio.upnp.service.contentdirectory.command.video.ListSeasonsForSeriesCommand;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.local.service.VideoService;
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
import org.serviio.upnp.service.contentdirectory.definition.i18n.BrowsingCategoriesMessages;

public class ListSeasonsForSeriesCommand
  : AbstractCommand!(Container)
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.VIDEO, idPrefix, startIndex, count, disablePresentationSettings);
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
    
    List!(Integer) seasons = VideoService.getListOfSeasonsForSeries(new Long(getInternalObjectId()), this.accessGroup, this.startIndex, this.count);
    
    Integer lastViewedSeason = getLastViewedSeason(new Long(getInternalObjectId()));
    foreach (Integer seasonNumber ; seasons)
    {
      String runtimeId = generateRuntimeObjectId(seasonNumber);
      String containerTitle = getContainerTitle(seasonNumber, lastViewedSeason);
      Map!(ClassProperties, Object) values = ObjectValuesBuilder.instantiateValuesForContainer(containerTitle, runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, this.accessGroup, null, this.disablePresentationSettings);
      
      items.add(cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, null, this.disablePresentationSettings));
    }
    return items;
  }
  
  protected Container retrieveSingleItem()
  {
    Long seriesId = Long.valueOf(Long.parseLong(getInternalObjectId(Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings))));
    Integer seasonNumber = new Integer(getInternalObjectId());
    
    Integer lastViewedSeason = getLastViewedSeason(seriesId);
    
    String containerTitle = getContainerTitle(seasonNumber, lastViewedSeason);
    Map!(ClassProperties, Object) values = ObjectValuesBuilder.instantiateValuesForContainer(containerTitle, this.objectId, Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings), this.objectType, this.searchCriteria, this.accessGroup, null, this.disablePresentationSettings);
    
    return cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, null, this.disablePresentationSettings);
  }
  
  private String getContainerTitle(Integer seasonNumber, Integer lastViewedSeason)
  {
    String containerTitle = String.format("%s %02d%s", cast(Object[])[ BrowsingCategoriesMessages.getMessage("season", new Object[0]), seasonNumber, (lastViewedSeason !is null) && (lastViewedSeason.equals(seasonNumber)) ? " **" : "" ]);
    return containerTitle;
  }
  
  public int retrieveItemCount()
  {
    return VideoService.getNumberOfSeasonsForSeries(new Long(getInternalObjectId()), this.accessGroup);
  }
  
  protected Integer getLastViewedSeason(Long seriesId)
  {
    Map!(Long, Integer) lastViewed = VideoService.getLastViewedEpisode(seriesId);
    if (lastViewed !is null) {
      return (Integer)(cast(Map.Entry)lastViewed.entrySet().iterator().next()).getValue();
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListSeasonsForSeriesCommand
 * JD-Core Version:    0.7.0.1
 */