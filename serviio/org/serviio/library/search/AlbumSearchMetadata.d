module org.serviio.library.search.AlbumSearchMetadata;

import java.lang;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.audio.ListAllAlbumsCommand;
import org.serviio.library.search.AbstractSearchMetadata;

public class AlbumSearchMetadata : AbstractSearchMetadata
{
    public this(Long albumId, String albumName, String albumArtist, Long albumArtId)
    {
        super(albumId, MediaFileType.AUDIO, ObjectType.CONTAINERS, SearchCategory.ALBUMS, albumName, albumArtId);
        addCommandMapping(ListAllAlbumsCommand.class_, albumId);
        addToContext(albumArtist);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.AlbumSearchMetadata
* JD-Core Version:    0.7.0.1
*/