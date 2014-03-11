module org.serviio.library.dao.AbstractSortableItemDao;

import java.lang.String;
import org.serviio.util.StringUtils;
import org.serviio.library.dao.AbstractAccessibleDao;

public abstract class AbstractSortableItemDao : AbstractAccessibleDao
{
    protected String createSortName(String name)
    {
        if (name !is null) {
            return StringUtils.removeAccents(StringUtils.removeArticles(name)).trim();
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.AbstractSortableItemDao
* JD-Core Version:    0.7.0.1
*/