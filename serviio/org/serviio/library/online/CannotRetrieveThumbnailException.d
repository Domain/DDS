module org.serviio.library.online.CannotRetrieveThumbnailException;

import java.lang.String;

public class CannotRetrieveThumbnailException : Exception
{
    private static immutable long serialVersionUID = 3818361224060004057L;

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
* Qualified Name:     org.serviio.library.online.CannotRetrieveThumbnailException
* JD-Core Version:    0.7.0.1
*/