module org.serviio.library.local.H264LevelType;

import java.lang.String;
import java.util.Map;
import org.serviio.library.local.EnumMapConverter;

enum H264LevelType
{
    H, RF
}

private static EnumMapConverter!(H264LevelType) converter;

public static this()
{
    converter = new class() EnumMapConverter!(H264LevelType)
    {
        override protected H264LevelType enumValue(String name) {
            return H264LevelType.valueOf(name);
        }
    };
}

public H264LevelType valueOf(String name)
{
    H264LevelType type = new H264LevelType();
    if (name == "H")
        type.h264LevelType = H264LevelType.H;
    else
        type.h264LevelType = H264LevelType.RF;
    return type;
}

public H264LevelType valueOf(H264LevelType e)
{
    H264LevelType type = new H264LevelType();
    type.h264LevelType = e;
    return type;
}

public Map!(H264LevelType, String) parseFromString(String identifiersCSV)
{
    return converter.convert(identifiersCSV);
}

public String parseToString(Map!(H264LevelType, String) identifiers) {
    return converter.parseToString(identifiers);
}

//public class H264LevelType
//{
//    enum H264LevelTypeEnum
//    {
//        H, RF
//    }
//
//    H264LevelTypeEnum h264LevelType;
//    alias h264LevelType this;
//
//    private static EnumMapConverter!(H264LevelType) converter;
//
//    public static this()
//    {
//        converter = new class() EnumMapConverter!(H264LevelType)
//        {
//            override protected H264LevelType enumValue(String name) {
//                return H264LevelType.valueOf(name);
//            }
//        };
//    }
//
//    public static H264LevelType valueOf(String name)
//    {
//        H264LevelType type = new H264LevelType();
//        if (name == "H")
//            type.h264LevelType = H264LevelType.H;
//        else
//            type.h264LevelType = H264LevelType.RF;
//        return type;
//    }
//
//    public static H264LevelType valueOf(H264LevelTypeEnum e)
//    {
//        H264LevelType type = new H264LevelType();
//        type.h264LevelType = e;
//        return type;
//    }
//
//    public static Map!(H264LevelType, String) parseFromString(String identifiersCSV)
//    {
//        return converter.convert(identifiersCSV);
//    }
//
//    public static String parseToString(Map!(H264LevelType, String) identifiers) {
//        return converter.parseToString(identifiers);
//    }
//}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.library.local.H264LevelType
* JD-Core Version:    0.6.2
*/