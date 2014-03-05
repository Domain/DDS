module org.serviio.ui.representation.OnlinePlugin;

import java.lang;

public class OnlinePlugin : Comparable!(OnlinePlugin)
{
    private String name;
    private int ver;

    public this() {}

    public this(String name, int ver)
    {
        this.name = name;
        this.ver = ver;
    }

    public String getName()
    {
        return this.name;
    }

    public int getVersion()
    {
        return this.ver;
    }

    public int compareTo(OnlinePlugin o)
    {
        return getName().compareTo(o.getName());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.OnlinePlugin
* JD-Core Version:    0.7.0.1
*/