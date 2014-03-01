module org.serviio.upnp.eventing.Subscription;

import java.lang;
import java.net.URL;
import java.util.Date;
import java.util.UUID;

public class Subscription : Comparable!(Subscription)
{
    private String uuid;
    private URL deliveryURL;
    private long key = 0L;
    private String duration;
    private Date created;

    public this()
    {
        this.uuid = UUID.randomUUID().toString();
    }

    public void increaseKey()
    {
        if (this.key == 4294967295L) {
            this.key = 1L;
        } else {
            this.key += 1L;
        }
    }

    public URL getDeliveryURL()
    {
        return this.deliveryURL;
    }

    public void setDeliveryURL(URL deliveryURL)
    {
        this.deliveryURL = deliveryURL;
    }

    public long getKey()
    {
        return this.key;
    }

    public void setKey(int key)
    {
        this.key = key;
    }

    public String getDuration()
    {
        return this.duration;
    }

    public void setDuration(String duration)
    {
        this.duration = duration;
    }

    public String getUuid()
    {
        return this.uuid;
    }

    public Date getCreated()
    {
        return this.created;
    }

    public void setCreated(Date created)
    {
        this.created = created;
    }

    public override equals_t opEquals(Object obj)
    {
        if (this == obj) {
            return true;
        }
        if (obj is null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        Subscription other = cast(Subscription)obj;
        if (this.uuid is null)
        {
            if (other.uuid !is null) {
                return false;
            }
        }
        else if (!this.uuid.equals(other.uuid)) {
            return false;
        }
        return true;
    }

    public override hash_t toHash()
    {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.uuid is null ? 0 : this.uuid.hashCode());
        return result;
    }

    public int compareTo(Subscription o)
    {
        return getUuid().compareTo(o.getUuid());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.eventing.Subscription
* JD-Core Version:    0.7.0.1
*/