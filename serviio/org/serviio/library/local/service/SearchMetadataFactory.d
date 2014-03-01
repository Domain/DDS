module org.serviio.library.local.service.SearchMetadataFactory;

import java.util.ArrayList;
import java.util.List;
import org.serviio.library.entities.Image;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.Person;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.entities.Repository;
import org.serviio.library.entities.Series;
import org.serviio.library.entities.Video;
import org.serviio.library.local.ContentType;
import org.serviio.library.local.metadata.AudioMetadata;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.metadata.OnlineContainerItem;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.library.online.metadata.OnlineResourceContainer;
import org.serviio.library.online.metadata.SingleURLItem;
import org.serviio.library.search.AlbumArtistSearchMetadata;
import org.serviio.library.search.AlbumSearchMetadata;
import org.serviio.library.search.EpisodeSearchMetadata;
import org.serviio.library.search.FileSearchMetadata;
import org.serviio.library.search.FolderSearchMetadata;
import org.serviio.library.search.MovieSearchMetadata;
import org.serviio.library.search.MusicTrackSearchMetadata;
import org.serviio.library.search.OnlineContainerSearchMetadata;
import org.serviio.library.search.OnlineItemSearchMetadata;
import org.serviio.library.search.SearchIndexer:SearchCategory;
import org.serviio.library.search.SearchMetadata;
import org.serviio.library.search.SerieSearchMetadata;
import org.serviio.util.CollectionUtils;
import org.serviio.util.Tupple;

public class SearchMetadataFactory
{
    public static List!(SearchMetadata) videoMetadata(Long mediaItemId, VideoMetadata videoMD, Video video, Repository repository, Series series, Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy)
    {
        List!(SearchMetadata) allMetadata = new ArrayList();
        if (video.getContentType() == ContentType.MOVIE) {
            allMetadata.add(new MovieSearchMetadata(mediaItemId, video.getTitle(), video.getThumbnailId()));
        }
        if ((video.getContentType() == ContentType.EPISODE) && (series !is null))
        {
            allMetadata.add(new EpisodeSearchMetadata(mediaItemId, video.getSeasonNumber(), series.getId(), video.getTitle(), video.getThumbnailId(), series.getTitle()));

            allMetadata.add(new SerieSearchMetadata(series.getId(), series.getTitle(), series.getThumbnailId()));
        }
        allMetadata.add(new FileSearchMetadata(mediaItemId, video.getFileName(), repositoryTupple(repository), folderHierarchy(folderHierarchy), MediaFileType.VIDEO, video.getThumbnailId()));
        allMetadata.addAll(buildMetadataForFolders(MediaFileType.VIDEO, repository, folderHierarchy));

        return allMetadata;
    }

    public static List!(Tupple!(SearchCategory, Long)) videoIndexIds(Long mediaItemId, Video video)
    {
        List!(Tupple!(SearchCategory, Long)) allPairs = new ArrayList();
        if (video.getContentType() == ContentType.MOVIE) {
            allPairs.add(new Tupple(SearchCategory.MOVIES, mediaItemId));
        }
        if (video.getContentType() == ContentType.EPISODE) {
            allPairs.add(new Tupple(SearchCategory.EPISODES, mediaItemId));
        }
        allPairs.add(new Tupple(SearchCategory.FILES, mediaItemId));


        return allPairs;
    }

    public static List!(SearchMetadata) imageMetadata(Long mediaItemId, Image image, Repository repository, Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy)
    {
        List!(SearchMetadata) allMetadata = new ArrayList();

        allMetadata.add(new FileSearchMetadata(mediaItemId, image.getFileName(), repositoryTupple(repository), folderHierarchy(folderHierarchy), MediaFileType.IMAGE, image.getThumbnailId()));
        allMetadata.addAll(buildMetadataForFolders(MediaFileType.IMAGE, repository, folderHierarchy));

        return allMetadata;
    }

    public static List!(SearchMetadata) onlineMetadata(OnlineItem item, OnlineResourceContainer/*!(? : OnlineContainerItem!(?), ?)*/ container, OnlineRepository repository)
    {
        List!(SearchMetadata) allMetadata = new ArrayList();

        Long itemThumbnailId = (item.getThumbnail() !is null) ? item.getId() : null;
        if ( cast(SingleURLItem)item !is null )
        {
            allMetadata.add(new OnlineItemSearchMetadata(repository.getId(), item.getId(), item.getDisplayTitle(repository.getRepositoryName()), item.getType(), itemThumbnailId));
        }
        else
        {
            String containerTitle = container.getDisplayName(repository.getRepositoryName());
            allMetadata.add(new OnlineItemSearchMetadata(repository.getId(), item.getId(), item.getTitle(), containerTitle, item.getType(), itemThumbnailId));
            allMetadata.add(new OnlineContainerSearchMetadata(repository.getId(), containerTitle, item.getType(), null, repository.getId()));
        }
        return allMetadata;
    }

    public static List!(Tupple!(SearchCategory, Long)) imageIndexIds(Long mediaItemId, Image image)
    {
        List!(Tupple!(SearchCategory, Long)) allPairs = new ArrayList();

        allPairs.add(new Tupple(SearchCategory.FILES, mediaItemId));


        return allPairs;
    }

    public static List!(SearchMetadata) audioMetadata(Long mediaItemId, AudioMetadata audioMD, MusicTrack song, Repository repository, Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy)
    {
        List!(SearchMetadata) allMetadata = new ArrayList();

        Person albumArtist = cast(Person)CollectionUtils.getFirstItem(PersonService.getListOfPersonsForMusicAlbum(song.getAlbumId(), RoleType.ALBUM_ARTIST));
        if (albumArtist !is null) {
            allMetadata.add(new AlbumArtistSearchMetadata(albumArtist.getId(), albumArtist.getName(), albumArtist.getInitial(), CoverImageService.getPersonCoverArt(albumArtist.getId())));
        }
        allMetadata.add(new AlbumSearchMetadata(song.getAlbumId(), audioMD.getAlbum(), audioMD.getAlbumArtist(), CoverImageService.getMusicAlbumCoverArt(song.getAlbumId())));
        allMetadata.add(new MusicTrackSearchMetadata(mediaItemId, song.getAlbumId(), song.getTitle(), audioMD.getAlbum(), audioMD.getAlbumArtist(), song.getThumbnailId()));
        allMetadata.add(new FileSearchMetadata(mediaItemId, song.getFileName(), repositoryTupple(repository), folderHierarchy(folderHierarchy), MediaFileType.AUDIO, song.getThumbnailId()));
        allMetadata.addAll(buildMetadataForFolders(MediaFileType.AUDIO, repository, folderHierarchy));

        return allMetadata;
    }

    public static List!(Tupple!(SearchCategory, Long)) audioIndexIds(Long mediaItemId, MusicTrack song)
    {
        List!(Tupple!(SearchCategory, Long)) allPairs = new ArrayList();

        allPairs.add(new Tupple(SearchCategory.MUSIC_TRACKS, mediaItemId));
        allPairs.add(new Tupple(SearchCategory.FILES, mediaItemId));


        return allPairs;
    }

    private static List!(SearchMetadata) buildMetadataForFolders(MediaFileType fileType, Repository repository, Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy)
    {
        List!(SearchMetadata) allMetadata = new ArrayList();
        if ((repository !is null) && (folderHierarchy !is null))
        {
            List!(Tupple!(Long, String)) hierarchy = folderHierarchy(folderHierarchy);
            for (int i = 0; i < hierarchy.size(); i++)
            {
                List!(Tupple!(Long, String)) currentHierarchy = CollectionUtils.getSubList(hierarchy, 0, hierarchy.size() - i);
                Long leafFolderId = cast(Long)(cast(Tupple)currentHierarchy.get(currentHierarchy.size() - 1)).getValueA();
                allMetadata.add(new FolderSearchMetadata(repositoryTupple(repository), currentHierarchy, fileType, CoverImageService.getFolderCoverArt(leafFolderId, fileType)));
            }
        }
        return allMetadata;
    }

    private static Tupple!(Long, String) repositoryTupple(Repository repository)
    {
        if (repository !is null) {
            return new Tupple(repository.getId(), repository.getRepositoryName());
        }
        return null;
    }

    private static List!(Tupple!(Long, String)) folderHierarchy(Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy)
    {
        if (folderHierarchy !is null) {
            return cast(List)folderHierarchy.getValueB();
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.service.SearchMetadataFactory
* JD-Core Version:    0.7.0.1
*/