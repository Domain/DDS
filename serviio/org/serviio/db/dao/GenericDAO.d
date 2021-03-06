module org.serviio.db.dao.GenericDAO;

import java.lang.Long;

public abstract interface GenericDAO(T)
{
    public abstract long create(T paramT);

    public abstract T read(Long paramLong);

    public abstract void update(T paramT);

    public abstract void delete_(Long paramLong);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.db.dao.GenericDAO
* JD-Core Version:    0.7.0.1
*/