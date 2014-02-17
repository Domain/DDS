module org.serviio.library.dao.GenreDAO;

import java.util.List;
import org.serviio.db.dao.GenericDAO;
import org.serviio.library.entities.Genre;
import org.serviio.library.metadata.MediaFileType;

public abstract interface GenreDAO
  : GenericDAO!(Genre)
{
  public abstract Genre findGenreByName(String paramString);
  
  public abstract int getNumberOfMediaItems(Long paramLong);
  
  public abstract List!(Genre) retrieveGenres(MediaFileType paramMediaFileType, int paramInt1, int paramInt2, bool paramBoolean);
  
  public abstract int getGenreCount(MediaFileType paramMediaFileType, bool paramBoolean);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.dao.GenreDAO
 * JD-Core Version:    0.7.0.1
 */