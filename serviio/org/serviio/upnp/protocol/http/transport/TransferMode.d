module org.serviio.upnp.protocol.http.transport.TransferMode;

import java.lang.String;

enum TransferMode : String
{
    INTERACTIVE = "Interactive",
    BACKGROUND = "Background",
    STREAMING = "Streaming",
}

public String httpHeaderValue(TransferMode transferMode)
{
    return cast(String)transferMode;
}

public TransferMode getValueByHttpHeaderValue(String value)
{
    if (value.equalsIgnoreCase("Interactive"))
        return INTERACTIVE;
    if (value.equalsIgnoreCase("Background"))
        return BACKGROUND;
    if (value.equalsIgnoreCase("Streaming")) {
        return STREAMING;
    }
    throw new IllegalArgumentException("Unsupported Transfer mode: " ~ value);
}

//public class TransferMode
//{
//    enum TransferModeEnum : String
//    {
//        INTERACTIVE = "Interactive",
//        BACKGROUND = "Background",
//        STREAMING = "Streaming",
//    }
//
//    TransferModeEnum transferMode;
//    alias transferMode this;
//
//    public String httpHeaderValue()
//    {
//        return cast(String)transferMode;
//    }
//
//    public static TransferMode getValueByHttpHeaderValue(String value)
//    {
//        if (value.equalsIgnoreCase("Interactive"))
//            return INTERACTIVE;
//        if (value.equalsIgnoreCase("Background"))
//            return BACKGROUND;
//        if (value.equalsIgnoreCase("Streaming")) {
//            return STREAMING;
//        }
//        throw new IllegalArgumentException("Unsupported Transfer mode: " ~ value);
//    }
//}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.http.transport.TransferMode
* JD-Core Version:    0.6.2
*/