module org.serviio.library.online.WebResourceContainer;

import java.lang.String;
import java.util.ArrayList;
import java.util.List;
import org.serviio.library.online.WebResourceItem;

public class WebResourceContainer
{
    private String title;
    private String thumbnailUrl;
    private List!(WebResourceItem) items = new ArrayList!(WebResourceItem)();

    public String getTitle()
    {
        return this.title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public List!(WebResourceItem) getItems()
    {
        return this.items;
    }

    public void setItems(List!(WebResourceItem) items)
    {
        this.items = items;
    }

    public String getThumbnailUrl()
    {
        return this.thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl)
    {
        this.thumbnailUrl = thumbnailUrl;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("WebResourceContainer [title=").append(this.title).append(", thumbnailUrl=").append(this.thumbnailUrl).append(", items=").append(this.items).append("]");

        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.WebResourceContainer
* JD-Core Version:    0.7.0.1
*/