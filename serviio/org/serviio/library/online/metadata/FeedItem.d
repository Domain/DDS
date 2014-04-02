module org.serviio.library.online.metadata.FeedItem;

import java.lang.String;
import java.io.Serializable;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import org.serviio.library.online.metadata.OnlineContainerItem;
import org.serviio.library.online.metadata.Feed;

public class FeedItem : OnlineContainerItem!(Feed), Serializable
{
    private static immutable long serialVersionUID = -1114391919989682022L;
    private Map!(String, URL) links = new HashMap!(String, URL)();

    public this(Feed parentFeed, int feedOrder)
    {
        this.parentContainer = parentFeed;
        this.order = feedOrder;
    }

    public Map!(String, URL) getLinks()
    {
        return this.links;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.metadata.FeedItem
* JD-Core Version:    0.7.0.1
*/