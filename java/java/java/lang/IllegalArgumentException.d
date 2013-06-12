module java.lang.IllegalArgumentException;

import java.lang.String;
import java.lang.exceptions;
import java.lang.RuntimeException;

public class IllegalArgumentException : RuntimeException
{
    private static const long serialVersionUID = -5365630128856068164L;

    public this()
    {
    }

    public this(String paramString)
    {
        super(paramString);
    }

    public this(String paramString, Throwable paramThrowable)
    {
        super(paramString, paramThrowable);
    }

    public this(Throwable paramThrowable)
    {
        super(paramThrowable);
    }
}
