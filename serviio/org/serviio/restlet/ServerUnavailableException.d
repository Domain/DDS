module org.serviio.restlet.ServerUnavailableException;

import org.serviio.restlet.AbstractRestfulException;

public class ServerUnavailableException : AbstractRestfulException
{
    private static enum serialVersionUID = 780974277742855498L;

    public this()
    {
        super("Server is not available", 557);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.restlet.ServerUnavailableException
* JD-Core Version:    0.7.0.1
*/