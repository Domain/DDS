module org.serviio.upnp.service.StateVariable;

import java.lang.String;
import java.util.Date;
import org.serviio.util.XmlUtils;

public class StateVariable
{
    private String name;
    private Object value;
    private bool supportsEventing = false;
    private int moderationInterval = 0;
    private Date lastEventSent;

    public this(String name, Object value, bool supportsEventing, int moderationInterval)
    {
        this(name, value);
        this.supportsEventing = supportsEventing;
        this.moderationInterval = moderationInterval;
    }

    public this(String name, Object value)
    {
        this.name = name;
        this.value = value;
    }

    public Object getValue()
    {
        return this.value;
    }

    public void setValue(Object value)
    {
        this.value = value;
    }

    public String getName()
    {
        return this.name;
    }

    public bool isSupportsEventing()
    {
        return this.supportsEventing;
    }

    public String getStringValue()
    {
        return this.value is null ? "" : XmlUtils.objectToXMLType(this.value);
    }

    public int getModerationInterval()
    {
        return this.moderationInterval;
    }

    public Date getLastEventSent()
    {
        return this.lastEventSent;
    }

    public void setLastEventSent(Date lastEventSent)
    {
        this.lastEventSent = lastEventSent;
    }

    public override equals_t opEquals(Object obj)
    {
        if ((( cast(StateVariable)obj !is null )) && ((cast(StateVariable)obj).getName().opEquals(this.name))) {
            return true;
        }
        return false;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.StateVariable
* JD-Core Version:    0.7.0.1
*/