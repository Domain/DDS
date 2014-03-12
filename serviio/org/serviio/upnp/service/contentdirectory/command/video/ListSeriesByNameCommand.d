module org.serviio.upnp.service.contentdirectory.command.video.ListSeriesByNameCommand;

import java.lang;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Series;
import org.serviio.library.local.service.VideoService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand;

public class ListSeriesByNameCommand : AbstractEntityContainerCommand!(Series)
{
    public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.VIDEO, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.STORAGE_FOLDER ]));
    }

    override protected List!(Series) retrieveEntityList()
    {
        List!(Series) series = VideoService.getListOfSeries(this.startIndex, this.count);
        return series;
    }

    override protected Series retrieveSingleEntity(Long entityId)
    {
        Series series = VideoService.getSeries(entityId);
        return series;
    }

    override public int retrieveItemCount()
    {
        return VideoService.getNumberOfSeries();
    }

    override protected String getContainerTitle(Series series)
    {
        return series.getTitle();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListSeriesByNameCommand
* JD-Core Version:    0.7.0.1
*/