module org.serviio.library.local.service.VideoService;

import java.lang;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.serviio.config.Configuration;
import org.serviio.db.dao.DAOFactory;
import org.serviio.library.dao.CoverImageDAO;
import org.serviio.library.dao.MetadataDescriptorDAO;
import org.serviio.library.dao.PersonDAO;
import org.serviio.library.dao.SeriesDAO;
import org.serviio.library.dao.VideoDAO;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MetadataDescriptor;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.entities.Repository;
import org.serviio.library.entities.Series;
import org.serviio.library.entities.Video;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.local.metadata.MPAARating;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.local.metadata.extractor.MetadataFile;
import org.serviio.library.search.SearchIndexer;
import org.serviio.library.search.SearchIndexer:SearchCategory;
import org.serviio.library.search.SearchManager;
import org.serviio.library.service.Service;
import org.serviio.util.DateUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.Tupple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VideoService : Service
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(VideoService);
    }

    public static void addVideoToLibrary(VideoMetadata metadata, Repository repository)
    {
        if (metadata !is null)
        {
            log.debug_(java.lang.String.format("Adding video into database: %s", cast(Object[])[ metadata.getTitle() ]));

            Tupple!(Long, List!(Tupple!(Long, String))) folderHierarchy = FolderService.createOrReadFolder(repository, metadata.getFilePath());

            Long genreId = GenreService.findOrCreateGenre(metadata.getGenre());

            Series series = findOrCreateSeries(metadata.getSeriesName(), metadata.getSeriesCoverImage());

            Long coverImageId = CoverImageService.createCoverImage(metadata.getCoverImage(), null);

            Video video = new Video(metadata.getTitle(), metadata.getContainer(), new File(metadata.getFilePath()).getName(), metadata.getFilePath(), Long.valueOf(metadata.getFileSize()), cast(Long)folderHierarchy.getValueA(), repository.getId(), metadata.getDate());

            video.setDuration(metadata.getDuration());
            video.setGenreId(genreId);
            video.setThumbnailId(coverImageId);
            video.setDescription(metadata.getDescription());
            video.setBitrate(metadata.getBitrate());
            video.setAudioBitrate(metadata.getAudioBitrate());
            video.setWidth(metadata.getWidth());
            video.setHeight(metadata.getHeight());
            video.setRating(metadata.getMPAARating());
            video.setEpisodeNumber(metadata.getEpisodeNumber());
            video.setSeasonNumber(metadata.getSeasonNumber());
            video.setSeriesId(series !is null ? series.getId() : null);
            video.setAudioCodec(metadata.getAudioCodec());
            video.setVideoCodec(metadata.getVideoCodec());
            video.setAudioStreamIndex(metadata.getAudioStreamIndex());
            video.setVideoStreamIndex(metadata.getVideoStreamIndex());
            video.setChannels(metadata.getChannels());
            video.setFps(metadata.getFps());
            video.setFrequency(metadata.getFrequency());
            video.setContentType(metadata.getContentType());
            video.setTimestampType(metadata.getTimestampType());
            video.setH264Profile(metadata.getH264Profile());
            video.setH264Levels(metadata.getH264Levels());
            video.setFtyp(metadata.getFtyp());
            video.setSar(metadata.getSar());
            video.setVideoFourCC(metadata.getVideoFourCC());
            video.setOnlineIdentifiers(metadata.getOnlineIdentifiers());
            video.getEmbeddedSubtitles().addAll(metadata.getEmbeddedSubtitles());
            video.setReleaseYear(Integer.valueOf(DateUtils.getYear(video.getDate())));
            video.setDirty(metadata.isDirty());

            Long mediaItemId = Long.valueOf(DAOFactory.getVideoDAO().create(video));
            if (metadata.getDirectors() !is null) {
                foreach (String director ; metadata.getDirectors()) {
                    DAOFactory.getPersonDAO().addPersonToMedia(director, RoleType.DIRECTOR, mediaItemId);
                }
            }
            if (metadata.getProducers() !is null) {
                foreach (String producer ; metadata.getProducers()) {
                    DAOFactory.getPersonDAO().addPersonToMedia(producer, RoleType.PRODUCER, mediaItemId);
                }
            }
            if (metadata.getActors() !is null) {
                foreach (String actor ; metadata.getActors()) {
                    DAOFactory.getPersonDAO().addPersonToMedia(actor, RoleType.ACTOR, mediaItemId);
                }
            }
            foreach (MetadataFile metadataFile ; metadata.getMetadataFiles())
            {
                MetadataDescriptor metadataDescriptor = new MetadataDescriptor(metadataFile.getExtractorType(), mediaItemId, metadataFile.getLastUpdatedDate(), metadataFile.getIdentifier());

                DAOFactory.getMetadataDescriptorDAO().create(metadataDescriptor);
            }
            SearchService.makeVideoSearchable(mediaItemId, metadata, video, repository, series, folderHierarchy);
        }
        else
        {
            log.warn("Video cannot be added to the library because no metadata has been provided");
        }
    }

    public static void removeVideoFromLibrary(Long mediaItemId)
    {
        Video video = getVideo(mediaItemId);
        if (video !is null)
        {
            log.debug_(java.lang.String.format("Removing video from database: %s", cast(Object[])[ video.getTitle() ]));


            DAOFactory.getPersonDAO().removeAllPersonsFromMedia(mediaItemId);


            PlaylistService.removeMediaItemFromPlaylists(mediaItemId);


            DAOFactory.getMetadataDescriptorDAO().removeMetadataDescriptorsForMedia(mediaItemId);


            DAOFactory.getVideoDAO().delete_(video.getId());


            CoverImageService.removeCoverImage(video.getThumbnailId());


            removeSeries(video.getSeriesId());


            FolderService.removeFolderAndItsParents(video.getFolderId(), SearchManager.getInstance().localIndexer());


            GenreService.removeGenre(video.getGenreId());

            SearchService.makeVideoUnsearchable(mediaItemId, video);
        }
        else
        {
            log.warn("Video cannot be removed from the library because it cannot be found");
        }
    }

    public static void updateVideoInLibrary(VideoMetadata metadata, Long mediaItemId)
    {
        if (metadata !is null)
        {
            log.debug_(java.lang.String.format("Updating video in database: %s", cast(Object[])[ metadata.getTitle() ]));

            Video video = getVideo(mediaItemId);


            Long genreId = GenreService.findOrCreateGenre(metadata.getGenre());


            Series series = findOrCreateSeries(metadata.getSeriesName(), metadata.getSeriesCoverImage());


            Long coverImageId = CoverImageService.createCoverImage(metadata.getCoverImage(), null);


            Video updatedVideo = new Video(metadata.getTitle(), metadata.getContainer(), video.getFileName(), metadata.getFilePath(), Long.valueOf(metadata.getFileSize()), video.getFolderId(), video.getRepositoryId(), metadata.getDate());

            updatedVideo.setId(video.getId());
            updatedVideo.setDuration(metadata.getDuration());
            updatedVideo.setGenreId(genreId);
            updatedVideo.setThumbnailId(coverImageId);
            updatedVideo.setDescription(metadata.getDescription());
            updatedVideo.setBitrate(metadata.getBitrate());
            updatedVideo.setAudioBitrate(metadata.getAudioBitrate());
            updatedVideo.setWidth(metadata.getWidth());
            updatedVideo.setHeight(metadata.getHeight());
            updatedVideo.setRating(metadata.getMPAARating());
            updatedVideo.setEpisodeNumber(metadata.getEpisodeNumber());
            updatedVideo.setSeasonNumber(metadata.getSeasonNumber());
            updatedVideo.setSeriesId(series !is null ? series.getId() : null);
            updatedVideo.setAudioCodec(metadata.getAudioCodec());
            updatedVideo.setVideoCodec(metadata.getVideoCodec());
            updatedVideo.setAudioStreamIndex(metadata.getAudioStreamIndex());
            updatedVideo.setVideoStreamIndex(metadata.getVideoStreamIndex());
            updatedVideo.setChannels(metadata.getChannels());
            updatedVideo.setFps(metadata.getFps());
            updatedVideo.setFrequency(metadata.getFrequency());
            updatedVideo.setContentType(metadata.getContentType());
            updatedVideo.setTimestampType(metadata.getTimestampType());
            updatedVideo.setH264Profile(metadata.getH264Profile());
            updatedVideo.setH264Levels(metadata.getH264Levels());
            updatedVideo.setFtyp(metadata.getFtyp());
            updatedVideo.setSar(metadata.getSar());
            updatedVideo.setVideoFourCC(metadata.getVideoFourCC());
            updatedVideo.setOnlineIdentifiers(metadata.getOnlineIdentifiers());
            updatedVideo.getEmbeddedSubtitles().addAll(metadata.getEmbeddedSubtitles());
            updatedVideo.setReleaseYear(Integer.valueOf(DateUtils.getYear(updatedVideo.getDate())));

            updatedVideo.setDirty(metadata.isDirty());

            DAOFactory.getVideoDAO().update(updatedVideo);



            List!(Long) originalDirectorRoles = DAOFactory.getPersonDAO().getRoleIDsForMediaItem(RoleType.DIRECTOR, mediaItemId);
            List!(Long) originalProducerRoles = DAOFactory.getPersonDAO().getRoleIDsForMediaItem(RoleType.PRODUCER, mediaItemId);
            List!(Long) originalActorRoles = DAOFactory.getPersonDAO().getRoleIDsForMediaItem(RoleType.ACTOR, mediaItemId);

            List!(Long) newDirectorRoles = new ArrayList();
            List!(Long) newProducerRoles = new ArrayList();
            List!(Long) newActorRoles = new ArrayList();
            if (metadata.getDirectors() !is null) {
                foreach (String director ; metadata.getDirectors())
                {
                    Long newRole = DAOFactory.getPersonDAO().addPersonToMedia(director, RoleType.DIRECTOR, mediaItemId);
                    newDirectorRoles.add(newRole);
                }
            }
            if (metadata.getProducers() !is null) {
                foreach (String producer ; metadata.getProducers())
                {
                    Long newRole = DAOFactory.getPersonDAO().addPersonToMedia(producer, RoleType.PRODUCER, mediaItemId);
                    newProducerRoles.add(newRole);
                }
            }
            if (metadata.getActors() !is null) {
                foreach (String actor ; metadata.getActors())
                {
                    Long newRole = DAOFactory.getPersonDAO().addPersonToMedia(actor, RoleType.ACTOR, mediaItemId);
                    newActorRoles.add(newRole);
                }
            }
            DAOFactory.getMetadataDescriptorDAO().removeMetadataDescriptorsForMedia(mediaItemId);
            foreach (MetadataFile metadataFile ; metadata.getMetadataFiles())
            {
                MetadataDescriptor metadataDescriptor = new MetadataDescriptor(metadataFile.getExtractorType(), mediaItemId, metadataFile.getLastUpdatedDate(), metadataFile.getIdentifier());

                DAOFactory.getMetadataDescriptorDAO().create(metadataDescriptor);
            }
            GenreService.removeGenre(video.getGenreId());
            CoverImageService.removeCoverImage(video.getThumbnailId());
            removeSeries(video.getSeriesId());


            originalDirectorRoles.removeAll(newDirectorRoles);
            originalProducerRoles.removeAll(newProducerRoles);
            originalActorRoles.removeAll(newActorRoles);
            DAOFactory.getPersonDAO().removePersonsAndRoles(originalDirectorRoles);
            DAOFactory.getPersonDAO().removePersonsAndRoles(originalProducerRoles);
            DAOFactory.getPersonDAO().removePersonsAndRoles(originalActorRoles);

            SearchService.makeVideoSearchable(mediaItemId, metadata, updatedVideo, RepositoryService.getRepository(updatedVideo.getRepositoryId()), series, FolderService.getFolderHierarchy(updatedVideo.getFolderId()));
        }
        else
        {
            log.warn("Video cannot be updated in the library because no metadata has been provided");
        }
    }

    public static Video getVideo(Long videoId)
    {
        if (videoId !is null) {
            return cast(Video)DAOFactory.getVideoDAO().read(videoId);
        }
        return null;
    }

    public static Series getSeries(Long seriesId)
    {
        if (seriesId !is null) {
            return cast(Series)DAOFactory.getSeriesDAO().read(seriesId);
        }
        return null;
    }

    public static List!(Video) getListOfVideosForFolder(Long folderId, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForFolder(folderId, accessGroup, startingIndex, requestedCount);
    }

    public static int getNumberOfVideosForFolder(Long folderId, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForFolderCount(folderId, accessGroup);
    }

    public static List!(Video) getListOfVideosForPlaylist(Long playlistId, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForPlaylist(playlistId, accessGroup, startingIndex, requestedCount);
    }

    public static int getNumberOfVideosForPlaylist(Long playlistId, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForPlaylistCount(playlistId, accessGroup);
    }

    public static List!(Video) getListOfVideosForGenre(Long genreId, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForGenre(genreId, accessGroup, startingIndex, requestedCount, Configuration.isBrowseFilterOutSeries());
    }

    public static int getNumberOfVideosForGenre(Long genreId, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForGenreCount(genreId, accessGroup, Configuration.isBrowseFilterOutSeries());
    }

    public static List!(Video) getListOfVideosForPerson(Long personId, RoleType role, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForPerson(personId, role, accessGroup, startingIndex, requestedCount);
    }

    public static int getNumberOfVideosForPerson(Long personId, RoleType role, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForPersonCount(personId, role, accessGroup);
    }

    public static List!(Series) getListOfSeries(int startingIndex, int requestedCount)
    {
        return DAOFactory.getSeriesDAO().retrieveSeries(startingIndex, requestedCount);
    }

    public static int getNumberOfSeries()
    {
        return DAOFactory.getSeriesDAO().getSeriesCount();
    }

    public static List!(Integer) getListOfSeasonsForSeries(Long seriesId, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getSeriesDAO().retrieveSeasonsForSeries(seriesId, accessGroup, startingIndex, requestedCount);
    }

    public static int getNumberOfSeasonsForSeries(Long seriesId, AccessGroup accessGroup)
    {
        return DAOFactory.getSeriesDAO().getSeasonsForSeriesCount(seriesId, accessGroup);
    }

    public static List!(Video) getListOfEpisodesForSeriesSeason(Long seriesId, Integer season, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForSeriesSeason(seriesId, season, accessGroup, startingIndex, requestedCount);
    }

    public static int getNumberOfEpisodesForSeriesSeason(Long seriesId, Integer season, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForSeriesSeasonCount(seriesId, season, accessGroup);
    }

    public static List!(String) getListOfVideoInitials(AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideoInitials(accessGroup, startingIndex, requestedCount, Configuration.isBrowseFilterOutSeries());
    }

    public static int getNumberOfVideoInitials(AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveVideoInitialsCount(accessGroup, Configuration.isBrowseFilterOutSeries());
    }

    public static List!(Video) getListOfVideosForInitial(String initial, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForInitial(initial, accessGroup, startingIndex, requestedCount, Configuration.isBrowseFilterOutSeries());
    }

    public static int getNumberOfVideosForInitial(String initial, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveVideosForInitialCount(initial, accessGroup, Configuration.isBrowseFilterOutSeries());
    }

    public static List!(Video) getListOfAllVideos(AccessGroup userProfile, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideos(0, userProfile, startingIndex, requestedCount);
    }

    public static int getNumberOfAllVideos(AccessGroup userProfile)
    {
        return DAOFactory.getVideoDAO().retrieveVideosCount(0, userProfile);
    }

    public static List!(Video) getListOfMovieVideos(AccessGroup userProfile, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveVideos(2, userProfile, startingIndex, requestedCount);
    }

    public static int getNumberOfMovieVideos(AccessGroup userProfile)
    {
        return DAOFactory.getVideoDAO().retrieveVideosCount(2, userProfile);
    }

    public static List!(Video) getListOfLastViewedVideos(int maxRequested, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveLastViewedVideos(maxRequested, accessGroup, startingIndex, requestedCount);
    }

    public static int getNumberOfLastViewedVideos(int maxRequested, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveLastViewedVideosCount(maxRequested, accessGroup);
    }

    public static List!(Video) getListOfLastAddedVideos(int maxRequested, AccessGroup accessGroup, int startingIndex, int requestedCount)
    {
        return DAOFactory.getVideoDAO().retrieveLastAddedVideos(maxRequested, accessGroup, startingIndex, requestedCount);
    }

    public static int getNumberOfLastAddedVideos(int maxRequested, AccessGroup userProfile)
    {
        return DAOFactory.getVideoDAO().retrieveLastAddedVideosCount(maxRequested, userProfile);
    }

    public static Map!(Long, Integer) getLastViewedEpisode(Long seriesId)
    {
        return DAOFactory.getVideoDAO().retrieveLastViewedEpisode(seriesId);
    }

    public static List!(Integer) getListOfVideosReleaseYears(AccessGroup accessGroup, int startIndex, int count)
    {
        return DAOFactory.getVideoDAO().retrieveVideoReleaseYears(accessGroup, startIndex, count, Configuration.isBrowseFilterOutSeries());
    }

    public static int getNumberOfVideosReleaseYears(AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveVideoReleaseYearsCount(accessGroup, Configuration.isBrowseFilterOutSeries());
    }

    public static List!(Video) getListOfVideosForReleaseYear(int releaseYear, AccessGroup accessGroup, int startIndex, int count)
    {
        return DAOFactory.getVideoDAO().retrieveMoviesForReleaseYear(Integer.valueOf(releaseYear), accessGroup, startIndex, count);
    }

    public static int getNumberOfVideosForReleaseYear(int releaseYear, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveMoviesForReleaseYearCount(Integer.valueOf(releaseYear), accessGroup);
    }

    public static List!(MPAARating) getListOfRatings(AccessGroup accessGroup, int startIndex, int count)
    {
        return DAOFactory.getVideoDAO().retrieveMovieRatings(accessGroup, startIndex, count);
    }

    public static int getNumberOfRatings(AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveMovieRatingsCount(accessGroup);
    }

    public static List!(Video) getListOfVideosForRating(MPAARating rating, AccessGroup accessGroup, int startIndex, int count)
    {
        return DAOFactory.getVideoDAO().retrieveMoviesForRating(rating, accessGroup, startIndex, count);
    }

    public static int getNumberOfVideosForRating(MPAARating rating, AccessGroup accessGroup)
    {
        return DAOFactory.getVideoDAO().retrieveMoviesForRatingCount(rating, accessGroup);
    }

    public static Series findOrCreateSeries(String seriesName, ImageDescriptor thumbnail)
    {
        if (ObjectValidator.isNotEmpty(seriesName))
        {
            Series series = DAOFactory.getSeriesDAO().findSeriesByName(seriesName);
            if (series is null)
            {
                log.debug_(java.lang.String.format("Series %s not found, creating a new one", cast(Object[])[ seriesName ]));

                Long seriesThumbnailId = CoverImageService.createCoverImage(thumbnail, null);
                series = new Series(seriesName, null, seriesThumbnailId);
                Long id = Long.valueOf(DAOFactory.getSeriesDAO().create(series));
                series.setId(id);
                return series;
            }
            log.debug_(java.lang.String.format("Series %s found", cast(Object[])[ seriesName ]));
            if (series.getThumbnailId() is null)
            {
                Long seriesThumbnailId = CoverImageService.createCoverImage(thumbnail, null);
                if (seriesThumbnailId !is null)
                {
                    series.setThumbnailId(seriesThumbnailId);
                    log.debug_("Adding a new series thumbnail");
                    DAOFactory.getSeriesDAO().update(series);
                }
            }
            return series;
        }
        return null;
    }

    private static void removeSeries(Long seriesId)
    {
        if (seriesId !is null)
        {
            int numberOfEpisodes = DAOFactory.getSeriesDAO().getNumberOfEpisodes(seriesId);
            if (numberOfEpisodes == 0)
            {
                Series series = cast(Series)DAOFactory.getSeriesDAO().read(seriesId);
                DAOFactory.getSeriesDAO().delete_(seriesId);
                if ((series !is null) && (series.getThumbnailId() !is null)) {
                    DAOFactory.getCoverImageDAO().delete_(series.getThumbnailId());
                }
                SearchManager.getInstance().localIndexer().metadataRemoved(SearchCategory.SERIES, seriesId);
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.service.VideoService
* JD-Core Version:    0.7.0.1
*/