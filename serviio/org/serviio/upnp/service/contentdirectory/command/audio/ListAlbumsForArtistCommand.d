module org.serviio.upnp.service.contentdirectory.command.audio.ListAlbumsForArtistCommand;

import java.lang;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicAlbum;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.local.service.AudioService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.audio.AbstractAlbumsRetrievalCommand;

public class ListAlbumsForArtistCommand : AbstractAlbumsRetrievalCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(MusicAlbum) retrieveEntityList()
    {
        List!(MusicAlbum) albums = AudioService.getListOfAlbumsForTrackRole(new Long(getInternalObjectId()), RoleType.ARTIST, this.startIndex, this.count);
        return albums;
    }

    override public int retrieveItemCount()
    {
        return AudioService.getNumberOfAlbumsForTrackRole(new Long(getInternalObjectId()), RoleType.ARTIST);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListAlbumsForArtistCommand
* JD-Core Version:    0.7.0.1
*/