module org.serviio.library.playlist.ParsedPlaylist;

import java.lang.String;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.serviio.library.playlist.PlaylistItem;

public class ParsedPlaylist
{
    private String title;
    private List!(PlaylistItem) items = new ArrayList();

    public this(String title)
    {
        this.title = title;
    }

    public void addItem(String path)
    {
        this.items.add(new PlaylistItem(path, Integer.valueOf(this.items.size() + 1)));
    }

    public List!(PlaylistItem) getItems()
    {
        return Collections.unmodifiableList(this.items);
    }

    public String getTitle()
    {
        return this.title;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.playlist.ParsedPlaylist
* JD-Core Version:    0.7.0.1
*/