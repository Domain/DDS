module org.serviio.upnp.service.contentdirectory.command.video.ListVideoRatingsByNameCommand;

import java.lang.String;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.local.metadata.MPAARating;
import org.serviio.library.local.service.VideoService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.Container;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObjectBuilder;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractCommand;
import org.serviio.upnp.service.contentdirectory.command.CommandExecutionException;
import org.serviio.upnp.service.contentdirectory.command.ObjectValuesBuilder;
import org.serviio.upnp.service.contentdirectory.definition.Definition;

public class ListVideoRatingsByNameCommand : AbstractCommand!(Container)
{
    public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.VIDEO, idPrefix, startIndex, count, disablePresentationSettings);
    }

    public static MPAARating getRatingFromId(String id)
    {
        return MPAARating.values()[Integer.parseInt(id)];
    }

    override protected Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.STORAGE_FOLDER ]));
    }

    override protected Set!(ObjectType) getSupportedObjectTypes()
    {
        return ObjectType.getContainerTypes();
    }

    override protected List!(Container) retrieveList()
    {
        List!(Container) items = new ArrayList();

        List!(MPAARating) ratings = VideoService.getListOfRatings(this.accessGroup, this.startIndex, this.count);
        foreach (MPAARating rating ; ratings)
        {
            String runtimeId = generateRuntimeObjectId(Integer.valueOf(rating.ordinal()));
            Map!(ClassProperties, Object) values = ObjectValuesBuilder.instantiateValuesForContainer(rating.toString(), runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, this.accessGroup, null, this.disablePresentationSettings);
            items.add(cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, null, this.disablePresentationSettings));
        }
        return items;
    }

    override protected Container retrieveSingleItem()
    {
        Map!(ClassProperties, Object) values = ObjectValuesBuilder.instantiateValuesForContainer(MPAARating.values()[Integer.parseInt(getInternalObjectId())].toString(), this.objectId, Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings), this.objectType, this.searchCriteria, this.accessGroup, null, this.disablePresentationSettings);

        return cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, null, null, this.disablePresentationSettings);
    }

    public int retrieveItemCount()
    {
        return VideoService.getNumberOfRatings(this.accessGroup);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListVideoRatingsByNameCommand
* JD-Core Version:    0.7.0.1
*/