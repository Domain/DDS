module org.serviio.upnp.service.contentdirectory.command.video.ListVideosForProducerCommand;

import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.VideoService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public class ListVideosForProducerCommand
  : AbstractVideosRetrievalCommand
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected List!(Video) retrieveEntityList()
  {
    List!(Video) videos = VideoService.getListOfVideosForPerson(new Long(getInternalObjectId()), Person.RoleType.PRODUCER, this.accessGroup, this.startIndex, this.count);
    return videos;
  }
  
  public int retrieveItemCount()
  {
    return VideoService.getNumberOfVideosForPerson(new Long(getInternalObjectId()), Person.RoleType.PRODUCER, this.accessGroup);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListVideosForProducerCommand
 * JD-Core Version:    0.7.0.1
 */