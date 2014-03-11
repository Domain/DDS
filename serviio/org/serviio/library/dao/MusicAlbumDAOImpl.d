module org.serviio.library.dao.MusicAlbumDAOImpl;

import java.lang;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.serviio.db.DatabaseManager;
import org.serviio.db.JdbcExecutor;
import org.serviio.db.dao.InvalidArgumentException;
import org.serviio.db.dao.PersistenceException;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.MusicAlbum;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.util.JdbcUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.library.dao.AbstractSortableItemDao;
import org.serviio.library.dao.MusicAlbumDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MusicAlbumDAOImpl : AbstractSortableItemDao, MusicAlbumDAO
{
    private static Logger log = LoggerFactory.getLogger!(MusicAlbumDAOImpl);

    public long create(MusicAlbum newInstance)
    {
        if ((newInstance is null) || (ObjectValidator.isEmpty(newInstance.getTitle()))) {
            throw new InvalidArgumentException("Cannot create MusicAlbum. Required data is missing.");
        }
        log.debug_(String.format("Creating a new MusicAlbum (title = %s)", cast(Object[])[ newInstance.getTitle() ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("INSERT INTO music_album (title,sort_title) VALUES (?,?)", 1);
            ps.setString(1, JdbcUtils.trimToMaxLength(newInstance.getTitle(), 256));
            ps.setString(2, JdbcUtils.trimToMaxLength(createSortName(newInstance.getTitle()), 256));
            ps.executeUpdate();
            return JdbcUtils.retrieveGeneratedID(ps);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(String.format("Cannot create MusicAlbum with title %s", cast(Object[])[ newInstance.getTitle() ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public MusicAlbum findAlbum(String title, String artist)
    {
        if (ObjectValidator.isEmpty(title)) {
            throw new InvalidArgumentException("Cannot find MusicAlbum. Required data (title) is missing.");
        }
        if (ObjectValidator.isEmpty(artist)) {
            throw new InvalidArgumentException("Cannot find MusicAlbum. Required data (artist) is missing.");
        }
        log.debug_(String.format("Finding a MusicAlbum (title = %s, artist=%s)", cast(Object[])[ title, artist ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT DISTINCT(a.id), a.title, a.sort_title FROM music_album a, person_role pr, person p WHERE pr.music_album_id = a.id AND p.id = pr.person_id AND pr.role_type = ? AND LCASE(p.name) = LCASE(?) AND LCASE(a.title) = LCASE(?)");

            ps.setString(1, RoleType.ALBUM_ARTIST.toString());
            ps.setString(2, artist);
            ps.setString(3, title);

            ResultSet rs = ps.executeQuery();
            return mapSingleResult(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(String.format("Cannot find MusicAlbum (title = %s, artist=%s)", cast(Object[])[ title, artist ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public void delete_(final Long id)
    {
        log.debug_(String.format("Deleting a MusicAlbum (id = %s)", cast(Object[])[ id ]));
        try
        {
            new class() JdbcExecutor {
                protected PreparedStatement processStatement(Connection con)
                {
                    PreparedStatement ps = con.prepareStatement("DELETE FROM music_album WHERE id = ?");
                    ps.setLong(1, id.longValue());
                    ps.executeUpdate();
                    return ps;
                }
            }.executeUpdate();
        }
        catch (SQLException e)
        {
            throw new PersistenceException(String.format("Cannot delete MusicAlbum with id = %s", cast(Object[])[ id ]), e);
        }
    }

    public MusicAlbum read(Long id)
    {
        log.debug_(String.format("Reading a MusicAlbum (id = %s)", cast(Object[])[ id ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT id, title, sort_title FROM music_album WHERE id = ?");
            ps.setLong(1, id.longValue());
            ResultSet rs = ps.executeQuery();
            return mapSingleResult(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(String.format("Cannot read MusicAlbum with id = %s", cast(Object[])[ id ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public void update(MusicAlbum transientObject)
    {
        throw new UnsupportedOperationException();
    }

    public int getNumberOfTracks(Long albumId)
    {
        log.debug_(String.format("Getting number of tracks for album %s", cast(Object[])[ albumId ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(media_item.id) as tracks from media_item WHERE media_item.album_id = ?");

            ps.setLong(1, albumId.longValue());

            ResultSet rs = ps.executeQuery();
            Integer count;
            if (rs.next())
            {
                count = Integer.valueOf(rs.getInt("tracks"));
                return count.intValue();
            }
            return 0;
        }
        catch (SQLException e)
        {
            throw new PersistenceException(String.format("Cannot get number of tracks for album: %s ", cast(Object[])[ albumId ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public List!(MusicAlbum) retrieveMusicAlbumsForTrackRole(Long personId, RoleType personRole, int startingIndex, int requestedCount)
    {
        log.debug_(String.format("Retrieving list of music albums for person %s and role %s (from=%s, count=%s)", cast(Object[])[ personId, personRole, Integer.valueOf(startingIndex), Integer.valueOf(requestedCount) ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT DISTINCT(a.id), a.title, a.sort_title FROM music_album a, person_role pr, media_item m  WHERE m.album_id = a.id AND pr.media_item_id = m.id AND pr.person_id = ? AND pr.role_type = ? ORDER BY lower(a.sort_title) OFFSET " + startingIndex + " ROWS FETCH FIRST " + requestedCount + " ROWS ONLY");



            ps.setLong(1, personId.longValue());
            ps.setString(2, personRole.toString());
            ResultSet rs = ps.executeQuery();
            return mapResultSet(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(String.format("Cannot read list of music albums for person %s and role %s", cast(Object[])[ personId, personRole ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public int retrieveMusicAlbumsForTrackRoleCount(Long artistId, RoleType personRole)
    {
        log.debug_(String.format("Getting number of albums for person %s and role %s", cast(Object[])[ artistId, personRole ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(distinct(a.id)) as c from music_album a, person_role pr, media_item m WHERE m.album_id = a.id AND pr.media_item_id = m.id AND pr.person_id = ? AND pr.role_type = ?");

            ps.setLong(1, artistId.longValue());
            ps.setString(2, personRole.toString());

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
            throw new PersistenceException(String.format("Cannot get number of albums for person %s and role %s ", cast(Object[])[ artistId, personRole ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public List!(MusicAlbum) retrieveMusicAlbumsForTrackRole(String personName, RoleType personRole, int startingIndex, int requestedCount)
    {
        log.debug_(String.format("Retrieving list of music albums for person '%s' and role %s (from=%s, count=%s)", cast(Object[])[ personName, personRole, Integer.valueOf(startingIndex), Integer.valueOf(requestedCount) ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT DISTINCT(a.id), a.title, a.sort_title FROM music_album a, person_role pr, media_item m, person p WHERE m.album_id = a.id AND pr.media_item_id = m.id AND pr.person_id = p.id AND p.name = ? AND pr.role_type = ? ORDER BY lower(a.sort_title) OFFSET " + startingIndex + " ROWS FETCH FIRST " + requestedCount + " ROWS ONLY");



            ps.setString(1, personName);
            ps.setString(2, personRole.toString());
            ResultSet rs = ps.executeQuery();
            return mapResultSet(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(String.format("Cannot read list of music albums for person '%s' and role %s", cast(Object[])[ personName, personRole ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public int retrieveMusicAlbumsForTrackRoleCount(String personName, RoleType personRole)
    {
        log.debug_(String.format("Getting number of albums for person '%s' and role %s", cast(Object[])[ personName, personRole ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(distinct(a.id)) as c from music_album a, person_role pr, media_item m, person p WHERE m.album_id = a.id AND pr.media_item_id = m.id AND pr.person_id = p.id AND p.name = ? AND pr.role_type = ?");

            ps.setString(1, personName);
            ps.setString(2, personRole.toString());

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
            throw new PersistenceException(String.format("Cannot get number of albums for person '%s' and role %s ", cast(Object[])[ personName, personRole ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public List!(MusicAlbum) retrieveMusicAlbumsForAlbumArtist(Long artistId, int startingIndex, int requestedCount)
    {
        log.debug_(String.format("Retrieving list of music albums for album artist %s (from=%s, count=%s)", cast(Object[])[ artistId, Integer.valueOf(startingIndex), Integer.valueOf(requestedCount) ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT DISTINCT(a.id), a.title, a.sort_title FROM music_album a, person_role pr WHERE pr.music_album_id = a.id AND pr.person_id = ? AND pr.role_type = ? ORDER BY lower(a.sort_title) OFFSET " + startingIndex + " ROWS FETCH FIRST " + requestedCount + " ROWS ONLY");



            ps.setLong(1, artistId.longValue());
            ps.setString(2, RoleType.ALBUM_ARTIST.toString());
            ResultSet rs = ps.executeQuery();
            return mapResultSet(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException(String.format("Cannot read list of music albums for album artist %s", cast(Object[])[ artistId ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public int retrieveMusicAlbumsForAlbumArtistCount(Long artistId)
    {
        log.debug_(String.format("Getting number of albums for album artist %s", cast(Object[])[ artistId ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(distinct(a.id)) as c from music_album a, person_role pr WHERE pr.music_album_id = a.id AND pr.person_id = ? AND pr.role_type = ?");

            ps.setLong(1, artistId.longValue());
            ps.setString(2, RoleType.ALBUM_ARTIST.toString());

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
            throw new PersistenceException(String.format("Cannot get number of albums for album artist: %s ", cast(Object[])[ artistId ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public List!(MusicAlbum) retrieveAllMusicAlbums(int startingIndex, int requestedCount)
    {
        log.debug_(String.format("Retrieving list of all music albums (from=%s, count=%s)", cast(Object[])[ Integer.valueOf(startingIndex), Integer.valueOf(requestedCount) ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT a.id, a.title, a.sort_title FROM music_album a ORDER BY lower(a.sort_title) OFFSET " + startingIndex + " ROWS FETCH FIRST " + requestedCount + " ROWS ONLY");


            ResultSet rs = ps.executeQuery();
            return mapResultSet(rs);
        }
        catch (SQLException e)
        {
            throw new PersistenceException("Cannot read list of all music albums", e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public int retrieveAllMusicAlbumsCount()
    {
        log.debug_("Getting number of all albums");
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(a.id) as c from music_album a");

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
            throw new PersistenceException("Cannot get number of all albums", e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public List!(MusicAlbum) retrieveRandomAlbums(int max, int startingIndex, int requestedCount)
    {
        log.debug_(String.format("Retrieving list of random music albums (start = %s, count=%s)", cast(Object[])[ Integer.valueOf(startingIndex), Integer.valueOf(requestedCount) ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            if (requestedCount + startingIndex > max) {
                requestedCount = max - startingIndex;
            }
            ResultSet rs;
            if (requestedCount > 0)
            {
                ps = con.prepareStatement("SELECT random() as r, a.id, a.title, a.sort_title FROM music_album a ORDER BY r OFFSET " + startingIndex + " ROWS FETCH FIRST " + requestedCount + " ROWS ONLY");

                rs = ps.executeQuery();
                return mapResultSet(rs);
            }
            return Collections.emptyList();
        }
        catch (SQLException e)
        {
            throw new PersistenceException("Cannot read list random music albums", e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public int retrieveRandomAlbumsCount(int max)
    {
        log.debug_("Retrieving number of random music albums");
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(distinct(a.id)) as c FROM music_album a");
            ResultSet rs = ps.executeQuery();
            Integer count;
            if (rs.next())
            {
                count = Integer.valueOf(rs.getInt("c"));
                return Math.min(count.intValue(), max);
            }
            return 0;
        }
        catch (SQLException e)
        {
            throw new PersistenceException("Cannot read number of random music albums", e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public List!(MusicAlbum) retrieveLastViewedMusicAlbums(int max, int startingIndex, int requestedCount, AccessGroup accessGroup)
    {
        log.debug_(String.format("Retrieving list of last viewed music albums (start = %s, count=%s) [%s]", cast(Object[])[ Integer.valueOf(startingIndex), Integer.valueOf(requestedCount), accessGroup ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            if (requestedCount + startingIndex > max) {
                requestedCount = max - startingIndex;
            }
            ResultSet rs;
            if (requestedCount > 0)
            {
                con = DatabaseManager.getConnection();
                ps = con.prepareStatement("SELECT a.id, a.title, a.sort_title, MAX(last_viewed_date) as viewed_date FROM music_album a, media_item " + accessGroupTable(accessGroup) + "WHERE media_item.album_id = a.id AND media_item.last_viewed_date IS NOT NULL " + accessGroupConditionForMediaItem(accessGroup) + "GROUP BY a.id, a.title, a.sort_title " + "ORDER BY viewed_date DESC " + "OFFSET " + startingIndex + " ROWS FETCH FIRST " + requestedCount + " ROWS ONLY");





                rs = ps.executeQuery();
                return mapResultSet(rs);
            }
            return Collections.emptyList();
        }
        catch (SQLException e)
        {
            throw new PersistenceException("Cannot read list of last viewed music albums", e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    public int retrieveLastViewedMusicAlbumsCount(int max, AccessGroup accessGroup)
    {
        log.debug_(String.format("Retrieving number of last viewed music albums [%s]", cast(Object[])[ accessGroup ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(distinct(a.id)) as c FROM music_album a, media_item " + accessGroupTable(accessGroup) + "WHERE media_item.album_id = a.id AND media_item.last_viewed_date IS NOT NULL " + accessGroupConditionForMediaItem(accessGroup));

            ResultSet rs = ps.executeQuery();
            Integer count;
            if (rs.next())
            {
                count = Integer.valueOf(rs.getInt("c"));
                return Math.min(count.intValue(), max);
            }
            return 0;
        }
        catch (SQLException e)
        {
            throw new PersistenceException("Cannot read number of last viewed music albums", e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    protected MusicAlbum mapSingleResult(ResultSet rs)
    {
        if (rs.next()) {
            return initMusicAlbum(rs);
        }
        return null;
    }

    protected List!(MusicAlbum) mapResultSet(ResultSet rs)
    {
        List!(MusicAlbum) result = new ArrayList();
        while (rs.next()) {
            result.add(initMusicAlbum(rs));
        }
        return result;
    }

    private MusicAlbum initMusicAlbum(ResultSet rs)
    {
        Long id = Long.valueOf(rs.getLong("id"));
        String title = rs.getString("title");
        String sortTitle = rs.getString("sort_title");

        MusicAlbum album = new MusicAlbum(title);
        album.setId(id);
        album.setSortTitle(sortTitle);
        return album;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.MusicAlbumDAOImpl
* JD-Core Version:    0.7.0.1
*/