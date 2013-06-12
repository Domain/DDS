module java.net.MalformedURLException;

import java.lang.String;
import java.io.IOException;

public class MalformedURLException : IOException
{
    public this()
    {
    }

    public this(String paramString)
    {
        super(paramString);
    }
}