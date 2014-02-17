module org.serviio.library.dao.SeriesDAOImpl;

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
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Series;
import org.serviio.util.JdbcUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SeriesDAOImpl
  : AbstractSortableItemDao
  , SeriesDAO
{
  private static final Logger log = LoggerFactory.getLogger!(SeriesDAOImpl);
  
  public long create(Series newInstance)
  {
    if ((newInstance is null) || (ObjectValidator.isEmpty(newInstance.getTitle()))) {
      throw new InvalidArgumentException("Cannot create Series. Required data is missing.");
    }
    log.debug_(String.format("Creating a new Series (title = %s)", cast(Object[])[ newInstance.getTitle() ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("INSERT INTO series (title,sort_title,cover_image_id) VALUES (?,?,?)", 1);
      ps.setString(1, newInstance.getTitle());
      ps.setString(2, createSortName(newInstance.getTitle()));
      JdbcUtils.setLongValueOnStatement(ps, 3, newInstance.getThumbnailId());
      ps.executeUpdate();
      return JdbcUtils.retrieveGeneratedID(ps);
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot create Series with title %s", cast(Object[])[ newInstance.getTitle() ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public void delete_(final Long id)
  {
    log.debug_(String.format("Deleting a Series (id = %s)", cast(Object[])[ id ]));
    try
    {
      new class() JdbcExecutor {
        protected PreparedStatement processStatement(Connection con)
        {
          PreparedStatement ps = con.prepareStatement("DELETE FROM series WHERE id = ?");
          ps.setLong(1, id.longValue());
          ps.executeUpdate();
          return ps;
        }
      }.executeUpdate();
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot delete Series with id = %s", cast(Object[])[ id ]), e);
    }
  }
  
  public Series read(Long id)
  {
    log.debug_(String.format("Reading a Series (id = %s)", cast(Object[])[ id ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT id, title, sort_title, cover_image_id FROM series WHERE id = ?");
      ps.setLong(1, id.longValue());
      ResultSet rs = ps.executeQuery();
      return mapSingleResult(rs);
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot read Series with id = %s", cast(Object[])[ id ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public void update(Series transientObject)
  {
    if ((transientObject is null) || (transientObject.getId() is null) || (transientObject.getTitle() is null)) {
      throw new InvalidArgumentException("Cannot update Series. Required data is missing.");
    }
    log.debug_(String.format("Updating Setries (id = %s)", cast(Object[])[ transientObject.getId() ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("UPDATE series SET title = ?, sort_title = ?, cover_image_id = ? WHERE id = ?");
      ps.setString(1, transientObject.getTitle());
      ps.setString(2, createSortName(transientObject.getTitle()));
      JdbcUtils.setLongValueOnStatement(ps, 3, transientObject.getThumbnailId());
      ps.setLong(4, transientObject.getId().longValue());
      ps.executeUpdate();
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot update Series with id %s", cast(Object[])[ transientObject.getId() ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public Series findSeriesByName(String name)
  {
    log.debug_(String.format("Reading a Series (name = %s)", cast(Object[])[ name ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT id, title, sort_title, cover_image_id FROM series where lower(title) = ?");
      ps.setString(1, StringUtils.localeSafeToLowercase(name));
      ResultSet rs = ps.executeQuery();
      return mapSingleResult(rs);
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot read Series with name = %s", cast(Object[])[ name ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public int getNumberOfEpisodes(Long seriesId)
  {
    log.debug_(String.format("Getting number of episodes for series %s", cast(Object[])[ seriesId ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT count(media_item.id) as episodes from media_item WHERE media_item.series_id = ?");
      
      ps.setLong(1, seriesId.longValue());
      
      ResultSet rs = ps.executeQuery();
      Integer count;
      if (rs.next())
      {
        count = Integer.valueOf(rs.getInt("episodes"));
        return count.intValue();
      }
      return 0;
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot get number of episodes for series: %s ", cast(Object[])[ seriesId ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public List!(Series) retrieveSeries(int startingIndex, int requestedCount)
  {
    log.debug_(String.format("Retrieving list of series (from=%s, count=%s)", cast(Object[])[ Integer.valueOf(startingIndex), Integer.valueOf(requestedCount) ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT id, title, sort_title, cover_image_id FROM series ORDER BY lower(series.sort_title) OFFSET " + startingIndex + " ROWS FETCH FIRST " + requestedCount + " ROWS ONLY");
      

      ResultSet rs = ps.executeQuery();
      return mapResultSet(rs);
    }
    catch (SQLException e)
    {
      throw new PersistenceException("Cannot read list of series", e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public int getSeriesCount()
  {
    log.debug_("Retrieving number of series");
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT COUNT(id) as c FROM series");
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
      throw new PersistenceException("Cannot read number of series", e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public List!(Integer) retrieveSeasonsForSeries(Long seriesId, AccessGroup accessGroup, int startingIndex, int requestedCount)
  {
    log.debug_(String.format("Retrieving list of seasons for series %s (from=%s, count=%s) [%s]", cast(Object[])[ seriesId, Integer.valueOf(startingIndex), Integer.valueOf(requestedCount), accessGroup ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT DISTINCT(season_number) FROM media_item " + accessGroupTable(accessGroup) + "WHERE series_id = ? " + accessGroupConditionForMediaItem(accessGroup) + "ORDER BY season_number " + "OFFSET " + startingIndex + " ROWS FETCH FIRST " + requestedCount + " ROWS ONLY");
      



      ps.setLong(1, seriesId.longValue());
      ResultSet rs = ps.executeQuery();
      List!(Integer) result = new ArrayList();
      while (rs.next()) {
        result.add(Integer.valueOf(rs.getInt("season_number")));
      }
      return result;
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot read list of seasons for series %s", cast(Object[])[ seriesId ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public int getSeasonsForSeriesCount(Long seriesId, AccessGroup accessGroup)
  {
    log.debug_(String.format("Retrieving number of seasons for series %s [%s]", cast(Object[])[ seriesId, accessGroup ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT COUNT(DISTINCT(season_number)) as c FROM media_item " + accessGroupTable(accessGroup) + "WHERE series_id = ?" + accessGroupConditionForMediaItem(accessGroup));
      

      ps.setLong(1, seriesId.longValue());
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
      throw new PersistenceException(String.format("Cannot read number of seasons for series %s", cast(Object[])[ seriesId ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  protected Series mapSingleResult(ResultSet rs)
  {
    if (rs.next()) {
      return initSeries(rs);
    }
    return null;
  }
  
  protected List!(Series) mapResultSet(ResultSet rs)
  {
    List!(Series) result = new ArrayList();
    while (rs.next()) {
      result.add(initSeries(rs));
    }
    return result;
  }
  
  private Series initSeries(ResultSet rs)
  {
    Long id = Long.valueOf(rs.getLong("id"));
    String title = rs.getString("title");
    String sortTitle = rs.getString("sort_title");
    Long thumbnailId = JdbcUtils.getLongFromResultSet(rs, "cover_image_id");
    
    Series series = new Series(title, sortTitle, thumbnailId);
    series.setId(id);
    return series;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.dao.SeriesDAOImpl
 * JD-Core Version:    0.7.0.1
 */