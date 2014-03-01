module org.serviio.library.metadata.InvalidMetadataException;

import java.lang.String;

public class InvalidMetadataException : Exception
{
    private static immutable long serialVersionUID = -4813485118718894106L;

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
* Qualified Name:     org.serviio.library.metadata.InvalidMetadataException
* JD-Core Version:    0.7.0.1
*/