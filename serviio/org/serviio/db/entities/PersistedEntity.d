module org.serviio.db.entities.PersistedEntity;

import java.lang;

public abstract class PersistedEntity
{
    protected Long id;

    public Long getId()
    {
        return this.id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public override hash_t toHash()
    {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.id is null ? 0 : this.id.hashCode());
        return result;
    }

    public override equals_t opEquals(Object obj)
    {
        if (this == obj) {
            return true;
        }
        if (obj is null) {
            return false;
        }
        //if (getClass() != obj.getClass()) {
        //    return false;
        //}
        PersistedEntity other = cast(PersistedEntity)obj;
        if (this.id is null)
        {
            if (other.id !is null) {
                return false;
            }
        }
        else if (this.id != other.id) {
            return false;
        }
        return true;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.db.entities.PersistedEntity
* JD-Core Version:    0.7.0.1
*/