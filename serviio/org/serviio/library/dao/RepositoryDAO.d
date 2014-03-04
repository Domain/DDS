module org.serviio.library.dao.RepositoryDAO;

import java.lang.Long;
import java.util.List;
import org.serviio.db.dao.GenericDAO;
import org.serviio.db.dao.InvalidArgumentException;
import org.serviio.db.dao.PersistenceException;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Repository;
import org.serviio.library.metadata.MediaFileType;

public abstract interface RepositoryDAO : GenericDAO!(Repository)
{
    public abstract List!(Repository) findAll();

    public abstract List!(Repository) getRepositories(MediaFileType paramMediaFileType, AccessGroup paramAccessGroup, int paramInt1, int paramInt2);

    public abstract int getRepositoriesCount(MediaFileType paramMediaFileType, AccessGroup paramAccessGroup);

    public abstract void markRepositoryAsScanned(Long paramLong);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.RepositoryDAO
* JD-Core Version:    0.7.0.1
*/