module org.serviio.upnp.service.contentdirectory.classes.MusicTrack;

import java.lang;
import org.serviio.upnp.service.contentdirectory.classes.AudioItem;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public class MusicTrack : AudioItem
{
    protected String[] artist;
    protected String album;
    protected Integer originalTrackNumber;
    protected String playlist;
    protected String storageMedium;
    protected String[] contributor;
    protected String date;

    public this(String id, String title)
    {
        super(id, title);
    }

    override public ObjectClassType getObjectClass()
    {
        return ObjectClassType.MUSIC_TRACK;
    }

    public String[] getArtist()
    {
        return this.artist;
    }

    public void setArtist(String[] artist)
    {
        this.artist = artist;
    }

    public String getAlbum()
    {
        return this.album;
    }

    public void setAlbum(String album)
    {
        this.album = album;
    }

    public Integer getOriginalTrackNumber()
    {
        return this.originalTrackNumber;
    }

    public void setOriginalTrackNumber(Integer originalTrackNumber)
    {
        this.originalTrackNumber = originalTrackNumber;
    }

    public String getPlaylist()
    {
        return this.playlist;
    }

    public void setPlaylist(String playlist)
    {
        this.playlist = playlist;
    }

    public String getStorageMedium()
    {
        return this.storageMedium;
    }

    public void setStorageMedium(String storageMedium)
    {
        this.storageMedium = storageMedium;
    }

    public String[] getContributor()
    {
        return this.contributor;
    }

    public void setContributor(String[] contributor)
    {
        this.contributor = contributor;
    }

    public String getDate()
    {
        return this.date;
    }

    public void setDate(String date)
    {
        this.date = date;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.MusicTrack
* JD-Core Version:    0.7.0.1
*/