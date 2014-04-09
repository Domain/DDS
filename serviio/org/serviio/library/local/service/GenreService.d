module org.serviio.library.local.service.GenreService;

import java.lang;
import java.util.List;
import org.serviio.config.Configuration;
import org.serviio.db.dao.DAOFactory;
import org.serviio.library.dao.GenreDAO;
import org.serviio.library.entities.Genre;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.service.Service;
import org.serviio.util.ObjectValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GenreService : Service
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(GenreService);
    }

    public static void removeGenre(Long genreId)
    {
        if (genreId !is null)
        {
            int numberOfItems = DAOFactory.getGenreDAO().getNumberOfMediaItems(genreId);
            if (numberOfItems == 0) {
                DAOFactory.getGenreDAO().delete_(genreId);
            }
        }
    }

    public static Genre getGenre(Long genreId)
    {
        if (genreId !is null) {
            return cast(Genre)DAOFactory.getGenreDAO().read(genreId);
        }
        return null;
    }

    public static List!(Genre) getListOfGenres(MediaFileType fileType, int startingIndex, int requestedCount)
    {
        return DAOFactory.getGenreDAO().retrieveGenres(fileType, startingIndex, requestedCount, Configuration.isBrowseFilterOutSeries());
    }

    public static int getNumberOfGenres(MediaFileType fileType)
    {
        return DAOFactory.getGenreDAO().getGenreCount(fileType, Configuration.isBrowseFilterOutSeries());
    }

    public static Long findOrCreateGenre(String genreName)
    {
        if (ObjectValidator.isNotEmpty(genreName))
        {
            Genre genre = DAOFactory.getGenreDAO().findGenreByName(genreName);
            if (genre is null)
            {
                log.debug_(java.lang.String.format("Genre %s not found, creating a new one", cast(Object[])[ genreName ]));

                genre = new Genre(genreName);
                return Long.valueOf(DAOFactory.getGenreDAO().create(genre));
            }
            log.debug_(java.lang.String.format("Genre %s found", cast(Object[])[ genreName ]));
            return genre.getId();
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.service.GenreService
* JD-Core Version:    0.7.0.1
*/