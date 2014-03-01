module org.serviio.library.local.metadata.extractor.MetadataSourceNotAccessibleException;

import java.lang.String;

public class MetadataSourceNotAccessibleException : Exception
{
    private static immutable long serialVersionUID = 6651254433838802508L;

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
* Qualified Name:     org.serviio.library.local.metadata.extractor.MetadataSourceNotAccessibleException
* JD-Core Version:    0.7.0.1
*/