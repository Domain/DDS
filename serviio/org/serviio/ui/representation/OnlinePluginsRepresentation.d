module org.serviio.ui.representation.OnlinePluginsRepresentation;

import com.thoughtworks.xstream.annotations.XStreamImplicit;
import java.util.Set;
import java.util.TreeSet;
import org.serviio.ui.representation.OnlinePlugin;

public class OnlinePluginsRepresentation
{
    //@XStreamImplicit
    private Set!(OnlinePlugin) plugins;

    public this()
    {
        plugins = new TreeSet();
    }

    public Set!(OnlinePlugin) getPlugins()
    {
        return this.plugins;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.OnlinePluginsRepresentation
* JD-Core Version:    0.7.0.1
*/