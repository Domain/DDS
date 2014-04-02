module org.serviio.library.playlist.PlaylistStrategyFactory;

import java.lang.String;
import org.serviio.library.playlist.PlaylistParserStrategy;

public class PlaylistStrategyFactory
{
    private static PlaylistParserStrategy[] strategies;

    static this()
    {
        strategies = [ new M3UParserStrategy(), new PlsParserStrategy(), new AsxParserStrategy(), new WplParserStrategy() ];
    }

    public static PlaylistParserStrategy getStrategy(byte[] playlistBytes, String playlistLocation)
    {
        foreach (PlaylistParserStrategy strategy ; strategies) {
            if (strategy.matches(playlistBytes, playlistLocation)) {
                return strategy;
            }
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.playlist.PlaylistStrategyFactory
* JD-Core Version:    0.7.0.1
*/