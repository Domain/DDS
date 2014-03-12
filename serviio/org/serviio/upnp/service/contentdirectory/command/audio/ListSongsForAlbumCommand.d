module org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForAlbumCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.local.service.AudioService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.audio.AbstractSongsRetrievalCommand;

public class ListSongsForAlbumCommand : AbstractSongsRetrievalCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(MusicTrack) retrieveEntityList()
    {
        List!(MusicTrack) songs = AudioService.getListOfSongsForAlbum(new Long(getInternalObjectId()), this.accessGroup, this.startIndex, this.count);
        return songs;
    }

    public int retrieveItemCount()
    {
        return AudioService.getNumberOfSongsForAlbum(new Long(getInternalObjectId()), this.accessGroup);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForAlbumCommand
* JD-Core Version:    0.7.0.1
*/