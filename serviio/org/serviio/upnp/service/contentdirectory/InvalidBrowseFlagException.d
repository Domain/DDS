module org.serviio.upnp.service.contentdirectory.InvalidBrowseFlagException;

import java.lang;

public class InvalidBrowseFlagException : RuntimeException
{
    private static enum serialVersionUID = 4548915322234063569L;

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
* Qualified Name:     org.serviio.upnp.service.contentdirectory.InvalidBrowseFlagException
* JD-Core Version:    0.7.0.1
*/