module org.serviio.upnp.service.contentdirectory.classes.PlaylistContainer;

import java.lang.String;
import org.serviio.upnp.service.contentdirectory.classes.Container;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public class PlaylistContainer : Container
{
    public this(String id, String title)
    {
        super(id, title);
    }

    override public ObjectClassType getObjectClass()
    {
        return ObjectClassType.PLAYLIST_CONTAINER;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.PlaylistContainer
* JD-Core Version:    0.7.0.1
*/