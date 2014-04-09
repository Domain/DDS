/// Generate by tools
module org.restlet.Message;

import java.lang.exceptions;
import org.restlet.representation.Representation;

public abstract class Message
{
    public this()
    {
        implMissing();
    }

    public Representation getEntity()
    {
        implMissing();
        return null;
    }
}
