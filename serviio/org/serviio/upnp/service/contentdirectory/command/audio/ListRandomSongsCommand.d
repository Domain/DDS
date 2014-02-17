module org.serviio.upnp.service.contentdirectory.command.audio.ListRandomSongsCommand;

import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.local.service.AudioService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public class ListRandomSongsCommand
  : AbstractSongsRetrievalCommand
{
  private static final int NUMBER_OF_RANDOM_SONGS = 100;
  
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected List!(MusicTrack) retrieveEntityList()
  {
    List!(MusicTrack) songs = AudioService.getListOfRandomSongs(100, this.accessGroup, this.startIndex, this.count);
    return songs;
  }
  
  public int retrieveItemCount()
  {
    return AudioService.getNumberOfRandomSongs(100, this.accessGroup);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListRandomSongsCommand
 * JD-Core Version:    0.7.0.1
 */