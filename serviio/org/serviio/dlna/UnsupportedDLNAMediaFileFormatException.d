module org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;

import java.lang.String;

public class UnsupportedDLNAMediaFileFormatException : Exception
{
    private static immutable serialVersionUID = -896277702729810672L;

    public this() 
    {
        super("");
    }

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
        super(cause.toString());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.UnsupportedDLNAMediaFileFormatException
* JD-Core Version:    0.7.0.1
*/