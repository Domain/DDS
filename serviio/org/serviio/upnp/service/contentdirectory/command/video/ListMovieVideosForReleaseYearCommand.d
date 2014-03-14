module org.serviio.upnp.service.contentdirectory.command.video.ListMovieVideosForReleaseYearCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.VideoService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.video.AbstractVideosRetrievalCommand;

public class ListMovieVideosForReleaseYearCommand : AbstractVideosRetrievalCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(Video) retrieveEntityList()
    {
        List!(Video) videos = VideoService.getListOfVideosForReleaseYear(Integer.parseInt(getInternalObjectId()), this.accessGroup, this.startIndex, this.count);
        return videos;
    }

    public int retrieveItemCount()
    {
        return VideoService.getNumberOfVideosForReleaseYear(Integer.parseInt(getInternalObjectId()), this.accessGroup);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListMovieVideosForReleaseYearCommand
* JD-Core Version:    0.7.0.1
*/