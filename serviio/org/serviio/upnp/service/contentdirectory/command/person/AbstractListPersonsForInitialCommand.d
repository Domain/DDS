module org.serviio.upnp.service.contentdirectory.command.person.AbstractListPersonsForInitialCommand;

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

public abstract class AbstractListPersonsForInitialCommand : AbstractPersonsRetrievalCommand
{
    private RoleType roleType;

    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, RoleType roleType, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
        this.roleType = roleType;
    }

    protected List!(Person) retrieveEntityList()
    {
        List!(Person) persons = PersonService.getListOfPersonsForInitial(getInitialFromId(getInternalObjectId()), this.roleType, this.startIndex, this.count);

        return persons;
    }

    public int retrieveItemCount()
    {
        return PersonService.getNumberOfPersonsForInitial(getInitialFromId(getInternalObjectId()), this.roleType);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.person.AbstractListPersonsForInitialCommand
* JD-Core Version:    0.7.0.1
*/