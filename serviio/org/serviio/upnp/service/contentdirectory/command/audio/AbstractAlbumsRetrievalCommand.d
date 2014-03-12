module org.serviio.upnp.service.contentdirectory.command.audio.AbstractAlbumsRetrievalCommand;

import java.lang;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicAlbum;
import org.serviio.library.local.service.AudioService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand;

public abstract class AbstractAlbumsRetrievalCommand : AbstractEntityContainerCommand!(MusicAlbum)
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.AUDIO, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.MUSIC_ALBUM ]));
    }

    override protected MusicAlbum retrieveSingleEntity(Long entityId)
    {
        MusicAlbum album = AudioService.getMusicAlbum(entityId);
        return album;
    }

    override protected String getContainerTitle(MusicAlbum album)
    {
        return album.getTitle();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.AbstractAlbumsRetrievalCommand
* JD-Core Version:    0.7.0.1
*/