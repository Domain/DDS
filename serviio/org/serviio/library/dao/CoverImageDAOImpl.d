module org.serviio.library.dao.CoverImageDAOImpl;

import java.io.ByteArrayInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.serviio.db.DatabaseManager;
import org.serviio.db.dao.InvalidArgumentException;
import org.serviio.db.dao.PersistenceException;
import org.serviio.library.entities.CoverImage;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.JdbcUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CoverImageDAOImpl
  : CoverImageDAO
{
  private static final Logger log = LoggerFactory.getLogger!(CoverImageDAOImpl);
  
  public long create(CoverImage newInstance)
  {
    if ((newInstance is null) || (newInstance.getImageBytes() is null)) {
      throw new InvalidArgumentException("Cannot create CoverImage. Required data is missing.");
    }
    log.debug_(String.format("Creating a new ImageCover (length = %s)", cast(Object[])[ Integer.valueOf(newInstance.getImageBytes().length) ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("INSERT INTO cover_image (image_data, mime_type, width, height, image_data_hd, width_hd, height_hd) VALUES (?,?,?,?,?,?,?)", 1);
      
      ps.setBinaryStream(1, new ByteArrayInputStream(newInstance.getImageBytes()));
      ps.setString(2, newInstance.getMimeType());
      JdbcUtils.setIntValueOnStatement(ps, 3, Integer.valueOf(newInstance.getWidth()));
      JdbcUtils.setIntValueOnStatement(ps, 4, Integer.valueOf(newInstance.getHeight()));
      ps.setBinaryStream(5, new ByteArrayInputStream(newInstance.getImageBytesHD()));
      JdbcUtils.setIntValueOnStatement(ps, 6, Integer.valueOf(newInstance.getWidthHD()));
      JdbcUtils.setIntValueOnStatement(ps, 7, Integer.valueOf(newInstance.getHeightHD()));
      
      ps.executeUpdate();
      return JdbcUtils.retrieveGeneratedID(ps);
    }
    catch (SQLException e)
    {
      throw new PersistenceException("Cannot create CoverImage", e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public void delete_(Long id)
  {
    log.debug_(String.format("Deleting a CoverImage (id = %s)", cast(Object[])[ id ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("DELETE FROM cover_image WHERE id = ?");
      ps.setLong(1, id.longValue());
      ps.executeUpdate();
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot delete CoverImage with id = %s", cast(Object[])[ id ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public CoverImage read(Long id)
  {
    log.debug_(String.format("Reading a CoverImage (id = %s)", cast(Object[])[ id ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT id, image_data, mime_type, width, height, image_data_hd, width_hd, height_hd FROM cover_image where id = ?");
      ps.setLong(1, id.longValue());
      ResultSet rs = ps.executeQuery();
      return mapSingleResult(rs);
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot read CoverImage with id = %s", cast(Object[])[ id ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public void update(CoverImage transientObject)
  {
    throw new UnsupportedOperationException("CoverImage update is not supported");
  }
  
  public Long getCoverImageForMusicAlbum(Long albumId)
  {
    log.debug_(String.format("Reading a CoverImage for music album (id = %s)", cast(Object[])[ albumId ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT cover_image_id from media_item WHERE album_id = ? and cover_image_id is not null FETCH FIRST 1 ROWS ONLY");
      ps.setLong(1, albumId.longValue());
      ResultSet rs = ps.executeQuery();
      Long id;
      if (rs.next())
      {
        id = Long.valueOf(rs.getLong("cover_image_id"));
        return id;
      }
      return null;
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot read CoverImage for album id = %s", cast(Object[])[ albumId ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public Long getCoverImageForFolder(Long folderId, MediaFileType fileType)
  {
    log.debug_(String.format("Reading a CoverImage for folder (id = %s)", cast(Object[])[ folderId ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT cover_image_id from media_item WHERE folder_id = ? and file_type = ? and cover_image_id is not null ORDER BY id FETCH FIRST 1 ROWS ONLY");
      ps.setLong(1, folderId.longValue());
      ps.setString(2, fileType.toString());
      ResultSet rs = ps.executeQuery();
      Long id;
      if (rs.next())
      {
        id = Long.valueOf(rs.getLong("cover_image_id"));
        return id;
      }
      return null;
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot read CoverImage for folder id = %s", cast(Object[])[ folderId ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public Long getCoverImageForPerson(Long personId)
  {
    log.debug_(String.format("Reading a CoverImage for person (id = %s)", cast(Object[])[ personId ]));
    Connection con = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps1 = con.prepareStatement("SELECT media_item_id, music_album_id FROM person_role AS pr WHERE pr.person_id = ? FETCH FIRST 1 ROWS ONLY");
      ps1.setLong(1, personId.longValue());
      ResultSet rs1 = ps1.executeQuery();
      Long miId;
      if (rs1.next())
      {
        miId = JdbcUtils.getLongFromResultSet(rs1, "media_item_id");
        Long albId = JdbcUtils.getLongFromResultSet(rs1, "music_album_id");
        String whereClause = miId !is null ? " id = ?" : "album_id = ?";
        ps2 = con.prepareStatement("SELECT cover_image_id as ciid from media_item WHERE " + whereClause + " AND cover_image_id is not null");
        
        ps2.setLong(1, (miId !is null ? miId : albId).longValue());
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next())
        {
          Long id = Long.valueOf(rs2.getLong("ciid"));
          return id;
        }
      }
      return null;
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot read CoverImage for person id = %s", cast(Object[])[ personId ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps1);
      JdbcUtils.closeStatement(ps2);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  public Long getCoverImageForRepository(Long repositoryId, MediaFileType fileType)
  {
    log.debug_(String.format("Reading a CoverImage for repository (id = %s)", cast(Object[])[ repositoryId ]));
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      con = DatabaseManager.getConnection();
      ps = con.prepareStatement("SELECT mi.cover_image_id AS ciid from media_item as mi, folder as f WHERE mi.folder_id = f.id AND mi.file_type = ? AND f.name = ? AND mi.repository_id = ? and mi.cover_image_id IS NOT NULL ORDER BY mi.cover_image_id FETCH FIRST 1 ROWS ONLY");
      ps.setString(1, fileType.toString());
      ps.setString(2, "!(virtual)");
      ps.setLong(3, repositoryId.longValue());
      ResultSet rs = ps.executeQuery();
      Long id;
      if (rs.next())
      {
        id = Long.valueOf(rs.getLong("ciid"));
        return id;
      }
      return null;
    }
    catch (SQLException e)
    {
      throw new PersistenceException(String.format("Cannot read CoverImage for repository id = %s", cast(Object[])[ repositoryId ]), e);
    }
    finally
    {
      JdbcUtils.closeStatement(ps);
      DatabaseManager.releaseConnection(con);
    }
  }
  
  protected CoverImage mapSingleResult(ResultSet rs)
  {
    if (rs.next())
    {
      Long id = Long.valueOf(rs.getLong("id"));
      byte[] allBytesInBlob = JdbcUtils.convertBlob(rs.getBlob("image_data"));
      String mimeType = rs.getString("mime_type");
      Integer width = Integer.valueOf(rs.getInt("width"));
      Integer height = Integer.valueOf(rs.getInt("height"));
      byte[] allBytesInBlobHD = JdbcUtils.convertBlob(rs.getBlob("image_data_hd"));
      Integer widthHD = Integer.valueOf(rs.getInt("width_hd"));
      Integer heightHD = Integer.valueOf(rs.getInt("height_hd"));
      
      CoverImage coverImage = new CoverImage(allBytesInBlob, mimeType, width.intValue(), height.intValue(), allBytesInBlobHD, widthHD.intValue(), heightHD.intValue());
      coverImage.setId(id);
      
      return coverImage;
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.dao.CoverImageDAOImpl
 * JD-Core Version:    0.7.0.1
 */