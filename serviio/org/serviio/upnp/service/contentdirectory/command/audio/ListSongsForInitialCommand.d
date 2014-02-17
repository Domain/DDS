module org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForInitialCommand;

import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.local.service.AudioService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.util.StringUtils;

public class ListSongsForInitialCommand
  : AbstractSongsRetrievalCommand
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected List!(MusicTrack) retrieveEntityList()
  {
    List!(MusicTrack) songs = AudioService.getListOfSongsForInitial(getInitialFromId(getInternalObjectId()), this.accessGroup, this.startIndex, this.count);
    return songs;
  }
  
  public int retrieveItemCount()
  {
    return AudioService.getNumberOfSongsForInitial(getInitialFromId(getInternalObjectId()), this.accessGroup);
  }
  
  private String getInitialFromId(String objectId)
  {
    return StringUtils.getCharacterForCode(Integer.parseInt(objectId));
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForInitialCommand
 * JD-Core Version:    0.7.0.1
 */