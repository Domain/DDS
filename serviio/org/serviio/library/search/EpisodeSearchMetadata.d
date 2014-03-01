module org.serviio.library.search.EpisodeSearchMetadata;

import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.video.ListEpisodesForSeriesSeasonCommand;
import org.serviio.upnp.service.contentdirectory.command.video.ListSeasonsForSeriesCommand;
import org.serviio.upnp.service.contentdirectory.command.video.ListSeriesByNameCommand;
import org.serviio.upnp.service.contentdirectory.definition.i18n.BrowsingCategoriesMessages;

public class EpisodeSearchMetadata
  : AbstractSearchMetadata
{
  public this(Long mediaItemId, Integer season, Long seriesId, String episodeTitle, Long thumbnailId, String seriesName)
  {
    super(mediaItemId, MediaFileType.VIDEO, ObjectType.ITEMS, SearchCategory.EPISODES, episodeTitle, thumbnailId);
    addCommandMapping(ListSeriesByNameCommand.class_, seriesId);
    addCommandMapping(ListSeasonsForSeriesCommand.class_, season);
    addCommandMapping(ListEpisodesForSeriesSeasonCommand.class_, mediaItemId);
    
    addToContext(seriesName);
    addToContext(String.format("%s %s", cast(Object[])[ BrowsingCategoriesMessages.getMessage("season", new Object[0]), season ]));
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.EpisodeSearchMetadata
 * JD-Core Version:    0.7.0.1
 */