module org.serviio.upnp.service.contentdirectory.command.person.AbstractListPersonInitialsCommand;

import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.local.service.PersonService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractListInitialsCommand;
import org.serviio.upnp.service.contentdirectory.command.CommandExecutionException;

public abstract class AbstractListPersonInitialsCommand : AbstractListInitialsCommand
{
    protected Person.RoleType roleType;

    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, Person.RoleType roleType, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
        this.roleType = roleType;
    }

    protected List!(String) getListOfInitials(int startIndex, int count)
    {
        return PersonService.getListOfPersonInitials(this.roleType, startIndex, count);
    }

    public int retrieveItemCount()
    {
        return PersonService.getNumberOfPersonInitials(this.roleType);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.person.AbstractListPersonInitialsCommand
* JD-Core Version:    0.7.0.1
*/