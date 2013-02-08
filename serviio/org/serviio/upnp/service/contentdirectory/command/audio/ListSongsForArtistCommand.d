module org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForArtistCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.local.service.AudioService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.audio.AbstractSongsRetrievalCommand;

public class ListSongsForArtistCommand : AbstractSongsRetrievalCommand
{
	public this(String contextIdentifier, ObjectType objectType, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count)
	{
		super(contextIdentifier, objectType, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count);
	}

	override protected List!(MusicTrack) retrieveEntityList()
	{
		List!(MusicTrack) songs = AudioService.getListOfSongsForArtist(new Long(getInternalObjectId()), accessGroup, startIndex, count);
		return songs;
	}

	public int retrieveItemCount()
	{
		return AudioService.getNumberOfSongsForArtist(new Long(getInternalObjectId()), accessGroup);
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForArtistCommand
* JD-Core Version:    0.6.2
*/