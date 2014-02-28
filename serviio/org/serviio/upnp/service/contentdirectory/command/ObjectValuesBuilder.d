module org.serviio.upnp.service.contentdirectory.command.ObjectValuesBuilder;

import java.util.HashMap;
import java.util.Map;
import org.serviio.db.entities.PersistedEntity;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Folder;
import org.serviio.library.entities.Genre;
import org.serviio.library.entities.Image;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.MusicAlbum;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.Person;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.entities.Playlist;
import org.serviio.library.entities.Repository;
import org.serviio.library.entities.Series;
import org.serviio.library.entities.Video;
import org.serviio.library.local.service.AudioService;
import org.serviio.library.local.service.CoverImageService;
import org.serviio.library.local.service.FolderService;
import org.serviio.library.local.service.GenreService;
import org.serviio.library.local.service.PersonService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.definition.ContainerNode;
import org.serviio.upnp.service.contentdirectory.definition.ContentDirectoryDefinitionFilter;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.util.CollectionUtils;
import org.serviio.util.DateUtils;

public class ObjectValuesBuilder
{
    public static Map!(ClassProperties, Object) buildObjectValues(PersistedEntity entity, String objectId, String parentId, ObjectType objectType, SearchCriteria searchCriteria, String title, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, bool disablePresentationSettings)
    {
        Map!(ClassProperties, Object) values = null;
        if (( cast(Folder)entity !is null ))
        {
            Long coverImageId = CoverImageService.getFolderCoverArt(entity.getId(), fileType);
            values = instantiateValuesForContainer(title, objectId, parentId, objectType, searchCriteria, accessGroup, coverImageId, disablePresentationSettings);
        }
        else if (( cast(Person)entity !is null ))
        {
            Person person = cast(Person)entity;
            Long thumbnailId = null;
            if (!person.getName().equals("Unknown")) {
                thumbnailId = CoverImageService.getPersonCoverArt(person.getId());
            }
            values = instantiateValuesForContainer(title, objectId, parentId, objectType, searchCriteria, accessGroup, thumbnailId, disablePresentationSettings);
        }
        else if (( cast(Playlist)entity !is null ))
        {
            values = instantiateValuesForContainer(title, objectId, parentId, objectType, searchCriteria, accessGroup, null, disablePresentationSettings);
        }
        else if (( cast(Genre)entity !is null ))
        {
            values = instantiateValuesForContainer(title, objectId, parentId, objectType, searchCriteria, accessGroup, null, disablePresentationSettings);
        }
        else if (( cast(Series)entity !is null ))
        {
            Series series = cast(Series)entity;
            values = instantiateValuesForContainer(title, objectId, parentId, objectType, searchCriteria, accessGroup, series.getThumbnailId(), disablePresentationSettings);
        }
        else if (( cast(MusicAlbum)entity !is null ))
        {
            MusicAlbum album = cast(MusicAlbum)entity;
            Long albumArtId = CoverImageService.getMusicAlbumCoverArt(album.getId());
            values = instantiateValuesForContainer(title, objectId, parentId, objectType, searchCriteria, accessGroup, albumArtId, disablePresentationSettings);
            Person albumArtist = cast(Person)CollectionUtils.getFirstItem(PersonService.getListOfPersonsForMusicAlbum(album.getId(), Person.RoleType.ALBUM_ARTIST));
            if (albumArtist !is null) {
                values.put(ClassProperties.ARTIST, albumArtist.getName());
            }
        }
        else if (( cast(Image)entity !is null ))
        {
            Image image = cast(Image)entity;
            values = instantiateValuesForItem(title, objectId, parentId, image, disablePresentationSettings);
            values.put(ClassProperties.DATE, DateUtils.formatISO8601YYYYMMDD(image.getDate()));
            values.put(ClassProperties.DESCRIPTION, image.getDescription());
            if (image.isLocalMedia()) {
                values.put(ClassProperties.ALBUM, FolderService.getFolder(image.getFolderId()).getName());
            }
        }
        else if (( cast(MusicTrack)entity !is null ))
        {
            MusicTrack track = cast(MusicTrack)entity;
            values = instantiateValuesForItem(title, objectId, parentId, track, disablePresentationSettings);
            values.put(ClassProperties.ALBUM, AudioService.getMusicAlbum(track.getAlbumId()));
            values.put(ClassProperties.GENRE, GenreService.getGenre(track.getGenreId()));
            if (track.isLocalMedia())
            {
                Person artist = cast(Person)CollectionUtils.getFirstItem(PersonService.getListOfPersonsForMediaItem(track.getId(), Person.RoleType.ARTIST));
                values.put(ClassProperties.CREATOR, artist);
                values.put(ClassProperties.ARTIST, artist);
            }
            values.put(ClassProperties.DATE, DateUtils.formatISO8601YYYYMMDD(track.getDate()));
            values.put(ClassProperties.ORIGINAL_TRACK_NUMBER, track.getTrackNumber());
            values.put(ClassProperties.DESCRIPTION, track.getDescription());
            values.put(ClassProperties.LIVE, Boolean.valueOf(track.isLive()));
        }
        else if (( cast(Video)entity !is null ))
        {
            Video video = cast(Video)entity;
            values = instantiateValuesForItem(title, objectId, parentId, video, disablePresentationSettings);
            values.put(ClassProperties.RATING, video.getRating());
            values.put(ClassProperties.DESCRIPTION, video.getDescription());
            values.put(ClassProperties.DATE, DateUtils.formatISO8601YYYYMMDD(video.getDate()));
            values.put(ClassProperties.LIVE, Boolean.valueOf(video.isLive()));
            values.put(ClassProperties.ONLINE_DB_IDENTIFIERS, video.getOnlineIdentifiers());
            values.put(ClassProperties.CONTENT_TYPE, video.getContentType());
            values.put(ClassProperties.SUBTITLES_URL, ResourceValuesBuilder.generateSubtitlesResource(video, rendererProfile));
            if (video.isLocalMedia()) {
                values.put(ClassProperties.GENRE, GenreService.getGenre(video.getGenreId()));
            }
        }
        else if (( cast(Repository)entity !is null ))
        {
            Long coverImageId = CoverImageService.getRepositoryCoverArt(entity.getId(), fileType);
            values = instantiateValuesForContainer(title, objectId, parentId, objectType, searchCriteria, accessGroup, coverImageId, disablePresentationSettings);
        }
        else if (( cast(OnlineRepository)entity !is null ))
        {
            values = instantiateValuesForContainer(title, objectId, parentId, objectType, searchCriteria, accessGroup, null, disablePresentationSettings);
        }
        else
        {
            return null;
        }
        if (rendererProfile.getContentDirectoryDefinitionFilter() !is null) {
            rendererProfile.getContentDirectoryDefinitionFilter().filterClassProperties(objectId, values);
        }
        return values;
    }

    public static Map!(ClassProperties, Object) instantiateValuesForContainer(String containerTitle, String objectId, String parentId, ObjectType objectType, SearchCriteria searchCriteria, AccessGroup accessGroup, Long containerThumbnailId, bool disablePresentationSettings)
    {
        Map!(ClassProperties, Object) values = new HashMap();
        values.put(ClassProperties.ID, objectId);
        values.put(ClassProperties.TITLE, getBrowsableTitle(containerTitle, objectId, disablePresentationSettings));
        values.put(ClassProperties.PARENT_ID, parentId);
        values.put(ClassProperties.CHILD_COUNT, Integer.valueOf(Definition.instance().getContainer(objectId).retrieveContainerItemsCount(objectId, objectType, searchCriteria, accessGroup, disablePresentationSettings)));
        values.put(ClassProperties.SEARCHABLE, Boolean.FALSE);
        if (containerThumbnailId !is null)
        {
            Resource icon = ResourceValuesBuilder.generateThumbnailResource(containerThumbnailId);
            values.put(ClassProperties.ICON, icon);
            values.put(ClassProperties.ALBUM_ART_URI, icon);
        }
        return values;
    }

    public static Map!(ClassProperties, Object) instantiateValuesForItem(String itemTitle, String objectId, String parentId, MediaItem item, bool disablePresentationSettings)
    {
        Map!(ClassProperties, Object) values = new HashMap();
        Resource icon = ResourceValuesBuilder.generateThumbnailResource(item.getThumbnailId());
        values.put(ClassProperties.ID, objectId);
        values.put(ClassProperties.TITLE, getBrowsableTitle(itemTitle, objectId, disablePresentationSettings));
        values.put(ClassProperties.PARENT_ID, parentId);
        values.put(ClassProperties.ICON, icon);
        values.put(ClassProperties.ALBUM_ART_URI, icon);
        values.put(ClassProperties.DCM_INFO, generateDcmInfo(item));
        return values;
    }

    protected static immutable String generateDcmInfo(MediaItem item)
    {
        if (item.getBookmark() !is null) {
            return String.format("CREATIONDATE=0,YEAR=%s,BM=%s", cast(Object[])[ Integer.valueOf(DateUtils.getYear(item.getDate())), item.getBookmark() ]);
        }
        return null;
    }

    private static String getBrowsableTitle(String itemTitle, String objectId, bool disablePresentationSettings)
    {
        String parentsTitle = Definition.instance().getContentOnlyParentTitles(objectId, disablePresentationSettings);
        if (parentsTitle !is null) {
            return String.format("%s %s", cast(Object[])[ itemTitle, parentsTitle ]);
        }
        return itemTitle;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.ObjectValuesBuilder
* JD-Core Version:    0.7.0.1
*/