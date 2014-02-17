module org.serviio.library.search.MovieSearchMetadata;

import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.video.ListMovieVideosByNameCommand;

public class MovieSearchMetadata
  : AbstractSearchMetadata
{
  public this(Long mediaItemId, String movieTitle, Long thumbnailId)
  {
    super(mediaItemId, MediaFileType.VIDEO, ObjectType.ITEMS, SearchIndexer.SearchCategory.MOVIES, movieTitle, thumbnailId);
    addCommandMapping(ListMovieVideosByNameCommand.class_, mediaItemId);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.MovieSearchMetadata
 * JD-Core Version:    0.7.0.1
 */