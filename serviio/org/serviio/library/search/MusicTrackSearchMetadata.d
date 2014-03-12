module org.serviio.library.search.MusicTrackSearchMetadata;

import java.lang;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.audio.ListAllAlbumsCommand;
import org.serviio.upnp.service.contentdirectory.command.audio.ListSongsForAlbumCommand;
import org.serviio.library.search.AbstractSearchMetadata;

public class MusicTrackSearchMetadata : AbstractSearchMetadata
{
    public this(Long mediaItemId, Long albumId, String songTitle, String albumName, String albumArtist, Long thumbnailId)
    {
        super(mediaItemId, MediaFileType.AUDIO, ObjectType.ITEMS, SearchCategory.MUSIC_TRACKS, songTitle, thumbnailId);
        addCommandMapping(ListAllAlbumsCommand.class_, albumId);
        addCommandMapping(ListSongsForAlbumCommand.class_, mediaItemId);
        addToContext(albumArtist);
        addToContext(albumName);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.MusicTrackSearchMetadata
* JD-Core Version:    0.7.0.1
*/