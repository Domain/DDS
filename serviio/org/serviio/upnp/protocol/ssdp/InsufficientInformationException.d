module org.serviio.upnp.protocol.ssdp.InsufficientInformationException;

import java.lang.String;
import java.lang.RuntimeException;

public class InsufficientInformationException : RuntimeException
{
    private static enum serialVersionUID = 2611838684813754915L;

    public this() {}

    public this(String message, Throwable cause)
    {
        super(message, cause);
    }

    public this(String message)
    {
        super(message);
    }

    public this(Throwable cause)
    {
        super(cause);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.ssdp.InsufficientInformationException
* JD-Core Version:    0.7.0.1
*/