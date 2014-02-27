module org.serviio.library.local.service.SearchService;

import java.util.List;
import org.serviio.library.entities.Image;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.Repository;
import org.serviio.library.entities.Series;
import org.serviio.library.entities.Video;
import org.serviio.library.local.metadata.AudioMetadata;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.online.metadata.OnlineContainerItem;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.library.online.metadata.OnlineResourceContainer;
import org.serviio.library.search.SearchIndexer;
import org.serviio.library.search.SearchIndexer:SearchCategory;
import org.serviio.library.search.SearchManager;
import org.serviio.library.search.SearchMetadata;
import org.serviio.util.Tupple;

public class SearchService
{
    public static void makeVideoSearchable(Long mediaItemId, VideoMetadata metadata, Video video, Repository repository, Series series, Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy)
    {
        makeSearchable(SearchMetadataFactory.videoMetadata(mediaItemId, metadata, video, repository, series, folderHierarchy), false);
    }

    public static void makeVideoUnsearchable(Long mediaItemId, Video video)
    {
        makeUnsearchable(SearchMetadataFactory.videoIndexIds(mediaItemId, video));
    }

    public static void makeAudioSearchable(Long mediaItemId, AudioMetadata metadata, MusicTrack song, Repository repository, Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy)
    {
        makeSearchable(SearchMetadataFactory.audioMetadata(mediaItemId, metadata, song, repository, folderHierarchy), false);
    }

    public static void makeAudioUnsearchable(Long mediaItemId, MusicTrack song)
    {
        makeUnsearchable(SearchMetadataFactory.audioIndexIds(mediaItemId, song));
    }

    public static void makeImageSearchable(Long mediaItemId, Image image, Repository repository, Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy)
    {
        makeSearchable(SearchMetadataFactory.imageMetadata(mediaItemId, image, repository, folderHierarchy), false);
    }

    public static void makeImageUnsearchable(Long mediaItemId, Image image)
    {
        makeUnsearchable(SearchMetadataFactory.imageIndexIds(mediaItemId, image));
    }

    public static void makeOnlineSearchable(OnlineItem item, OnlineResourceContainer/*!(? : OnlineContainerItem!(?), ?)*/ container, OnlineRepository repo)
    {
        makeSearchable(SearchMetadataFactory.onlineMetadata(item, container, repo), true);
    }

    public static void makeOnlineUnsearchable(Long onlineRepositoryId)
    {
        SearchManager.getInstance().onlineIndexer().metadataRemoved("onlineRepoId", onlineRepositoryId.toString());
    }

    private static void makeSearchable(List!(SearchMetadata) smd, bool online)
    {
        foreach (SearchMetadata md ; smd) {
            if (!online) {
                SearchManager.getInstance().localIndexer().metadataAdded(md);
            } else {
                SearchManager.getInstance().onlineIndexer().metadataAdded(md);
            }
        }
    }

    private static void makeUnsearchable(List!(Tupple!(SearchIndexer.SearchCategory, Long)) idsToRemove)
    {
        foreach (Tupple!(SearchIndexer.SearchCategory, Long) pair ; idsToRemove) {
            SearchManager.getInstance().localIndexer().metadataRemoved(cast(SearchIndexer.SearchCategory)pair.getValueA(), cast(Long)pair.getValueB());
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.service.SearchService
* JD-Core Version:    0.7.0.1
*/