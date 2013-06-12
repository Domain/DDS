module java.io.FileNotFoundException;

import java.lang.String;
import java.lang.StringBuilder;
import java.io.IOException;

public class FileNotFoundException : IOException
{
    public this()
    {
    }

    public this(String paramString)
    {
        super(paramString);
    }

    private this(String paramString1, String paramString2)
    {
        super(paramString1 ~ (paramString2 == null ? "" : (new StringBuilder()).append(" (").append(paramString2).append(")").toString()));
    }
}
