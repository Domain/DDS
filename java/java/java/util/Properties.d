/// Generate by tools
module java.util.Properties;

import java.lang;
import java.io.InputStream;
import java.util.Hashtable;
import java.lang.exceptions;

public class Properties : Hashtable!(String, String)
{
    public this()
    {
        implMissing();
    }

    /*public this() shared
    {
        implMissing();
    }*/

    override public String get(String name)
    {
        implMissing();
        return "";
    }

    public /*synchronized*/ void load(InputStream paramInputStream)
    {
        implMissing();
    }
}
