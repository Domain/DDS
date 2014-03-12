module org.serviio.upnp.service.contentdirectory.command.AbstractListPlaylistsCommand;

import java.lang;
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
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand;

public abstract class AbstractListPlaylistsCommand : AbstractEntityContainerCommand!(Playlist)
{
    public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.STORAGE_FOLDER, ObjectClassType.PLAYLIST_CONTAINER ]));
    }

    override protected List!(Playlist) retrieveEntityList()
    {
        List!(Playlist) playlists = PlaylistService.getListOfPlaylistsWithMedia(this.fileType, this.accessGroup, this.startIndex, this.count);
        return playlists;
    }

    override protected Playlist retrieveSingleEntity(Long entityId)
    {
        Playlist playlist = PlaylistService.getPlaylist(entityId);
        return playlist;
    }

    override public int retrieveItemCount()
    {
        return PlaylistService.getNumberOfPlaylistsWithMedia(this.fileType, this.accessGroup);
    }

    override protected String getContainerTitle(Playlist playlist)
    {
        return playlist.getTitle();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractListPlaylistsCommand
* JD-Core Version:    0.7.0.1
*/