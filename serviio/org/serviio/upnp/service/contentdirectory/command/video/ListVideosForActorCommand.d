module org.serviio.upnp.service.contentdirectory.command.video.ListVideosForActorCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Person;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.VideoService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.video.AbstractVideosRetrievalCommand;

public class ListVideosForActorCommand : AbstractVideosRetrievalCommand
{
    public this(String contextIdentifier, ObjectType objectType, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count)
    {
        super(contextIdentifier, objectType, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count);
    }

    override protected List!(Video) retrieveEntityList()
    {
        List!(Video) videos = VideoService.getListOfVideosForPerson(new Long(getInternalObjectId()), Person.RoleType.ACTOR, accessGroup, startIndex, count);
        return videos;
    }

    public int retrieveItemCount()
    {
        return VideoService.getNumberOfVideosForPerson(new Long(getInternalObjectId()), Person.RoleType.ACTOR, accessGroup);
    }
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListVideosForActorCommand
* JD-Core Version:    0.6.2
*/