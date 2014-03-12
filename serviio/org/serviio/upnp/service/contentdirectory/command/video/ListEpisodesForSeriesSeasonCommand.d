module org.serviio.upnp.service.contentdirectory.command.video.ListEpisodesForSeriesSeasonCommand;

import java.lang;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map:Entry;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.VideoService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.upnp.service.contentdirectory.command.video.AbstractVideosRetrievalCommand;

public class ListEpisodesForSeriesSeasonCommand : AbstractVideosRetrievalCommand
{
    public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(Video) retrieveEntityList()
    {
        List!(Video) videos = VideoService.getListOfEpisodesForSeriesSeason(getSeriesId(), getSeason(), this.accessGroup, this.startIndex, this.count);
        return videos;
    }

    public int retrieveItemCount()
    {
        return VideoService.getNumberOfEpisodesForSeriesSeason(getSeriesId(), getSeason(), this.accessGroup);
    }

    override protected String getItemTitle(Video video, bool markedItem)
    {
        return String.format("%02d. %s%s", cast(Object[])[ video.getEpisodeNumber(), markedItem ? "** " : "", video.getTitle() ]);
    }

    override protected Long findMarkedItemId(bool forSingleItem)
    {
        Long seriesId = null;
        if (forSingleItem) {
            seriesId = Long.valueOf(Long.parseLong(getInternalObjectId(Definition.instance().getParentNodeId(Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings), this.disablePresentationSettings))));
        } else {
            seriesId = getSeriesId();
        }
        return getLastViewedEpisode(seriesId);
    }

    private Long getSeriesId()
    {
        Long seasonId = Long.valueOf(Long.parseLong(getInternalObjectId(Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings))));
        return seasonId;
    }

    private Integer getSeason()
    {
        Integer season = Integer.valueOf(Integer.parseInt(getInternalObjectId()));
        return season;
    }

    protected Long getLastViewedEpisode(Long seriesId)
    {
        Map!(Long, Integer) lastViewed = VideoService.getLastViewedEpisode(seriesId);
        if (lastViewed !is null) {
            return cast(Long)(cast(Map.Entry)lastViewed.entrySet().iterator().next()).getKey();
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListEpisodesForSeriesSeasonCommand
* JD-Core Version:    0.7.0.1
*/