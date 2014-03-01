module org.serviio.library.local.H264LevelType;

import std.conv;

import java.lang.String;
import java.util.Map;
import org.serviio.library.local.EnumMapConverter;

public enum H264LevelType
{
    H,  RF
}

private static EnumMapConverter!(H264LevelType) converter = new EnumMapConverter!(H264LevelType)();

public Map!(H264LevelType, String) parseFromString(String identifiersCSV)
{
    return converter.convert(identifiersCSV);
}

public String parseToString(Map!(H264LevelType, String) identifiers)
{
    return converter.parseToString(identifiers);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.H264LevelType
* JD-Core Version:    0.7.0.1
*/