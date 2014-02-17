module org.serviio.library.search.AlbumArtistSearchMetadata;

import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.AbstractListInitialsCommand;
import org.serviio.upnp.service.contentdirectory.command.person.ListAlbumArtistInitialsCommand;
import org.serviio.upnp.service.contentdirectory.command.person.ListAlbumArtistsForInitialCommand;

public class AlbumArtistSearchMetadata
  : AbstractSearchMetadata
{
  public this(Long personId, String artistName, String nameInitial, Long thumbnailId)
  {
    super(personId, MediaFileType.AUDIO, ObjectType.CONTAINERS, SearchIndexer.SearchCategory.ALBUM_ARTISTS, artistName, thumbnailId);
    addCommandMapping(ListAlbumArtistInitialsCommand.class_, AbstractListInitialsCommand.getInitialId(nameInitial));
    addCommandMapping(ListAlbumArtistsForInitialCommand.class_, personId);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.AlbumArtistSearchMetadata
 * JD-Core Version:    0.7.0.1
 */