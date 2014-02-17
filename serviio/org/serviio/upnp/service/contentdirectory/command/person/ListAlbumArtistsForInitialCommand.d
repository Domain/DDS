module org.serviio.upnp.service.contentdirectory.command.person.ListAlbumArtistsForInitialCommand;

import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Person.RoleType;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public class ListAlbumArtistsForInitialCommand
  : AbstractListPersonsForInitialCommand
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.AUDIO, idPrefix, startIndex, count, Person.RoleType.ALBUM_ARTIST, disablePresentationSettings);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.person.ListAlbumArtistsForInitialCommand
 * JD-Core Version:    0.7.0.1
 */