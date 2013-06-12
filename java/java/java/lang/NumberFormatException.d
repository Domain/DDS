module java.lang.NumberFormatException;

import java.lang.IllegalArgumentException;
import java.lang.exceptions;
import java.lang.String;

public class NumberFormatException : IllegalArgumentException
{
    static const long serialVersionUID = -2848938806368998894L;

    public this()
    {
    }

    public this(String paramString)
    {
        super(paramString);
    }

    static NumberFormatException forInputString(String paramString)
    {
        return new NumberFormatException("For input string: \"" ~ paramString ~ "\"");
    }
}
