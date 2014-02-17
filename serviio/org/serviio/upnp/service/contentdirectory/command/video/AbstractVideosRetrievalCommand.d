module org.serviio.upnp.service.contentdirectory.command.video.AbstractVideosRetrievalCommand;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Series;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.VideoService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityItemCommand;

public abstract class AbstractVideosRetrievalCommand
  : AbstractEntityItemCommand!(Video)
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.VIDEO, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected final Set!(ObjectClassType) getSupportedClasses()
  {
    return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.VIDEO_ITEM, ObjectClassType.MOVIE ]));
  }
  
  protected Video retrieveSingleEntity(Long entityId)
  {
    Video video = VideoService.getVideo(entityId);
    return video;
  }
  
  protected String getItemTitle(Video video, bool markedItem)
  {
    if (video.getSeriesId() !is null)
    {
      Series series = VideoService.getSeries(video.getSeriesId());
      return getEpisodeTitle(video, series);
    }
    return getMovieTitle(video);
  }
  
  protected String getEpisodeTitle(Video video, Series series)
  {
    return String.format("%s (%s/%02d): %s", cast(Object[])[ series.getTitle(), video.getSeasonNumber(), video.getEpisodeNumber(), video.getTitle() ]);
  }
  
  protected String getMovieTitle(Video video)
  {
    return video.getTitle();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.AbstractVideosRetrievalCommand
 * JD-Core Version:    0.7.0.1
 */