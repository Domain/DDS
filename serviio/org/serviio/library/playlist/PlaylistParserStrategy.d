module org.serviio.library.playlist.PlaylistParserStrategy;

import java.lang.String;
import org.serviio.library.playlist.ParsedPlaylist;

public abstract interface PlaylistParserStrategy
{
    public abstract ParsedPlaylist parsePlaylist(byte[] paramArrayOfByte, String paramString);

    public abstract bool matches(byte[] paramArrayOfByte, String paramString);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.playlist.PlaylistParserStrategy
* JD-Core Version:    0.7.0.1
*/