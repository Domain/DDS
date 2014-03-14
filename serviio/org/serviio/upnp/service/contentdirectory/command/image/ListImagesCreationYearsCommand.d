module org.serviio.upnp.service.contentdirectory.command.image.ListImagesCreationYearsCommand;

import java.lang;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.local.service.ImageService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractListYearsCommand;
import org.serviio.upnp.service.contentdirectory.command.CommandExecutionException;
import org.serviio.upnp.service.contentdirectory.command.AbstractListYearsCommand;

public class ListImagesCreationYearsCommand : AbstractListYearsCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.IMAGE, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(Integer) getListOfYears(AccessGroup accessGroup, int startIndex, int count)
    {
        return ImageService.getListOfImagesCreationYears(accessGroup, startIndex, count);
    }

    public int retrieveItemCount()
    {
        return ImageService.getNumberOfImagesCreationYears(this.accessGroup);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.image.ListImagesCreationYearsCommand
* JD-Core Version:    0.7.0.1
*/