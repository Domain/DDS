module org.serviio.upnp.service.contentdirectory.command.image.ListImagePlaylistsCommand;

import org.serviio.library.entities.AccessGroup;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractListPlaylistsCommand;

public class ListImagePlaylistsCommand
  : AbstractListPlaylistsCommand
{
  public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.IMAGE, idPrefix, startIndex, count, disablePresentationSettings);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.image.ListImagePlaylistsCommand
 * JD-Core Version:    0.7.0.1
 */