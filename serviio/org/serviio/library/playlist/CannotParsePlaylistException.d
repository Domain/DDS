module org.serviio.library.playlist.CannotParsePlaylistException;

import java.lang.String;
import org.serviio.library.playlist.PlaylistType;

public class CannotParsePlaylistException : Exception
{
    private static immutable long serialVersionUID = 6421703004477221786L;
    private PlaylistType type;
    private String playlistLocation;

    public this(PlaylistType type, String playlistLocation, String message)
    {
        super(message);
        this.type = type;
        this.playlistLocation = playlistLocation;
    }

    public String getMessage()
    {
        return String.format("Cannot parse playlist (%s) '%s' because: %s", cast(Object[])[ this.type.toString(), this.playlistLocation, super.getMessage() ]);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.playlist.CannotParsePlaylistException
* JD-Core Version:    0.7.0.1
*/