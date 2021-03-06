module org.serviio.library.dao.GenreDAOImpl;

import java.lang;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.serviio.db.DatabaseManager;
import org.serviio.db.JdbcExecutor;
import org.serviio.db.dao.InvalidArgumentException;
import org.serviio.db.dao.PersistenceException;
import org.serviio.library.entities.Genre;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.JdbcUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.serviio.library.dao.AbstractDao;
import org.serviio.library.dao.GenreDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GenreDAOImpl : AbstractDao, GenreDAO
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(GenreDAOImpl);
    }

    public long create(Genre newInstance)
    {
        if ((newInstance is null) || (ObjectValidator.isEmpty(newInstance.getName()))) {
            throw new InvalidArgumentException("Cannot create Genre. Required data is missing.");
        }
        log.debug_(java.lang.String.format("Creating a new Genre (name = %s)", cast(Object[])[ newInstance.getName() ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("INSERT INTO genre (name) VALUES (?)", 1);

            ps.setString(1, JdbcUtils.trimToMaxLength(newInstance.getName(), 128));
            ps.executeUpdate();
            return JdbcUtils.retrieveGeneratedID(ps);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(java.lang.String.format("Cannot create Genre with name %s", cast(Object[])[ newInstance.getName() ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public void delete_(Long id)
    {
        log.debug_(java.lang.String.format("Deleting a Genre (id = %s)", cast(Object[])[ id ]));
        try
        {
            new class() JdbcExecutor {
                override protected PreparedStatement processStatement(Connection con)
                {
                    PreparedStatement ps = con.prepareStatement("DELETE FROM genre WHERE id = ?");
                    ps.setLong(1, id.longValue());
                    ps.executeUpdate();
                    return ps;
                }
            }.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new PersistenceException(java.lang.String.format("Cannot delete Genre with id = %s", cast(Object[])[ id ]), e);
        }
    }

    public Genre read(Long id)
    {
        log.debug_(java.lang.String.format("Reading a Genre (id = %s)", cast(Object[])[ id ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT id, name FROM genre where id = ?");
            ps.setLong(1, id.longValue());
            ResultSet rs = ps.executeQuery();
            return mapSingleResult(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(java.lang.String.format("Cannot read Genre with id = %s", cast(Object[])[ id ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public void update(Genre transientObject)
    {
        throw new UnsupportedOperationException("Genre update is not supported");
    }

    public Genre findGenreByName(String name)
    {
        log.debug_(java.lang.String.format("Reading a Genre (name = %s)", cast(Object[])[ name ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT id, name FROM genre where lower(name) = ?");
            ps.setString(1, StringUtils.localeSafeToLowercase(name));
            ResultSet rs = ps.executeQuery();
            return mapSingleResult(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(java.lang.String.format("Cannot read Genre with name = %s", cast(Object[])[ name ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public int getNumberOfMediaItems(Long genreId)
    {
        log.debug_(java.lang.String.format("Getting number of media items for genre %s", cast(Object[])[ genreId ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(media_item.id) as items from media_item, genre WHERE media_item.genre_id = genre.id AND genre.id = ?");

            ps.setLong(1, genreId.longValue());

            ResultSet rs = ps.executeQuery();
            Integer count;
            if (rs.next())
            {
                count = Integer.valueOf(rs.getInt("items"));
                return count.intValue();
            }
            return 0;
        }
        catch (SQLException e)
        {
            throw new PersistenceException(java.lang.String.format("Cannot get number of media items for genre: %s ", cast(Object[])[ genreId ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
        return 0;
    }

    public List!(Genre) retrieveGenres(MediaFileType fileType, int startingIndex, int requestedCount, bool filterOutSeries)
    {
        log.debug_(java.lang.String.format("Retrieving list of genres for %s (from=%s, count=%s)", cast(Object[])[ fileType.toString(), Integer.valueOf(startingIndex).toString(), Integer.valueOf(requestedCount).toString() ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT DISTINCT(genre.id) as id, genre.name as name FROM genre, media_item WHERE media_item.genre_id = genre.id AND media_item.file_type = ? " ~ seriesContentTypeCondition(filterOutSeries) ~ "ORDER BY lower(genre.name) " ~ "OFFSET " ~ startingIndex.toString() ~ " ROWS FETCH FIRST " ~ requestedCount.toString() ~ " ROWS ONLY");

            ps.setString(1, fileType.toString());
            ResultSet rs = ps.executeQuery();
            return mapResultSet(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(java.lang.String.format("Cannot read list of genres for %s", cast(Object[])[ fileType ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
        return null;
    }

    public int getGenreCount(MediaFileType fileType, bool filterOutSeries)
    {
        log.debug_(java.lang.String.format("Retrieving number of genres for %s", cast(Object[])[ fileType ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT COUNT(DISTINCT(genre.id)) as c FROM genre, media_item WHERE media_item.genre_id = genre.id AND media_item.file_type = ?" ~ seriesContentTypeCondition(filterOutSeries));

            ps.setString(1, fileType.toString());
            ResultSet rs = ps.executeQuery();
            Integer count;
            if (rs.next())
            {
                count = Integer.valueOf(rs.getInt("c"));
                return count.intValue();
            }
            return 0;
        }
        catch (SQLException e)
        {
            throw new PersistenceException(java.lang.String.format("Cannot read number of genres for %s", cast(Object[])[ fileType ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
        return 0;
    }

    protected Genre mapSingleResult(ResultSet rs)
    {
        if (rs.next()) {
            return initGenre(rs);
        }
        return null;
    }

    protected List!(Genre) mapResultSet(ResultSet rs)
    {
        List!(Genre) result = new ArrayList!(Genre)();
        while (rs.next()) {
            result.add(initGenre(rs));
        }
        return result;
    }

    private Genre initGenre(ResultSet rs)
    {
        Long id = Long.valueOf(rs.getLong("id"));
        String name = rs.getString("name");

        Genre genre = new Genre(name);
        genre.setId(id);

        return genre;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.GenreDAOImpl
* JD-Core Version:    0.7.0.1
*/