module org.serviio.upnp.service.contentdirectory.command.image.ListImagesForCreationMonthAndYearCommand;

import java.lang;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Image;
import org.serviio.library.local.service.ImageService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.upnp.service.contentdirectory.command.image.AbstractImagesRetrievalCommand;

public class ListImagesForCreationMonthAndYearCommand : AbstractImagesRetrievalCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(Image) retrieveEntityList()
    {
        List!(Image) images = ImageService.getListOfImagesForMonthAndYear(getMonth(), getYear(), this.accessGroup, this.startIndex, this.count);
        return images;
    }

    public int retrieveItemCount()
    {
        return ImageService.getNumberOfImagesForMonthAndYear(getMonth(), getYear(), this.accessGroup);
    }

    private Integer getYear()
    {
        Integer year = Integer.valueOf(Integer.parseInt(getInternalObjectId(Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings))));
        return year;
    }

    private Integer getMonth()
    {
        Integer month = Integer.valueOf(Integer.parseInt(getInternalObjectId()));
        return month;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.image.ListImagesForCreationMonthAndYearCommand
* JD-Core Version:    0.7.0.1
*/