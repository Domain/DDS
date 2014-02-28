module org.serviio.library.dao.AccessGroupDAO;

import java.lang.Long;
import java.util.List;
import org.serviio.db.dao.GenericDAO;
import org.serviio.library.entities.AccessGroup;

public abstract interface AccessGroupDAO : GenericDAO!(AccessGroup)
{
    public abstract List!(AccessGroup) getAccessGroupsForRepository(Long paramLong);

    public abstract List!(AccessGroup) findAll();

    public abstract List!(AccessGroup) getAccessGroupsForOnlineRepository(Long paramLong);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.AccessGroupDAO
* JD-Core Version:    0.7.0.1
*/