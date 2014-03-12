module org.serviio.upnp.service.contentdirectory.command.person.AbstractPersonsRetrievalCommand;

import java.lang;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Person;
import org.serviio.library.local.service.PersonService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand;
import org.serviio.util.StringUtils;

public abstract class AbstractPersonsRetrievalCommand : AbstractEntityContainerCommand!(Person)
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.PERSON, ObjectClassType.MUSIC_ARTIST, ObjectClassType.STORAGE_FOLDER ]));
    }

    override protected Person retrieveSingleEntity(Long entityId)
    {
        Person person = PersonService.getPerson(entityId);
        return person;
    }

    override protected String getContainerTitle(Person person)
    {
        return person.getName();
    }

    protected String getInitialFromId(String objectId)
    {
        return StringUtils.getCharacterForCode(Integer.parseInt(objectId));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.person.AbstractPersonsRetrievalCommand
* JD-Core Version:    0.7.0.1
*/