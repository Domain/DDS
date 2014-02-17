module org.serviio.upnp.service.contentdirectory.command.audio.ListAlbumsForArtistNameCommand;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicAlbum;
import org.serviio.library.entities.Person.RoleType;
import org.serviio.library.local.service.AudioService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.util.ObjectValidator;

public class ListAlbumsForArtistNameCommand
  : AbstractAlbumsRetrievalCommand
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected List!(MusicAlbum) retrieveEntityList()
  {
    String artistName = getArtistName();
    if (ObjectValidator.isNotEmpty(artistName))
    {
      List!(MusicAlbum) albums = AudioService.getListOfAlbumsForTrackRole(artistName, Person.RoleType.ARTIST, this.startIndex, this.count);
      return albums;
    }
    return Collections.emptyList();
  }
  
  public int retrieveItemCount()
  {
    String artistName = getArtistName();
    if (ObjectValidator.isNotEmpty(artistName)) {
      return AudioService.getNumberOfAlbumsForTrackRole(artistName, Person.RoleType.ARTIST);
    }
    return 0;
  }
  
  private String getArtistName()
  {
    if ((this.searchCriteria !is null) && ((cast(String)this.searchCriteria.getMap().get(ClassProperties.OBJECT_CLASS)).equalsIgnoreCase(ObjectClassType.MUSIC_ALBUM.getClassName()))) {
      return cast(String)this.searchCriteria.getMap().get(ClassProperties.ARTIST);
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListAlbumsForArtistNameCommand
 * JD-Core Version:    0.7.0.1
 */