module org.serviio.library.online.feed.ITunesPodcastFeedEntryParser;

import com.sun.syndication.feed.mod.itunes.EntryInformation;
import com.sun.syndication.feed.mod.itunes.types.Duration;
import com.sun.syndication.feed.synd.SyndEntry;
import org.serviio.library.online.metadata.FeedItem;
import org.serviio.library.online.metadata.TechnicalMetadata;
import org.serviio.library.online.feed.FeedEntryParser;
import org.serviio.util.ObjectValidator;

public class ITunesPodcastFeedEntryParser : FeedEntryParser
{
    public void parseFeedEntry(SyndEntry entry, FeedItem item)
    {
        EntryInformation mod = cast(EntryInformation)entry.getModule("http://www.itunes.com/dtds/podcast-1.0.dtd");
        if (mod !is null)
        {
            if (ObjectValidator.isNotEmpty(mod.getAuthor())) {
                item.setAuthor(mod.getAuthor());
            }
            if ((item.getTechnicalMD().getDuration() is null) && (mod.getDuration() !is null)) {
                item.getTechnicalMD().setDuration(Long.valueOf(mod.getDuration().getMilliseconds() / 1000L));
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.feed.ITunesPodcastFeedEntryParser
* JD-Core Version:    0.7.0.1
*/