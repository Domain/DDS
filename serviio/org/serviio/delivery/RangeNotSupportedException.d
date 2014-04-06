module org.serviio.delivery.RangeNotSupportedException;

import java.lang.String;

public class RangeNotSupportedException : Exception
{
    private static enum serialVersionUID = -1350679542734185819L;

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
* Qualified Name:     org.serviio.delivery.RangeNotSupportedException
* JD-Core Version:    0.7.0.1
*/