module org.serviio.library.playlist.PlaylistParser;

import java.lang.String;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import org.serviio.util.FileUtils;
import org.serviio.util.HttpClient;
import org.serviio.util.HttpUtils;
import org.serviio.library.playlist.ParsedPlaylist;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PlaylistParser
{
    private static Logger log;
    private static immutable int ONLINE_MAX_BYTES_TO_READ = 102400;
    private static PlaylistParser instance;

    static this()
    {
        log = LoggerFactory.getLogger!(PlaylistParser);
    }

    public static PlaylistParser getInstance()
    {
        if (instance is null) {
            instance = new PlaylistParser();
        }
        return instance;
    }

    public ParsedPlaylist parse(String playlistLocation)
    {
        log.debug_(java.lang.String.format("Parsing playlist '%s'", cast(Object[])[ playlistLocation ]));
        byte[] playlistBytes = getPlaylistBytes(playlistLocation);
        PlaylistParserStrategy strategy = PlaylistStrategyFactory.getStrategy(playlistBytes, playlistLocation);
        if (strategy !is null)
        {
            log.debug_(java.lang.String.format("Found a suitable playlist parser strategy: %s", cast(Object[])[ strategy.getClass().getSimpleName() ]));
            return strategy.parsePlaylist(playlistBytes, playlistLocation);
        }
        log.warn(java.lang.String.format("Could not find a suitable playlist parser for file '%s', it is either not supported or the file is corrupted.", cast(Object[])[ playlistLocation ]));

        return null;
    }

    private byte[] getPlaylistBytes(String playlistLocation)
    {
        InputStream ins = null;
        int maxLengthToRead = 2147483647;
        if (HttpUtils.isHttpUrl(playlistLocation))
        {
            log.debug_("Reading playlist from URL");
            ins = HttpClient.getStreamFromURL(playlistLocation);
            maxLengthToRead = ONLINE_MAX_BYTES_TO_READ;
        }
        else
        {
            log.debug_("Reading playlist from a local file");
            ins = new FileInputStream(playlistLocation);
        }
        return FileUtils.readFileBytes(ins, maxLengthToRead);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.playlist.PlaylistParser
* JD-Core Version:    0.7.0.1
*/