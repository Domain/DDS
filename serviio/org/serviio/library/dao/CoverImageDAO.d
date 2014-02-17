module org.serviio.library.dao.CoverImageDAO;

import org.serviio.db.dao.GenericDAO;
import org.serviio.library.entities.CoverImage;
import org.serviio.library.metadata.MediaFileType;

public abstract interface CoverImageDAO
  : GenericDAO!(CoverImage)
{
  public abstract Long getCoverImageForMusicAlbum(Long paramLong);
  
  public abstract Long getCoverImageForFolder(Long paramLong, MediaFileType paramMediaFileType);
  
  public abstract Long getCoverImageForPerson(Long paramLong);
  
  public abstract Long getCoverImageForRepository(Long paramLong, MediaFileType paramMediaFileType);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.dao.CoverImageDAO
 * JD-Core Version:    0.7.0.1
 */