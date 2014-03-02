module org.serviio.library.entities.MusicTrack;

import java.lang;
import java.util.Date;
import org.serviio.dlna.AudioContainer;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.entities.MediaItem;

public class MusicTrack : MediaItem
{
    private AudioContainer container;
    private Integer duration;
    private Long albumId;
    private Integer trackNumber;
    private Long genreId;
    private Integer releaseYear;
    private Integer bitrate;
    private Integer channels;
    private Integer sampleFrequency;
    private Integer discNumber;

    public this(String title, AudioContainer container, String fileName, String filePath, Long fileSize, Long folderId, Long repositoryId, Date date)
    {
        super(title, fileName, filePath, fileSize, folderId, repositoryId, date, MediaFileType.AUDIO);
        this.container = container;
    }

    public Integer getDuration()
    {
        return this.duration;
    }

    public void setDuration(Integer duration)
    {
        this.duration = duration;
    }

    public Long getAlbumId()
    {
        return this.albumId;
    }

    public void setAlbumId(Long albumId)
    {
        this.albumId = albumId;
    }

    public Integer getTrackNumber()
    {
        return this.trackNumber;
    }

    public void setTrackNumber(Integer trackNumber)
    {
        this.trackNumber = trackNumber;
    }

    public Integer getReleaseYear()
    {
        return this.releaseYear;
    }

    public void setReleaseYear(Integer year)
    {
        this.releaseYear = year;
    }

    public Long getGenreId()
    {
        return this.genreId;
    }

    public void setGenreId(Long genreId)
    {
        this.genreId = genreId;
    }

    public Integer getBitrate()
    {
        return this.bitrate;
    }

    public void setBitrate(Integer bitrate)
    {
        this.bitrate = bitrate;
    }

    public Integer getChannels()
    {
        return this.channels;
    }

    public void setChannels(Integer channels)
    {
        this.channels = channels;
    }

    public Integer getSampleFrequency()
    {
        return this.sampleFrequency;
    }

    public void setSampleFrequency(Integer sampleFrequency)
    {
        this.sampleFrequency = sampleFrequency;
    }

    public AudioContainer getContainer()
    {
        return this.container;
    }

    public void setContainer(AudioContainer container)
    {
        this.container = container;
    }

    public Integer getDiscNumber()
    {
        return this.discNumber;
    }

    public void setDiscNumber(Integer discNumber)
    {
        this.discNumber = discNumber;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.entities.MusicTrack
* JD-Core Version:    0.7.0.1
*/