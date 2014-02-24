module org.serviio.upnp.protocol.http.transport.TransferMode;

public enum TransferMode
{
    INTERACTIVE,  BACKGROUND,  STREAMING
}

public String httpHeaderValue(TransferMode mode)
{
    switch (mode)
    {
        case INTERACTIVE: 
            return "Interactive";
        case BACKGROUND: 
            return "Background";
        case STREAMING: 
            return "Streaming";
    }
    return null;
}

public TransferMode getValueByHttpHeaderValue(String value)
{
    if (value.equalsIgnoreCase("Interactive")) {
        return INTERACTIVE;
    }
    if (value.equalsIgnoreCase("Background")) {
        return BACKGROUND;
    }
    if (value.equalsIgnoreCase("Streaming")) {
        return STREAMING;
    }
    throw new IllegalArgumentException("Unsupported Transfer mode: " + value);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.http.transport.TransferMode
* JD-Core Version:    0.7.0.1
*/