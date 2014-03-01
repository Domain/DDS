module org.serviio.library.search.SerieSearchMetadata;

import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.video.ListSeriesByNameCommand;

public class SerieSearchMetadata
  : AbstractSearchMetadata
{
  public this(Long seriesId, String seriesName, Long thumbnailId)
  {
    super(seriesId, MediaFileType.VIDEO, ObjectType.CONTAINERS, SearchCategory.SERIES, seriesName, thumbnailId);
    addCommandMapping(ListSeriesByNameCommand.class_, seriesId);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.SerieSearchMetadata
 * JD-Core Version:    0.7.0.1
 */