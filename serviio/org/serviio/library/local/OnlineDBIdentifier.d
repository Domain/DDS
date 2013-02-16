module org.serviio.library.local.OnlineDBIdentifier;

import java.lang.String;
import java.util.Map;
import org.serviio.library.local.EnumMapConverter;

public class OnlineDBIdentifier
{
    enum OnlineDBIdentifierEnum
    {
        IMDB, TVDB, TMDB
    }

    OnlineDBIdentifierEnum onlineDBIdentifier;
    alias onlineDBIdentifier this;

    private static EnumMapConverter!(OnlineDBIdentifier) converter = new class() EnumMapConverter!(OnlineDBIdentifier)
    {
        override protected OnlineDBIdentifier enumValue(String name) {
            return OnlineDBIdentifier.valueOf(name);
        }
    };

    public static OnlineDBIdentifier valueOf(String name)
    {
        OnlineDBIdentifier id = new OnlineDBIdentifier();
        switch (name)
        {
            case "IMDB":
                id.onlineDBIdentifier = OnlineDBIdentifier.IMDB;
                break;

            case "TVDB":
                id.onlineDBIdentifier = OnlineDBIdentifier.TVDB;
                break;

            case "TMDB":
                id.onlineDBIdentifier = OnlineDBIdentifier.TMDB;
                break;
        }
        return id;
    }

    public static Map!(OnlineDBIdentifier, String) parseFromString(String identifiersCSV)
    {
        return converter.convert(identifiersCSV);
    }

    public static String parseToString(Map!(OnlineDBIdentifier, String) identifiers) {
        return converter.parseToString(identifiers);
    }
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.library.local.OnlineDBIdentifier
* JD-Core Version:    0.6.2
*/