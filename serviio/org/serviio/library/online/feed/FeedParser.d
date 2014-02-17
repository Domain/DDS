module org.serviio.library.online.feed.FeedParser;

import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.feed.synd.SyndImage;
import com.sun.syndication.io.FeedException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import org.serviio.config.Configuration;
import org.serviio.library.entities.OnlineRepository.OnlineRepositoryType;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.AbstractOnlineItemParser;
import org.serviio.library.online.ContentURLContainer;
import org.serviio.library.online.FeedItemUrlExtractor;
import org.serviio.library.online.metadata.Feed;
import org.serviio.library.online.metadata.FeedItem;
import org.serviio.library.online.metadata.OnlineResourceParseException;
import org.serviio.util.HttpUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public class FeedParser
  : AbstractOnlineItemParser
{
  private static final FeedEntryParser[] entryParsers = { new BasicFeedEntryParser(), new MediaFeedEntryParser(), new ITunesPodcastFeedEntryParser(), new ITunesRssFeedEntryParser() };
  public static immutable String DEFAULT_LINK_NAME = "default";
  public static immutable String THUMBNAIL_LINK_NAME = "thumbnail";
  
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
      FeedItemUrlExtractor suitablePlugin = cast(FeedItemUrlExtractor)findSuitableExtractorPlugin(feedUrl, OnlineRepository.OnlineRepositoryType.FEED);
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
    // Byte code:
    //   0: new 38	com/sun/syndication/io/SyndFeedInput
    //   3: dup
    //   4: invokespecial 39	com/sun/syndication/io/SyndFeedInput:!(init)	()V
    //   7: astore_2
    //   8: aload_1
    //   9: invokevirtual 9	java/net/URL:toString	()Ljava/lang/String;
    //   12: invokestatic 40	org/serviio/util/HttpClient:retrieveBinaryFileFromURL	(Ljava/lang/String;)[B
    //   15: astore_3
    //   16: new 41	java/io/ByteArrayInputStream
    //   19: dup
    //   20: aload_3
    //   21: invokespecial 42	java/io/ByteArrayInputStream:!(init)	([B)V
    //   24: astore 4
    //   26: aload_2
    //   27: new 43	org/xml/sax/InputSource
    //   30: dup
    //   31: aload 4
    //   33: invokespecial 44	org/xml/sax/InputSource:!(init)	(Ljava/io/InputStream;)V
    //   36: invokevirtual 45	com/sun/syndication/io/SyndFeedInput:build	(Lorg/xml/sax/InputSource;)Lcom/sun/syndication/feed/synd/SyndFeed;
    //   39: areturn
    //   40: astore 5
    //   42: aload_0
    //   43: getfield 2	org/serviio/library/online/feed/FeedParser:log	Lorg/slf4j/Logger;
    //   46: new 46	java/lang/StringBuilder
    //   49: dup
    //   50: invokespecial 47	java/lang/StringBuilder:!(init)	()V
    //   53: ldc 48
    //   55: invokevirtual 49	java/lang/StringBuilder:append	(Ljava/lang/String;)Ljava/lang/StringBuilder;
    //   58: new 50	java/lang/String
    //   61: dup
    //   62: aload_3
    //   63: ldc 51
    //   65: invokespecial 52	java/lang/String:!(init)	([BLjava/lang/String;)V
    //   68: bipush 100
    //   70: invokestatic 53	org/serviio/util/StringUtils:trimWithEllipsis	(Ljava/lang/String;I)Ljava/lang/String;
    //   73: invokevirtual 49	java/lang/StringBuilder:append	(Ljava/lang/String;)Ljava/lang/StringBuilder;
    //   76: invokevirtual 54	java/lang/StringBuilder:toString	()Ljava/lang/String;
    //   79: invokeinterface 6 2 0
    //   84: aload_0
    //   85: getfield 2	org/serviio/library/online/feed/FeedParser:log	Lorg/slf4j/Logger;
    //   88: ldc 55
    //   90: iconst_1
    //   91: anewarray 4	java/lang/Object
    //   94: dup
    //   95: iconst_0
    //   96: aload 5
    //   98: invokevirtual 33	com/sun/syndication/io/FeedException:getMessage	()Ljava/lang/String;
    //   101: aastore
    //   102: invokestatic 5	java/lang/String:format	(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;
    //   105: invokeinterface 6 2 0
    //   110: aload 4
    //   112: invokevirtual 56	java/io/InputStream:reset	()V
    //   115: aload_2
    //   116: new 57	org/serviio/util/UnicodeReader
    //   119: dup
    //   120: aload 4
    //   122: ldc 51
    //   124: invokespecial 58	org/serviio/util/UnicodeReader:!(init)	(Ljava/io/InputStream;Ljava/lang/String;)V
    //   127: invokevirtual 59	com/sun/syndication/io/SyndFeedInput:build	(Ljava/io/Reader;)Lcom/sun/syndication/feed/synd/SyndFeed;
    //   130: areturn
    //   131: astore 6
    //   133: aload_0
    //   134: getfield 2	org/serviio/library/online/feed/FeedParser:log	Lorg/slf4j/Logger;
    //   137: ldc 60
    //   139: iconst_1
    //   140: anewarray 4	java/lang/Object
    //   143: dup
    //   144: iconst_0
    //   145: aload 6
    //   147: invokevirtual 33	com/sun/syndication/io/FeedException:getMessage	()Ljava/lang/String;
    //   150: aastore
    //   151: invokestatic 5	java/lang/String:format	(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;
    //   154: invokeinterface 6 2 0
    //   159: aload 4
    //   161: invokevirtual 56	java/io/InputStream:reset	()V
    //   164: aload 4
    //   166: invokestatic 61	org/serviio/util/ZipUtils:unGzipSingleFile	(Ljava/io/InputStream;)Ljava/io/InputStream;
    //   169: astore 7
    //   171: aload_2
    //   172: new 43	org/xml/sax/InputSource
    //   175: dup
    //   176: aload 7
    //   178: invokespecial 44	org/xml/sax/InputSource:!(init)	(Ljava/io/InputStream;)V
    //   181: invokevirtual 45	com/sun/syndication/io/SyndFeedInput:build	(Lorg/xml/sax/InputSource;)Lcom/sun/syndication/feed/synd/SyndFeed;
    //   184: areturn
    //   185: astore 8
    //   187: aload 7
    //   189: invokevirtual 56	java/io/InputStream:reset	()V
    //   192: aload_2
    //   193: new 57	org/serviio/util/UnicodeReader
    //   196: dup
    //   197: aload 7
    //   199: ldc 51
    //   201: invokespecial 58	org/serviio/util/UnicodeReader:!(init)	(Ljava/io/InputStream;Ljava/lang/String;)V
    //   204: invokevirtual 59	com/sun/syndication/io/SyndFeedInput:build	(Ljava/io/Reader;)Lcom/sun/syndication/feed/synd/SyndFeed;
    //   207: areturn
    //   208: astore 7
    //   210: aload 5
    //   212: athrow
    //   213: astore 5
    //   215: aload_0
    //   216: getfield 2	org/serviio/library/online/feed/FeedParser:log	Lorg/slf4j/Logger;
    //   219: new 46	java/lang/StringBuilder
    //   222: dup
    //   223: invokespecial 47	java/lang/StringBuilder:!(init)	()V
    //   226: ldc 48
    //   228: invokevirtual 49	java/lang/StringBuilder:append	(Ljava/lang/String;)Ljava/lang/StringBuilder;
    //   231: new 50	java/lang/String
    //   234: dup
    //   235: aload_3
    //   236: ldc 51
    //   238: invokespecial 52	java/lang/String:!(init)	([BLjava/lang/String;)V
    //   241: bipush 100
    //   243: invokestatic 53	org/serviio/util/StringUtils:trimWithEllipsis	(Ljava/lang/String;I)Ljava/lang/String;
    //   246: invokevirtual 49	java/lang/StringBuilder:append	(Ljava/lang/String;)Ljava/lang/StringBuilder;
    //   249: invokevirtual 54	java/lang/StringBuilder:toString	()Ljava/lang/String;
    //   252: invokeinterface 6 2 0
    //   257: new 30	com/sun/syndication/io/FeedException
    //   260: dup
    //   261: aload 5
    //   263: invokevirtual 63	java/lang/IllegalArgumentException:getMessage	()Ljava/lang/String;
    //   266: aload 5
    //   268: invokespecial 64	com/sun/syndication/io/FeedException:!(init)	(Ljava/lang/String;Ljava/lang/Throwable;)V
    //   271: athrow
    // Line number table:
    //   Java source line #115	-> byte code offset #0
    //   Java source line #116	-> byte code offset #8
    //   Java source line #117	-> byte code offset #16
    //   Java source line #120	-> byte code offset #26
    //   Java source line #121	-> byte code offset #40
    //   Java source line #123	-> byte code offset #42
    //   Java source line #125	-> byte code offset #84
    //   Java source line #126	-> byte code offset #110
    //   Java source line #127	-> byte code offset #115
    //   Java source line #128	-> byte code offset #131
    //   Java source line #130	-> byte code offset #133
    //   Java source line #131	-> byte code offset #159
    //   Java source line #132	-> byte code offset #164
    //   Java source line #134	-> byte code offset #171
    //   Java source line #135	-> byte code offset #185
    //   Java source line #136	-> byte code offset #187
    //   Java source line #137	-> byte code offset #192
    //   Java source line #139	-> byte code offset #208
    //   Java source line #141	-> byte code offset #210
    //   Java source line #144	-> byte code offset #213
    //   Java source line #145	-> byte code offset #215
    //   Java source line #146	-> byte code offset #257
    // Local variable table:
    //   start	length	slot	name	signature
    //   0	272	0	this	FeedParser
    //   0	272	1	feedUrl	URL
    //   7	186	2	input	com.sun.syndication.io.SyndFeedInput
    //   15	221	3	feedBytes	byte[]
    //   24	141	4	feedStream	java.io.InputStream
    //   40	171	5	e	FeedException
    //   213	54	5	e	java.lang.IllegalArgumentException
    //   131	15	6	e1	FeedException
    //   169	29	7	unzipped	java.io.InputStream
    //   208	3	7	e2	IOException
    //   185	3	8	e2	FeedException
    // Exception table:
    //   from	to	target	type
    //   26	39	40	com/sun/syndication/io/FeedException
    //   84	130	131	com/sun/syndication/io/FeedException
    //   171	184	185	com/sun/syndication/io/FeedException
    //   133	184	208	java/io/IOException
    //   185	207	208	java/io/IOException
    //   26	39	213	java/lang/IllegalArgumentException
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