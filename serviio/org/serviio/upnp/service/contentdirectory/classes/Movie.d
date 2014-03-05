module org.serviio.upnp.service.contentdirectory.classes.Movie;

import java.lang.String;
import java.util.Date;
import org.serviio.upnp.service.contentdirectory.classes.VideoItem;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public class Movie : VideoItem
{
    protected String storageMedium;
    protected String DVDRegionCode;
    protected String[] channelName;
    protected Date scheduledStartTime;
    protected Date scheduledEndTime;

    public this(String id, String title)
    {
        super(id, title);
    }

    override public ObjectClassType getObjectClass()
    {
        return ObjectClassType.MOVIE;
    }

    public String getStorageMedium()
    {
        return this.storageMedium;
    }

    public void setStorageMedium(String storageMedium)
    {
        this.storageMedium = storageMedium;
    }

    public String getDVDRegionCode()
    {
        return this.DVDRegionCode;
    }

    public void setDVDRegionCode(String dVDRegionCode)
    {
        this.DVDRegionCode = dVDRegionCode;
    }

    public String[] getChannelName()
    {
        return this.channelName;
    }

    public void setChannelName(String[] channelName)
    {
        this.channelName = channelName;
    }

    public Date getScheduledStartTime()
    {
        return this.scheduledStartTime;
    }

    public void setScheduledStartTime(Date scheduledStartTime)
    {
        this.scheduledStartTime = scheduledStartTime;
    }

    public Date getScheduledEndTime()
    {
        return this.scheduledEndTime;
    }

    public void setScheduledEndTime(Date scheduledEndTime)
    {
        this.scheduledEndTime = scheduledEndTime;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.Movie
* JD-Core Version:    0.7.0.1
*/