module org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException;

import java.lang.String;

public class InvalidResourceException : Exception
{
    private static immutable long serialVersionUID = 4657419096469829296L;

    public this(String message)
    {
        super(message);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException
* JD-Core Version:    0.7.0.1
*/