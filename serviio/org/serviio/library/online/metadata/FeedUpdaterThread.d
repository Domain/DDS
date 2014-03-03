module org.serviio.library.online.metadata.FeedUpdaterThread;

import java.lang;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.local.metadata.AudioMetadata;
import org.serviio.library.local.metadata.ImageMetadata;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.serviio.library.local.service.SearchService;
import org.serviio.library.metadata.AbstractLibraryCheckerThread;
import org.serviio.library.metadata.FFmpegMetadataRetriever;
import org.serviio.library.metadata.ImageMetadataRetriever;
import org.serviio.library.metadata.ItemMetadata;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.AbstractUrlExtractor;
import org.serviio.library.online.CannotRetrieveThumbnailException;
import org.serviio.library.online.ContentURLContainer;
import org.serviio.library.online.OnlineLibraryManager;
import org.serviio.library.online.service.OnlineRepositoryService;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.util.HttpClient;
import org.serviio.util.Tupple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FeedUpdaterThread : AbstractLibraryCheckerThread
{
    private static Logger log;
    private static immutable int FEED_UPDATER_CHECK_INTERVAL = 1;
    private static immutable int FEER_PARSE_RETRY_COUNT = 2;
    private OnlineLibraryManager onlineManager;
    private Map!(Long, Integer) retryCounter = new HashMap();

    static this()
    {
        log = LoggerFactory.getLogger!(FeedUpdaterThread);
    }

    public this(OnlineLibraryManager onlineManager)
    {
        this.onlineManager = onlineManager;
    }

    override public void run()
    {
        log.info("Started looking for information about online resources");
        this.workerRunning = true;
        while (this.workerRunning)
        {
            log.debug_("Checking for new and expired online resources");
            this.searchingForFiles = true;
            List!(OnlineRepository) repositories = OnlineRepositoryService.getAllRepositories();
            foreach (OnlineRepository repository ; repositories) {
                try
                {
                    if ((this.workerRunning) && (repository.isEnabled()) && (OnlineRepositoryService.getRepository(repository.getId()) !is null))
                    {
                        Tupple/*!(OnlineResourceContainer!(?, ?), List!(? : OnlineItem))*/ parsedResource = getOnlineItems(repository);
                        Iterator/*!(? : OnlineItem)*/ it = (cast(List)parsedResource.getValueB()).iterator();
                        feedParsedSuccessfully(repository.getId());
                        while ((this.workerRunning) && (it.hasNext()))
                        {
                            OnlineItem feedItem = cast(OnlineItem)it.next();
                            try
                            {
                                bool updated = false;
                                if (this.workerRunning) {
                                    updated = retrieveTechnicalMetadata(feedItem);
                                }
                                if (this.workerRunning) {
                                    try
                                    {
                                        this.onlineManager.findThumbnail(feedItem.getThumbnail(), feedItem.getUserAgent());
                                    }
                                    catch (CannotRetrieveThumbnailException e)
                                    {
                                        log.warn("An error occured while retrieving thumbnail, will remove it from the item and will continue", e);

                                        feedItem.setThumbnail(null);
                                    }
                                }
                                if (updated)
                                {
                                    SearchService.makeOnlineSearchable(feedItem, cast(OnlineResourceContainer)parsedResource.getValueA(), repository);


                                    notifyListenersUpdate(feedItem.getType(), "Online item");
                                }
                            }
                            catch (IOException e)
                            {
                                log.warn(String.format("Failed to retrieve online item information for %s. It might not play.", cast(Object[])[ feedItem.getContentUrl().toString() ]), e);
                            }
                            catch (Exception e)
                            {
                                log.warn("An error occured while scanning for online item information, will remove the item from the feed and will continue", e);

                                it.remove();
                            }
                        }
                    }
                }
                catch (MissingPluginException e)
                {
                    log.warn(String.format("An error occured while trying to parse an online resouce requiring a plugin, provide the plugin or remove the resource: %s", cast(Object[])[ e.getMessage() ]));
                }
                catch (OnlineResourceParseException e)
                {
                    bool retry = retryFeedParsing(repository.getId());
                    if (retry)
                    {
                        log.warn(String.format("An error occured while parsing the online resource %s, will try again soon: %s", cast(Object[])[ repository.getRepositoryUrl().toString(), e.getMessage() ]), e);
                    }
                    else
                    {
                        log.warn(String.format("An error occured while parsing the online resource %s, waiting for expiry time to try again: %s", cast(Object[])[ repository.getRepositoryUrl().toString(), e.getMessage() ]), e);
                        this.onlineManager.storeExpiryDateForFailedResource(repository.getRepositoryUrl(), repository.getId());
                    }
                }
                catch (Exception e)
                {
                    log.warn("An unexpected error occured while parsing the online resource, will continue", e);
                }
            }
            this.searchingForFiles = false;
            try
            {
                if ((this.workerRunning) && (!this.dontSleep))
                {
                    this.isSleeping = true;
                    Thread.sleep(60000L);
                    this.isSleeping = false;
                }
                else
                {
                    this.dontSleep = false;
                }
            }
            catch (InterruptedException e)
            {
                this.dontSleep = false;
                this.isSleeping = false;
            }
        }
        log.info("Finished looking for online resources information");
    }

    private Tupple/*!(OnlineResourceContainer!(?, ?), List!(? : OnlineItem))*/ getOnlineItems(OnlineRepository repository)
    {
        if ((repository.getRepoType() == OnlineRepositoryType.FEED) || (repository.getRepoType() == OnlineRepositoryType.WEB_RESOURCE))
        {
            OnlineResourceContainer/*!(?, ?)*/ resource = this.onlineManager.findResourceInCacheOrParse(repository);
            List/*!(? : OnlineItem)*/ items = resource !is null ? resource.getItems() : new ArrayList();
            return new Tupple(resource, items);
        }
        SingleURLItem item = this.onlineManager.findSingleURLItemInCacheOrParse(repository);
        List/*!(? : OnlineItem)*/ items = item is null ? new ArrayList() : Collections.singletonList(item);
        return new Tupple(null, items);
    }

    private bool retrieveTechnicalMetadata(OnlineItem onlineItem)
    {
        bool updated = false;
        if ((!onlineItem.isCompletelyLoaded()) && (onlineItem.isValidEssence()))
        {
            TechnicalMetadata existingMetadata = this.onlineManager.findTechnicalMetadata(onlineItem.getCacheKey());
            if (existingMetadata !is null)
            {
                onlineItem.setTechnicalMD(existingMetadata.clone());
                updated = true;
            }
            else
            {
                if ((onlineItem.getTechnicalMD().getFileSize() is null) && (!onlineItem.isLive())) {
                    try
                    {
                        URL contentUrl = new URL(onlineItem.getContentUrl());
                        log.debug_("Retrieving file size from the URL connection");
                        onlineItem.getTechnicalMD().setFileSize(new Long(HttpClient.getContentSize(contentUrl).intValue()));
                        updated = true;
                    }
                    catch (MalformedURLException e) {}
                }
                if (onlineItem.getType() == MediaFileType.VIDEO)
                {
                    VideoMetadata md = new VideoMetadata();
                    log.debug_(String.format("Retrieving information about the video stream '%s'", cast(Object[])[ onlineItem.getTitle() ]));
                    retrieveMetadata(md, onlineItem);
                    onlineItem.getTechnicalMD().setAudioBitrate(md.getAudioBitrate());
                    onlineItem.getTechnicalMD().setAudioCodec(md.getAudioCodec());
                    onlineItem.getTechnicalMD().setAudioStreamIndex(md.getAudioStreamIndex());
                    onlineItem.getTechnicalMD().setBitrate(md.getBitrate());
                    onlineItem.getTechnicalMD().setChannels(md.getChannels());
                    if ((!onlineItem.isLive()) && (onlineItem.getTechnicalMD().getDuration() is null) && (md.getDuration() !is null)) {
                        onlineItem.getTechnicalMD().setDuration(new Long(md.getDuration().intValue()));
                    }
                    onlineItem.getTechnicalMD().setFps(md.getFps());
                    onlineItem.getTechnicalMD().setHeight(md.getHeight());
                    onlineItem.getTechnicalMD().setSamplingRate(md.getFrequency());
                    onlineItem.getTechnicalMD().setVideoBitrate(md.getVideoBitrate());
                    onlineItem.getTechnicalMD().setVideoCodec(md.getVideoCodec());
                    onlineItem.getTechnicalMD().setVideoContainer(md.getContainer());
                    onlineItem.getTechnicalMD().setVideoStreamIndex(md.getVideoStreamIndex());
                    onlineItem.getTechnicalMD().setWidth(md.getWidth());
                    onlineItem.getTechnicalMD().setFtyp(md.getFtyp());
                    onlineItem.getTechnicalMD().setH264Levels(md.getH264Levels());
                    onlineItem.getTechnicalMD().setH264Profile(md.getH264Profile());
                    onlineItem.getTechnicalMD().setSar(md.getSar());
                    storeTechnicalMetadataToCache(onlineItem);
                    updated = true;
                }
                else if (onlineItem.getType() == MediaFileType.AUDIO)
                {
                    AudioMetadata md = new AudioMetadata();
                    log.debug_("Retrieving information about the audio stream");
                    retrieveMetadata(md, onlineItem);
                    onlineItem.getTechnicalMD().setAudioContainer(md.getContainer());
                    onlineItem.getTechnicalMD().setBitrate(md.getBitrate());
                    if ((!onlineItem.isLive()) && (onlineItem.getTechnicalMD().getDuration() is null) && (md.getDuration() !is null)) {
                        onlineItem.getTechnicalMD().setDuration(new Long(md.getDuration().intValue()));
                    }
                    onlineItem.getTechnicalMD().setSamplingRate(md.getSampleFrequency());
                    onlineItem.getTechnicalMD().setChannels(md.getChannels());
                    storeTechnicalMetadataToCache(onlineItem);
                    updated = true;
                }
                else if (onlineItem.getType() == MediaFileType.IMAGE)
                {
                    ImageMetadata md = new ImageMetadata();
                    log.debug_("Retrieving information about the online image");
                    retrieveMetadata(md, onlineItem);
                    onlineItem.getTechnicalMD().setImageContainer(md.getContainer());
                    onlineItem.getTechnicalMD().setWidth(md.getWidth());
                    onlineItem.getTechnicalMD().setHeight(md.getHeight());
                    onlineItem.getTechnicalMD().setChromaSubsampling(md.getChromaSubsampling());
                    storeTechnicalMetadataToCache(onlineItem);
                    updated = true;
                }
            }
        }
        else if ((!onlineItem.isCompletelyLoaded()) && (!onlineItem.isValidEssence()))
        {
            log.debug_(String.format("Skipping retrieving technical metadata for item %s, because its essence is invalid.", cast(Object[])[ onlineItem.getTitle() ]));
        }
        return updated;
    }

    private void retrieveMetadata(ItemMetadata md, OnlineItem onlineItem)
    {
        bool run = true;
        int counter = 0;
        while (run) {
            try
            {
                if (( cast(ImageMetadata)md !is null )) {
                    ImageMetadataRetriever.retrieveImageMetadata(cast(ImageMetadata)md, onlineItem.getContentUrl(), false);
                } else {
                    FFmpegMetadataRetriever.retrieveOnlineMetadata(md, onlineItem.getContentUrl(), onlineItem.deliveryContext());
                }
                run = false;
            }
            catch (InvalidMediaFormatException e)
            {
                if ((( cast(OnlineContainerItem)onlineItem !is null )) && ((cast(OnlineContainerItem)onlineItem).isExpiresImmediately()) && (counter == 0))
                {
                    OnlineContainerItem/*!(?)*/ containerItem = cast(OnlineContainerItem)onlineItem;
                    counter++;
                    log.debug_("Cannot get information about the URL, it might have expired already. Trying again.");
                    try
                    {
                        ContentURLContainer container = AbstractUrlExtractor.extractItemUrl(containerItem.getPlugin(), containerItem);
                        if (container !is null) {
                            containerItem.applyContentUrlContainer(container, containerItem.getPlugin());
                        }
                    }
                    catch (Throwable t)
                    {
                        log.debug_(String.format("Unexpected error during url extractor plugin invocation (%s) for item %s: %s", cast(Object[])[ containerItem.getPlugin().getExtractorName(), containerItem.getTitle(), t.getMessage() ]), e);

                        markOnlineItemAsInvalidEssence(onlineItem);
                    }
                }
                else
                {
                    markOnlineItemAsInvalidEssence(onlineItem);
                    throw new IOException(e);
                }
            }
        }
    }

    private void markOnlineItemAsInvalidEssence(OnlineItem onlineItem)
    {
        log.debug_(String.format("Marking online item %s as 'invalid essence'", cast(Object[])[ onlineItem.getTitle() ]));
        onlineItem.setValidEssence(false);
    }

    private void storeTechnicalMetadataToCache(OnlineItem onlineItem)
    {
        this.onlineManager.storeTechnicalMetadata(onlineItem.getCacheKey(), onlineItem.getTechnicalMD().clone());
    }

    private bool retryFeedParsing(Long repositoryId)
    {
        Integer currentRetryCount = cast(Integer)this.retryCounter.get(repositoryId);
        if (currentRetryCount is null)
        {
            this.retryCounter.put(repositoryId, Integer.valueOf(2));
            return true;
        }
        if (currentRetryCount.intValue() < 1) {
            return false;
        }
        this.retryCounter.put(repositoryId, Integer.valueOf(currentRetryCount.intValue() - 1));
        return true;
    }

    private void feedParsedSuccessfully(Long repositoryId)
    {
        this.retryCounter.remove(repositoryId);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.metadata.FeedUpdaterThread
* JD-Core Version:    0.7.0.1
*/