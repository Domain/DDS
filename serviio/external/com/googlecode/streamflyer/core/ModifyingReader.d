/// Generate by tools
module com.googlecode.streamflyer.core.ModifyingReader;

import java.lang.exceptions;
import java.io.Reader;
import com.googlecode.streamflyer.core.Modifier;

public class ModifyingReader : Reader
{
    public this(Reader, Modifier)
    {
        implMissing();
    }

    override void close()
    {
        implMissng();
    }

    override int read(char[], int, int)
    {
        implMissing();
    }
}
