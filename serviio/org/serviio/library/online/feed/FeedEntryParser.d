module org.serviio.library.online.feed.FeedEntryParser;

import com.sun.syndication.feed.synd.SyndEntry;
import org.serviio.library.online.metadata.FeedItem;

public abstract interface FeedEntryParser
{
  public abstract void parseFeedEntry(SyndEntry paramSyndEntry, FeedItem paramFeedItem);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.feed.FeedEntryParser
 * JD-Core Version:    0.7.0.1
 */