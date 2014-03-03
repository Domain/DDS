module org.serviio.library.online.feed.FeedParser;

import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.feed.synd.SyndImage;
import com.sun.syndication.io.FeedException;
import java.lang;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import org.serviio.config.Configuration;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.AbstractOnlineItemParser;
import org.serviio.library.online.ContentURLContainer;
import org.serviio.library.online.FeedItemUrlExtractor;
import org.serviio.library.online.metadata.Feed;
import org.serviio.library.online.metadata.FeedItem;
import org.serviio.library.online.metadata.OnlineResourceParseException;
import org.serviio.library.online.feed.FeedEntryParser;
import org.serviio.util.HttpUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public class FeedParser : AbstractOnlineItemParser
{
    private static FeedEntryParser[] entryParsers;
    public static immutable String DEFAULT_LINK_NAME = "default";
    public static immutable String THUMBNAIL_LINK_NAME = "thumbnail";

    static this()
    {
        entryParsers = [ new BasicFeedEntryParser(), new MediaFeedEntryParser(), new ITunesPodcastFeedEntryParser(), new ITunesRssFeedEntryParser() ];
    }

    public Feed parse(URL feedUrl, Long onlineRepositoryId, MediaFileType fileType)
    {
        this.log.debug_(String.format("Parsing feed '%s'", cast(Object[])[ feedUrl ]));
        Feed feed = new Feed(onlineRepositoryId);
        try
        {
            String[] credentials = HttpUtils.getCredentialsFormUrl(feedUrl.toString());
            SyndFeed syndfeed = parseFeedStream(feedUrl);
            feed.setTitle(StringUtils.trim(syndfeed.getTitle()));
            feed.setDomain(feedUrl.getHost());
            setFeedThumbnail(feed, syndfeed);
            List!(SyndEntry) entries = syndfeed.getEntries();
            int maxFeedItemsToRetrieve = Configuration.getMaxNumberOfItemsForOnlineFeeds().intValue() != -1 ? Configuration.getMaxNumberOfItemsForOnlineFeeds().intValue() : entries.size();
            FeedItemUrlExtractor suitablePlugin = cast(FeedItemUrlExtractor)findSuitableExtractorPlugin(feedUrl, OnlineRepositoryType.FEED);
            feed.setUsedExtractor(suitablePlugin);
            int itemOrder = 1;
            for (int i = 0; (i < entries.size()) && (itemOrder <= maxFeedItemsToRetrieve) && (this.isAlive); i++)
            {
                bool added = addEntryToFeed(feed, feedUrl, fileType, cast(SyndEntry)entries.get(i), itemOrder, credentials, suitablePlugin);
                if (added) {
                    itemOrder++;
                }
            }
        }
        catch (FeedException e)
        {
            throw new OnlineResourceParseException(String.format("Error during feed parsing, provided URL probably doesn't point to a valid RSS/Atom feed. Message: %s", cast(Object[])[ e.getMessage() ]), e);
        }
        catch (IOException e)
        {
            throw new OnlineResourceParseException(String.format("Error during feed reading. Message: %s", cast(Object[])[ e.getMessage() ]), e);
        }
        return feed;
    }

    /* Error */
    private SyndFeed parseFeedStream(URL feedUrl)
    {
        SyndFeedInput input = new SyndFeedInput();
        byte[] feedBytes = HttpClient.retrieveBinaryFileFromURL(feedUrl.toString());
        ByteArrayInputStream feedStream = new ByteArrayInputStream(feedBytes);
        try {
            return input.build(new InputSource(feedStream));
        }
        catch (FeedException e) {
            this.log.debug_("Failed feed sample: " ~ StringUtils.trimWithEllipsis(new String(feedBytes, "UTF-8"), 100));
            try {
                this.log.debug_(String.format("Feed failed parsing (%s), trying BOM detection", e.getMessage()));
                feedStream.reset();
                return input.build(cast(Reader)new UnicodeReader(feedStream, "UTF-8"));
            }
            catch (FeedException e1) {
                try {
                    this.log.debug_(String.format("BOM Feed failed parsing (%s), trying unzipping it", e1.getMessage()));
                    feedStream.reset();
                    InputStream unzipped = ZipUtils.unGzipSingleFile(feedStream);
                    try {
                        return input.build(new InputSource(unzipped));
                    }
                    catch (FeedException e2) {
                        unzipped.reset();
                        return input.build(cast(Reader)new UnicodeReader(unzipped, "UTF-8"));
                    }
                }
                catch (IOException e2) {
                    throw e;
                }
            }
        }
        catch (IllegalArgumentException e) {
            this.log.debug_("Failed feed sample: " ~ StringUtils.trimWithEllipsis(new String(feedBytes, "UTF-8"), 100));
            throw new FeedException(e.getMessage(), cast(Throwable)e);
        }
    }

    private bool addEntryToFeed(Feed feed, URL feedUrl, MediaFileType fileType, SyndEntry entry, int order, String[] credentials, FeedItemUrlExtractor suitablePlugin)
    {
        FeedItem feedItem = new FeedItem(feed, order);
        try
        {
            foreach (FeedEntryParser entryParser ; entryParsers) {
                entryParser.parseFeedEntry(entry, feedItem);
            }
            if (suitablePlugin !is null) {
                try
                {
                    extractContentUrlViaPlugin(suitablePlugin, feedItem);
                }
                catch (Throwable e)
                {
                    this.log.debug_(String.format("Unexpected error during url extractor plugin invocation (%s) for item %s: %s", cast(Object[])[ suitablePlugin.getExtractorName(), feedItem.getTitle(), e.getMessage() ]), e);

                    return false;
                }
            }
            if (fileType == feedItem.getType())
            {
                feedItem.fillInUnknownEntries();
                feedItem.validateMetadata();
                alterUrlsWithCredentials(credentials, feedItem);

                this.log.debug_(String.format("Added feed item %s: '%s' (%s)", cast(Object[])[ Integer.valueOf(order), feedItem.getTitle(), feedItem.getContentUrl() ]));
                feed.getItems().add(feedItem);
                return true;
            }
            this.log.debug_(String.format("Skipping feed item '%s' because it's not of type %s", cast(Object[])[ feedItem.getTitle(), fileType ]));
            return false;
        }
        catch (InvalidMetadataException e)
        {
            this.log.debug_(String.format("Cannot add feed entry of feed %s because of invalid metadata. Message: %s", cast(Object[])[ feed.getTitle(), e.getMessage() ]));
        }
        return false;
    }

    private void extractContentUrlViaPlugin(FeedItemUrlExtractor urlExtractor, FeedItem feedItem)
    {
        ContentURLContainer extractedUrl = urlExtractor.extractUrl(feedItem);
        if (extractedUrl !is null) {
            feedItem.applyContentUrlContainer(extractedUrl, urlExtractor);
        } else {
            this.log.warn(String.format("Plugin %s returned no value for resource item '%s'", cast(Object[])[ urlExtractor.getExtractorName(), feedItem.getTitle() ]));
        }
    }

    private void setFeedThumbnail(Feed feed, SyndFeed syndfeed)
    {
        SyndImage image = syndfeed.getImage();
        if ((image !is null) && (ObjectValidator.isNotEmpty(image.getUrl()))) {
            try
            {
                ImageDescriptor thumbnail = new ImageDescriptor(new URL(image.getUrl()));
                feed.setThumbnail(thumbnail);
            }
            catch (MalformedURLException e)
            {
                this.log.warn(String.format("Malformed url of a feed thumbnail (%s), skipping this thumbnail", cast(Object[])[ image.getUrl() ]));
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.feed.FeedParser
* JD-Core Version:    0.7.0.1
*/