module org.serviio.library.online.OnlineLibraryManager;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import org.serviio.config.Configuration;
import org.serviio.library.AbstractLibraryManager;
import org.serviio.library.entities.CoverImage;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.local.service.CoverImageService;
import org.serviio.library.local.service.SearchService;
import org.serviio.library.metadata.LibraryIndexingListener;
import org.serviio.library.online.feed.FeedParser;
import org.serviio.library.online.metadata.FeedUpdaterThread;
import org.serviio.library.online.metadata.MissingPluginException;
import org.serviio.library.online.metadata.OnlineCDSLibraryIndexingListener;
import org.serviio.library.online.metadata.OnlineCachable;
import org.serviio.library.online.metadata.OnlineContainerItem;
import org.serviio.library.online.metadata.OnlineResourceContainer;
import org.serviio.library.online.metadata.OnlineResourceParseException;
import org.serviio.library.online.metadata.SingleURLItem;
import org.serviio.library.online.metadata.TechnicalMetadata;
import org.serviio.library.online.metadata.WebResourceFeed;
import org.serviio.library.online.metadata.WebResourceFeedItem;
import org.serviio.util.DateUtils;
import org.serviio.util.HttpClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OnlineLibraryManager
  : AbstractLibraryManager
{
  private static final Logger log = LoggerFactory.getLogger!(OnlineLibraryManager);
  private static OnlineLibraryManager instance;
  private OnlineCacheDecorator!(OnlineCachable) onlineCache;
  private OnlineCacheDecorator!(CoverImage) thumbnailCache;
  private OnlineCacheDecorator!(TechnicalMetadata) technicalMetadataCache;
  private FeedParser feedParser;
  private SingleURLParser singleURLParser;
  private WebResourceParser webResourceParser;
  private FeedUpdaterThread feedUpdaterThread;
  private LibraryIndexingListener cdsListener;
  private Map!(String, Date) feedExpiryMonitor = Collections.synchronizedMap(new HashMap());
  private final CountDownLatch pluginsCompiled = new CountDownLatch(1);
  
  public static OnlineLibraryManager getInstance()
  {
    if (instance is null) {
      instance = new OnlineLibraryManager();
    }
    return instance;
  }
  
  private this()
  {
    this.onlineCache = new OnlineContentCacheDecorator("online_feeds");
    this.thumbnailCache = new ThumbnailCacheDecorator("thumbnails");
    this.technicalMetadataCache = new TechnicalMetadataCacheDecorator("online_technical_metadata");
    this.feedParser = new FeedParser();
    this.webResourceParser = new WebResourceParser();
    this.singleURLParser = new SingleURLParser();
    this.cdsListener = new OnlineCDSLibraryIndexingListener();
  }
  
  public void startFeedUpdaterThread()
  {
    synchronized (this.cdsListener)
    {
      try
      {
        this.pluginsCompiled.await();
      }
      catch (InterruptedException e) {}
      this.feedParser.startParsing();
      this.webResourceParser.startParsing();
      if ((this.feedUpdaterThread is null) || ((this.feedUpdaterThread !is null) && (!this.feedUpdaterThread.isWorkerRunning())))
      {
        this.feedUpdaterThread = new FeedUpdaterThread(this);
        this.feedUpdaterThread.setName("FeedUpdaterThread");
        this.feedUpdaterThread.setDaemon(true);
        this.feedUpdaterThread.setPriority(1);
        this.feedUpdaterThread.addListener(this.cdsListener);
        this.feedUpdaterThread.start();
      }
    }
  }
  
  public void startPluginCompilerThread()
  {
    AbstractOnlineItemParser.startPluginCompilerThread(this.pluginsCompiled);
  }
  
  public void stopFeedUpdaterThread()
  {
    synchronized (this.cdsListener)
    {
      this.feedParser.stopParsing();
      this.webResourceParser.stopParsing();
      stopThread(this.feedUpdaterThread);
      this.feedUpdaterThread = null;
    }
  }
  
  public void stopPluginCompilerThread()
  {
    AbstractOnlineItemParser.stopPluginCompilerThread();
    
    PluginExecutionProcessor.shutdown();
  }
  
  public void invokeFeedUpdaterThread()
  {
    if (this.feedUpdaterThread !is null) {
      this.feedUpdaterThread.invoke();
    }
  }
  
  public OnlineResourceContainer/*!(?, ?)*/ findResource(OnlineRepository onlineRepository, bool onlyCached)
  {
    try
    {
      URL resourceUrl = new URL(onlineRepository.getRepositoryUrl());
      OnlineResourceContainer/*!(?, ?)*/ resource = null;
      synchronized (this.onlineCache)
      {
        resource = cast(OnlineResourceContainer)this.onlineCache.retrieve(resourceUrl.toString());
      }
      if ((!onlyCached) && (isResourceRefreshNeeded(resourceUrl, resource)))
      {
        log.debug_(String.format("Resource %s not in cache, cast(re)loading it", cast(Object[])[ resourceUrl.toString() ]));
        if (onlineRepository.getRepoType() == OnlineRepositoryType.FEED) {
          resource = this.feedParser.parse(resourceUrl, onlineRepository.getId(), onlineRepository.getFileType());
        } else {
          resource = this.webResourceParser.parse(resourceUrl, onlineRepository.getId(), onlineRepository.getFileType());
        }
        synchronized (this.onlineCache)
        {
          this.onlineCache.store(resourceUrl.toString(), resource);
        }
        SearchService.makeOnlineUnsearchable(onlineRepository.getId());
        
        storeResourceExpiryDate(resourceUrl.toString(), resource);
      }
      return resource;
    }
    catch (MalformedURLException e)
    {
      log.warn(String.format("Could not parse URL %s", cast(Object[])[ onlineRepository.getRepositoryUrl() ]), e);
    }
    return null;
  }
  
  public OnlineResourceContainer/*!(?, ?)*/ findResourceInCacheOrParse(OnlineRepository onlineRepository)
  {
    return findResource(onlineRepository, false);
  }
  
  public SingleURLItem findSingleURLItemInCacheOrParse(OnlineRepository onlineRepository)
  {
    SingleURLItem item = null;
    if (onlineRepository !is null)
    {
      synchronized (this.onlineCache)
      {
        item = cast(SingleURLItem)this.onlineCache.retrieve(onlineRepository.getRepositoryUrl());
      }
      if (item is null)
      {
        item = this.singleURLParser.parseItem(onlineRepository);
        synchronized (this.onlineCache)
        {
          this.onlineCache.store(onlineRepository.getRepositoryUrl(), item);
        }
      }
    }
    return item;
  }
  
  public void removeOnlineContentFromCache(String resourceUrl, Long onlineRepositoryId, bool resetExpiryDate)
  {
    synchronized (this.feedExpiryMonitor)
    {
      this.onlineCache.evict(resourceUrl);
      this.webResourceParser.cleanItemCache(resourceUrl);
      if (resetExpiryDate) {
        this.feedExpiryMonitor.remove(resourceUrl);
      }
      SearchService.makeOnlineUnsearchable(onlineRepositoryId);
    }
  }
  
  public void removeFeedFromCache(AbstractUrlExtractor plugin)
  {
    synchronized (this.feedExpiryMonitor)
    {
      Set!(String) urls = new HashSet(this.feedExpiryMonitor.keySet());
      foreach (String feedUrl ; urls)
      {
        OnlineResourceContainer/*!(?, ?)*/ resource = cast(OnlineResourceContainer)this.onlineCache.retrieve(feedUrl);
        if ((resource !is null) && (resource.getUsedExtractor() !is null) && (resource.getUsedExtractor().equals(plugin)))
        {
          log.debug_(String.format("Removing feed %s generated via %s from cache", cast(Object[])[ feedUrl, plugin.getExtractorName() ]));
          removeOnlineContentFromCache(feedUrl, resource.getOnlineRepositoryId(), true);
        }
      }
    }
  }
  
  public void storeTechnicalMetadata(String cacheKey, TechnicalMetadata md)
  {
    synchronized (this.technicalMetadataCache)
    {
      this.technicalMetadataCache.store(cacheKey, md);
    }
  }
  
  public TechnicalMetadata findTechnicalMetadata(String cacheKey)
  {
    synchronized (this.technicalMetadataCache)
    {
      if (cacheKey !is null) {
        return cast(TechnicalMetadata)this.technicalMetadataCache.retrieve(cacheKey);
      }
      return null;
    }
  }
  
  public CoverImage findThumbnail(ImageDescriptor thumbnail, String userAgent)
  {
    synchronized (this.thumbnailCache)
    {
      if ((thumbnail !is null) && (thumbnail.getImageUrl() !is null))
      {
        CoverImage coverImage = cast(CoverImage)this.thumbnailCache.retrieve(thumbnail.getImageUrl().toString());
        if (coverImage is null) {
          try
          {
            log.debug_(String.format("Thumbnail '%s' not in cache yet, loading it", cast(Object[])[ thumbnail.getImageUrl().toString() ]));
            byte[] imageBytes = HttpClient.retrieveBinaryFileFromURL(thumbnail.getImageUrl().toString(), userAgent);
            ImageDescriptor clonedImage = new ImageDescriptor(imageBytes, null);
            coverImage = CoverImageService.prepareCoverImage(clonedImage, null);
            if (coverImage is null) {
              throw new CannotRetrieveThumbnailException(String.format("An error accured when resizing thumbnail %s", cast(Object[])[ thumbnail.getImageUrl().toString() ]));
            }
            this.thumbnailCache.store(thumbnail.getImageUrl().toString(), coverImage);
          }
          catch (IOException e)
          {
            throw new CannotRetrieveThumbnailException(String.format("Failed to download thumbnail %s.", cast(Object[])[ thumbnail.getImageUrl().toString() ]), e);
          }
        }
        return coverImage;
      }
      return null;
    }
  }
  
  public void storeExpiryDateForFailedResource(String feedUrl, Long onlineRepositoryId)
  {
    log.debug_(String.format("Resetting expiry date for feed %s", cast(Object[])[ feedUrl ]));
    storeResourceExpiryDate(feedUrl, null);
    log.debug_(String.format("Removing feed %s from online cache", cast(Object[])[ feedUrl ]));
    removeOnlineContentFromCache(feedUrl, onlineRepositoryId, false);
  }
  
  private bool isResourceRefreshNeeded(URL resourceUrl, OnlineResourceContainer/*!(?, ?)*/ resource)
  {
    synchronized (this.feedExpiryMonitor)
    {
      Date expiryDate = cast(Date)this.feedExpiryMonitor.get(resourceUrl.toString());
      if (expiryDate !is null)
      {
        Date currentDate = new Date();
        bool resourceExpired = currentDate.after(expiryDate);
        if ((!resourceExpired) && (resource !is null)) {
          foreach (OnlineContainerItem/*!(?)*/ item ; resource.getItems()) {
            if (item.getExpiresOn() !is null) {
              if (currentDate.after(DateUtils.minusMinutes(item.getExpiresOn(), 5)))
              {
                resourceExpired = true;
                if (( cast(WebResourceFeed)resource !is null )) {
                  this.webResourceParser.cleanItemCache(resourceUrl, cast(WebResourceFeedItem)item);
                }
              }
            }
          }
        }
        if (resourceExpired) {
          log.debug_(String.format("Online resource %s expired, will reload it", cast(Object[])[ resourceUrl.toString() ]));
        }
        return resourceExpired;
      }
      return resource is null;
    }
  }
  
  private Date getEarliestItemExpiryDate(OnlineResourceContainer/*!(?, ?)*/ resource)
  {
    Date earliestDate = null;
    foreach (OnlineContainerItem/*!(?)*/ item ; resource.getItems()) {
      if (item.getExpiresOn() !is null) {
        earliestDate = earliestDate.after(item.getExpiresOn()) ? item.getExpiresOn() : earliestDate is null ? item.getExpiresOn() : earliestDate;
      }
    }
    return earliestDate;
  }
  
  public void expireAllFeeds()
  {
    synchronized (this.feedExpiryMonitor)
    {
      foreach (String url ; this.feedExpiryMonitor.keySet()) {
        this.feedExpiryMonitor.put(url, new Date());
      }
    }
  }
  
  public void shutdownCaches()
  {
    this.technicalMetadataCache.shutdown();
    this.thumbnailCache.shutdown();
  }
  
  public void removePersistentCaches()
  {
    this.technicalMetadataCache.evictAll();
  }
  
  private Date getUserDefinedExpiryDate()
  {
    Calendar cal = new GregorianCalendar();
    cal.setTime(new Date());
    cal.add(10, Configuration.getOnlineFeedExpiryInterval().intValue());
    return cal.getTime();
  }
  
  private void storeResourceExpiryDate(String feedUrl, OnlineResourceContainer/*!(?, ?)*/ resource)
  {
    synchronized (this.feedExpiryMonitor)
    {
      Date newExpiryDate = getUserDefinedExpiryDate();
      this.feedExpiryMonitor.put(feedUrl, newExpiryDate);
      if (resource !is null)
      {
        Date itemExpiryDate = getEarliestItemExpiryDate(resource);
        log.debug_(String.format("Resource %s will expire in the cache on %s", cast(Object[])[ feedUrl, (itemExpiryDate !is null) && (itemExpiryDate.before(newExpiryDate)) ? itemExpiryDate : newExpiryDate ]));
      }
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.OnlineLibraryManager
 * JD-Core Version:    0.7.0.1
 */