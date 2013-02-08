module org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForArtistAndAlbumCommand;

import java.lang.String;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Person;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.audio.AbstractSongsForRoleAndAlbumRetrievalCommand;

public class ListSongsForArtistAndAlbumCommand : AbstractSongsForRoleAndAlbumRetrievalCommand
{
	public this(String contextIdentifier, ObjectType objectType, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count)
	{
		super(contextIdentifier, objectType, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, Person.RoleType.ARTIST);
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForArtistAndAlbumCommand
* JD-Core Version:    0.6.2
*/