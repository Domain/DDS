module org.serviio.profile.ProfilesDefinitionException;

import java.lang.String;

public class ProfilesDefinitionException : Exception
{
    private static enum serialVersionUID = 6044486238252166988L;

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
* Qualified Name:     org.serviio.profile.ProfilesDefinitionException
* JD-Core Version:    0.7.0.1
*/