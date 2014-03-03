module org.serviio.library.online.metadata.OnlineResourceParseException;

import java.lang.String;

public class OnlineResourceParseException : Exception
{
    private static long serialVersionUID = -8332503090715064260L;

    public this(String message, Throwable cause)
    {
        super(message, cause);
    }

    public this(String message)
    {
        super(message);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.metadata.OnlineResourceParseException
* JD-Core Version:    0.7.0.1
*/