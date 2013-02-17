/// Generate by tools
module org.apache.jcs.JCS;

import java.lang.String;
import java.lang.exceptions;

public class JCS
{
    private this()
    {
        implMissing();
    }

    public static JCS getInstance(String name)
    {
        return new JCS();
    }

    public void dispose()
    {
    }
}
