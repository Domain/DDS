module java.lang.StringBuilder;

import std.conv;

import java.lang;

public class StringBuilder
{
    public this()
    {
        implMissing();
    }

    public this(String)
    {
        implMissing();
    }

    public StringBuilder append(String)
    {
        implMissing();
        return this;
    }

    public StringBuilder append(T)(T obj)
    {
        return append(to!String(obj));
    }
}