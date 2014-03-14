module org.serviio.upnp.service.contentdirectory.command.audio.ListSongInitialsCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.local.service.AudioService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractListInitialsCommand;
import org.serviio.upnp.service.contentdirectory.command.CommandExecutionException;

public class ListSongInitialsCommand : AbstractListInitialsCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.AUDIO, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(String) getListOfInitials(int startIndex, int count)
    {
        return AudioService.getListOfSongInitials(this.accessGroup, startIndex, count);
    }

    public int retrieveItemCount()
    {
        return AudioService.getNumberOfSongInitials(this.accessGroup);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListSongInitialsCommand
* JD-Core Version:    0.7.0.1
*/