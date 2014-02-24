module org.serviio.library.online.feed.ITunesRssFeedEntryParser;

import com.sun.syndication.feed.synd.SyndEntry;
import java.util.Collections;
import java.util.List;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.online.feed.mod.itunes.ITunesRssModule;
import org.serviio.library.online.feed.mod.itunes.Image;
import org.serviio.library.online.metadata.FeedItem;
import org.serviio.library.online.metadata.TechnicalMetadata;
import org.serviio.util.ObjectValidator;

public class ITunesRssFeedEntryParser : FeedEntryParser
{
    public void parseFeedEntry(SyndEntry entry, FeedItem item)
    {
        ITunesRssModule mod = cast(ITunesRssModule)entry.getModule("http://itunes.apple.com/rss");
        if (mod !is null)
        {
            if (ObjectValidator.isNotEmpty(mod.getArtist())) {
                item.setAuthor(mod.getArtist());
            }
            if (mod.getReleaseDate() !is null) {
                item.setDate(mod.getReleaseDate());
            }
            if (mod.getDuration() !is null) {
                item.getTechnicalMD().setDuration(new Long(mod.getDuration().intValue() / 1000));
            }
            if ((mod.getImages() !is null) && (mod.getImages().size() > 0))
            {
                Collections.sort(mod.getImages());

                Image selectedThumbnail = cast(Image)mod.getImages().get(mod.getImages().size() - 1);

                ImageDescriptor thumbnail = new ImageDescriptor(selectedThumbnail.getUrl());
                thumbnail.setWidth(selectedThumbnail.getWidth());
                thumbnail.setHeight(selectedThumbnail.getHeight());
                item.setThumbnail(thumbnail);
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.feed.ITunesRssFeedEntryParser
* JD-Core Version:    0.7.0.1
*/