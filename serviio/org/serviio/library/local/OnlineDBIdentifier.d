module org.serviio.library.local.OnlineDBIdentifier;

import java.lang.String;
import java.util.Map;
import org.serviio.library.local.EnumMapConverter;

public enum OnlineDBIdentifier
{
    IMDB,  TVDB,  TMDB
}

private static EnumMapConverter!(OnlineDBIdentifier) converter;

static this()
{
    converter = EnumMapConverter!(OnlineDBIdentifier)();
}

public Map!(OnlineDBIdentifier, String) parseFromString(String identifiersCSV)
{
    return converter.convert(identifiersCSV);
}

public String parseToString(Map!(OnlineDBIdentifier, String) identifiers)
{
    return converter.parseToString(identifiers);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.OnlineDBIdentifier
* JD-Core Version:    0.7.0.1
*/