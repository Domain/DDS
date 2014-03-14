module org.serviio.upnp.service.contentdirectory.command.person.ListArtistsByNameCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Person;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.local.service.PersonService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.person.AbstractPersonsRetrievalCommand;

public class ListArtistsByNameCommand : AbstractPersonsRetrievalCommand
{
    public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.AUDIO, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(Person) retrieveEntityList()
    {
        List!(Person) artists = PersonService.getListOfPersons(RoleType.ARTIST, this.startIndex, this.count);
        return artists;
    }

    override public int retrieveItemCount()
    {
        return PersonService.getNumberOfPersons(RoleType.ARTIST);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.person.ListArtistsByNameCommand
* JD-Core Version:    0.7.0.1
*/