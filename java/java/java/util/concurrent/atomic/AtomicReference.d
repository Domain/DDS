/// Generate by tools
module java.util.concurrent.atomic.AtomicReference;

import java.lang.util;
import java.lang.exceptions;

public class AtomicReference(T)
{
    private T val;

    public this()
    {
        implMissing();
    }

    public this(T value)
    {
        set(value);
    }

    public void set(T value)
    {
        val = value;
    }

    public const(T) get() const
    {
        return val;
    }
}
