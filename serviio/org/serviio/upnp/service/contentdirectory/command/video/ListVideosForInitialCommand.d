module org.serviio.upnp.service.contentdirectory.command.video.ListVideosForInitialCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Series;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.VideoService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.util.StringUtils;
import org.serviio.upnp.service.contentdirectory.command.video.AbstractVideosRetrievalCommand;

public class ListVideosForInitialCommand : AbstractVideosRetrievalCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(Video) retrieveEntityList()
    {
        List!(Video) videos = VideoService.getListOfVideosForInitial(getInitialFromId(getInternalObjectId()), this.accessGroup, this.startIndex, this.count);
        return videos;
    }

    public int retrieveItemCount()
    {
        return VideoService.getNumberOfVideosForInitial(getInitialFromId(getInternalObjectId()), this.accessGroup);
    }

    private String getInitialFromId(String objectId)
    {
        return StringUtils.getCharacterForCode(Integer.parseInt(objectId));
    }

    override protected String getEpisodeTitle(Video video, Series series)
    {
        return String.format("%s: (%s/%02d) %s", cast(Object[])[ video.getTitle(), video.getSeasonNumber(), video.getEpisodeNumber(), series.getTitle() ]);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListVideosForInitialCommand
* JD-Core Version:    0.7.0.1
*/