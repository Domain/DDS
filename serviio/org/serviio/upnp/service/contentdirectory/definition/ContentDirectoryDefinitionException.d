module org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionException;

import java.lang.String;

public class ContentDirectoryDefinitionException : Exception
{
    private static const long serialVersionUID = 6044486238252166988L;

    public this()
    {
    }

    public this(String message, Throwable cause)
    {
        super(message, cause);
    }

    public this(String message) {
        super(message);
    }

    public this(Throwable cause) {
        super(cause);
    }
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionException
* JD-Core Version:    0.6.2
*/