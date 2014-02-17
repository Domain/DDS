module org.serviio.upnp.service.contentdirectory.command.AbstractListPlaylistsCommand;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Playlist;
import org.serviio.library.local.service.PlaylistService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public abstract class AbstractListPlaylistsCommand
  : AbstractEntityContainerCommand!(Playlist)
{
  public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected Set!(ObjectClassType) getSupportedClasses()
  {
    return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.STORAGE_FOLDER, ObjectClassType.PLAYLIST_CONTAINER ]));
  }
  
  protected List!(Playlist) retrieveEntityList()
  {
    List!(Playlist) playlists = PlaylistService.getListOfPlaylistsWithMedia(this.fileType, this.accessGroup, this.startIndex, this.count);
    return playlists;
  }
  
  protected Playlist retrieveSingleEntity(Long entityId)
  {
    Playlist playlist = PlaylistService.getPlaylist(entityId);
    return playlist;
  }
  
  public int retrieveItemCount()
  {
    return PlaylistService.getNumberOfPlaylistsWithMedia(this.fileType, this.accessGroup);
  }
  
  protected String getContainerTitle(Playlist playlist)
  {
    return playlist.getTitle();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractListPlaylistsCommand
 * JD-Core Version:    0.7.0.1
 */