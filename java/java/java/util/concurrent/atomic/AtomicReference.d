/// Generate by tools
module java.util.concurrent.atomic.AtomicReference;

import java.lang.exceptions;

public class AtomicReference(T)
{
    private T val;

    public this()
    {
        implMissing();
    }

    public void set(T value)
    {
        val = value;
    }

    public T get() const
    {
        return val;
    }
}
