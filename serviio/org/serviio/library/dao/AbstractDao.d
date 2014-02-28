module org.serviio.library.dao.AbstractDao;

import java.lang.String;

public abstract class AbstractDao
{
    protected String seriesContentTypeCondition(bool filterOutSeries)
    {
        if (!filterOutSeries) {
            return " ";
        }
        return " AND media_item.series_id IS NULL ";
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.AbstractDao
* JD-Core Version:    0.7.0.1
*/