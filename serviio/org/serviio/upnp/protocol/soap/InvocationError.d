module org.serviio.upnp.protocol.soap.InvocationError;

import java.lang.String;

public enum InvocationError
{
    INVALID_ACTION,  
    INVALID_ARGS,  
    INVALID_VAR,  
    ACTION_FAILED,  
    CON_MAN_INVALID_CONNECTION_REFERENCE,  
    CON_MAN_NO_SUCH_OBJECT,  
    CON_MAN_NO_SUCH_CONTAINER
}

public int getCode(InvocationError error)
{
    switch (error)
    {
        case INVALID_ACTION: 
            return 401;
        case INVALID_ARGS: 
            return 402;
        case INVALID_VAR: 
            return 404;
        case ACTION_FAILED: 
            return 501;
        case CON_MAN_INVALID_CONNECTION_REFERENCE: 
            return 706;
        case CON_MAN_NO_SUCH_OBJECT: 
            return 701;
        case CON_MAN_NO_SUCH_CONTAINER: 
            return 710;
    }

    return 0;
}

public String getDescription(InvocationError error)
{
    switch (error)
    {
        case INVALID_ACTION: 
            return "Invalid Action";
        case INVALID_ARGS: 
            return "Invalid Args";
        case INVALID_VAR: 
            return "Invalid Var";
        case ACTION_FAILED: 
            return "Action Failed";
        case CON_MAN_INVALID_CONNECTION_REFERENCE: 
            return "Invalid connection reference";
        case CON_MAN_NO_SUCH_OBJECT: 
            return "No such object";
        case CON_MAN_NO_SUCH_CONTAINER: 
            return "No such container";
    }

    return null;
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.soap.InvocationError
* JD-Core Version:    0.7.0.1
*/