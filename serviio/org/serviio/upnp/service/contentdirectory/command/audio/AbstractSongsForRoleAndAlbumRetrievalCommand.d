module org.serviio.upnp.service.contentdirectory.command.audio.AbstractSongsForRoleAndAlbumRetrievalCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.local.service.AudioService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.upnp.service.contentdirectory.command.audio.AbstractSongsRetrievalCommand;

public abstract class AbstractSongsForRoleAndAlbumRetrievalCommand : AbstractSongsRetrievalCommand
{
    private RoleType roleType;

    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, RoleType roleType, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
        this.roleType = roleType;
    }

    override protected List!(MusicTrack) retrieveEntityList()
    {
        Long artistId = Long.valueOf(Long.parseLong(getInternalObjectId(Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings))));
        Long albumId = Long.valueOf(Long.parseLong(getInternalObjectId()));
        List!(MusicTrack) songs = AudioService.getListOfSongsForTrackRoleAndAlbum(artistId, this.roleType, albumId, this.accessGroup, this.startIndex, this.count);
        return songs;
    }

    public int retrieveItemCount()
    {
        Long artistId = Long.valueOf(Long.parseLong(getInternalObjectId(Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings))));
        Long albumId = Long.valueOf(Long.parseLong(getInternalObjectId()));
        return AudioService.getNumberOfSongsForTrackRoleAndAlbum(artistId, this.roleType, albumId, this.accessGroup);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.AbstractSongsForRoleAndAlbumRetrievalCommand
* JD-Core Version:    0.7.0.1
*/