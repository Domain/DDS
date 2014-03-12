module org.serviio.upnp.service.contentdirectory.command.audio.AbstractSongsRetrievalCommand;

import java.lang;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.local.service.AudioService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityItemCommand;

public abstract class AbstractSongsRetrievalCommand : AbstractEntityItemCommand!(MusicTrack)
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.AUDIO, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected final Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.AUDIO_ITEM, ObjectClassType.MUSIC_TRACK ]));
    }

    override protected MusicTrack retrieveSingleEntity(Long entityId)
    {
        MusicTrack song = AudioService.getSong(entityId);
        return song;
    }

    override protected String getItemTitle(MusicTrack track, bool markItem)
    {
        return track.getTitle();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.AbstractSongsRetrievalCommand
* JD-Core Version:    0.7.0.1
*/