module org.serviio.library.dao.OnlineRepositoryDAO;

import java.util.List;
import org.serviio.db.dao.GenericDAO;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.metadata.MediaFileType;

public abstract interface OnlineRepositoryDAO
  : GenericDAO!(OnlineRepository)
{
  public abstract List!(OnlineRepository) findAll();
  
  public abstract List!(OnlineRepository) getRepositories(List!(OnlineRepositoryType) paramList, MediaFileType paramMediaFileType, AccessGroup paramAccessGroup, bool paramBoolean);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.dao.OnlineRepositoryDAO
 * JD-Core Version:    0.7.0.1
 */