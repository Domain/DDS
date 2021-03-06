module org.serviio.upnp.service.contentdirectory.command.video.ListVideoGenresByNameCommand;

import java.lang;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Genre;
import org.serviio.library.local.service.GenreService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand;

public class ListVideoGenresByNameCommand : AbstractEntityContainerCommand!(Genre)
{
    public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, MediaFileType.VIDEO, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.GENRE, ObjectClassType.STORAGE_FOLDER ]));
    }

    override protected List!(Genre) retrieveEntityList()
    {
        List!(Genre) genres = GenreService.getListOfGenres(MediaFileType.VIDEO, this.startIndex, this.count);
        return genres;
    }

    override protected Genre retrieveSingleEntity(Long entityId)
    {
        Genre genre = GenreService.getGenre(entityId);
        return genre;
    }

    override public int retrieveItemCount()
    {
        return GenreService.getNumberOfGenres(MediaFileType.VIDEO);
    }

    override protected String getContainerTitle(Genre genre)
    {
        return genre.getName();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.video.ListVideoGenresByNameCommand
* JD-Core Version:    0.7.0.1
*/