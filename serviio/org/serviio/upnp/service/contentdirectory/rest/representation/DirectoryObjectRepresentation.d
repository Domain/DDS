module org.serviio.upnp.service.contentdirectory.rest.representation.DirectoryObjectRepresentation;

import java.lang;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import java.util.List;
import org.serviio.library.local.ContentType;
import org.serviio.upnp.service.contentdirectory.rest.representation.AbstractCDSObjectRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.ContentURLRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.OnlineIdentifierRepresentation;

public class DirectoryObjectRepresentation : AbstractCDSObjectRepresentation
{
    @XStreamAsAttribute
    private Integer childCount;
    private String description;
    private String genre;
    private String date;
    private String artist;
    private String album;
    private Integer originalTrackNumber;
    private Integer duration;
    private List!(ContentURLRepresentation) contentUrls;
    private String subtitlesUrl;
    private Boolean live;
    private List!(OnlineIdentifierRepresentation) onlineIdentifiers;
    private ContentType contentType;
    private String rating;

    public this(DirectoryObjectType type, String title, String id)
    {
        super(type, title, id);
    }

    public String getDescription()
    {
        return this.description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getGenre()
    {
        return this.genre;
    }

    public void setGenre(String genre)
    {
        this.genre = genre;
    }

    public List!(ContentURLRepresentation) getContentUrls()
    {
        return this.contentUrls;
    }

    public void setContentUrls(List!(ContentURLRepresentation) contentUrls)
    {
        this.contentUrls = contentUrls;
    }

    public String getDate()
    {
        return this.date;
    }

    public void setDate(String date)
    {
        this.date = date;
    }

    public Integer getOriginalTrackNumber()
    {
        return this.originalTrackNumber;
    }

    public void setOriginalTrackNumber(Integer originalTrackNumber)
    {
        this.originalTrackNumber = originalTrackNumber;
    }

    public String getSubtitlesUrl()
    {
        return this.subtitlesUrl;
    }

    public void setSubtitlesUrl(String subtitlesUrl)
    {
        this.subtitlesUrl = subtitlesUrl;
    }

    public String getArtist()
    {
        return this.artist;
    }

    public void setArtist(String artist)
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

    public Integer getDuration()
    {
        return this.duration;
    }

    public void setDuration(Integer duration)
    {
        this.duration = duration;
    }

    public Boolean getLive()
    {
        return this.live;
    }

    public void setLive(Boolean live)
    {
        this.live = live;
    }

    public List!(OnlineIdentifierRepresentation) getOnlineIdentifiers()
    {
        return this.onlineIdentifiers;
    }

    public void setOnlineIdentifiers(List!(OnlineIdentifierRepresentation) onlineIdentifiers)
    {
        this.onlineIdentifiers = onlineIdentifiers;
    }

    public ContentType getContentType()
    {
        return this.contentType;
    }

    public void setContentType(ContentType contentType)
    {
        this.contentType = contentType;
    }

    public Integer getChildCount()
    {
        return this.childCount;
    }

    public void setChildCount(Integer childrenCount)
    {
        this.childCount = childrenCount;
    }

    public String getRating()
    {
        return this.rating;
    }

    public void setRating(String rating)
    {
        this.rating = rating;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.DirectoryObjectRepresentation
* JD-Core Version:    0.7.0.1
*/