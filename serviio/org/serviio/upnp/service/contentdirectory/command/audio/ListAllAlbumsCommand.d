module org.serviio.upnp.service.contentdirectory.command.audio.ListAllAlbumsCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicAlbum;
import org.serviio.library.local.service.AudioService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.audio.AbstractAlbumsRetrievalCommand;

public class ListAllAlbumsCommand : AbstractAlbumsRetrievalCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(MusicAlbum) retrieveEntityList()
    {
        List!(MusicAlbum) albums = AudioService.getListOfAllAlbums(this.startIndex, this.count);
        return albums;
    }

    override public int retrieveItemCount()
    {
        return AudioService.getNumberOfAllAlbums();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListAllAlbumsCommand
* JD-Core Version:    0.7.0.1
*/