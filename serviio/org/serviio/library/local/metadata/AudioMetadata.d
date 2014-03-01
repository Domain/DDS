module org.serviio.library.local.metadata.AudioMetadata;

import java.lang;
import org.serviio.dlna.AudioContainer;
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.util.ObjectValidator;
import org.serviio.library.local.metadata.LocalItemMetadata;

public class AudioMetadata : LocalItemMetadata
{
    private AudioContainer container;
    private String genre;
    private Integer releaseYear;
    private String album;
    private Integer trackNumber;
    private Integer duration;
    private String albumArtist;
    private String artist;
    private Integer discNumber;
    private Integer bitrate;
    private Integer channels;
    private Integer sampleFrequency;

    override public void merge(LocalItemMetadata additionalMetadata)
    {
        if (( cast(AudioMetadata)additionalMetadata !is null ))
        {
            AudioMetadata additionalAudioMetadata = cast(AudioMetadata)additionalMetadata;

            super.merge(additionalAudioMetadata);
            if (this.container is null) {
                setContainer(additionalAudioMetadata.getContainer());
            }
            if (ObjectValidator.isEmpty(this.genre)) {
                setGenre(additionalAudioMetadata.getGenre());
            }
            if (this.releaseYear is null) {
                setReleaseYear(additionalAudioMetadata.getReleaseYear());
            }
            if (ObjectValidator.isEmpty(this.album)) {
                setAlbum(additionalAudioMetadata.getAlbum());
            }
            if (this.trackNumber is null) {
                setTrackNumber(additionalAudioMetadata.getTrackNumber());
            }
            if (this.duration is null) {
                setDuration(additionalAudioMetadata.getDuration());
            }
            if (ObjectValidator.isEmpty(this.albumArtist)) {
                setAlbumArtist(additionalAudioMetadata.getAlbumArtist());
            }
            if (ObjectValidator.isEmpty(this.artist)) {
                setArtist(additionalAudioMetadata.getArtist());
            }
            if (this.bitrate is null) {
                setBitrate(additionalAudioMetadata.getBitrate());
            }
            if (this.channels is null) {
                setChannels(additionalAudioMetadata.getChannels());
            }
            if (this.sampleFrequency is null) {
                setSampleFrequency(additionalAudioMetadata.getSampleFrequency());
            }
            if (this.discNumber is null) {
                setDiscNumber(additionalAudioMetadata.getDiscNumber());
            }
        }
    }

    override public void fillInUnknownEntries()
    {
        super.fillInUnknownEntries();
        if (ObjectValidator.isEmpty(this.genre)) {
            setGenre("Unknown");
        }
        if (ObjectValidator.isEmpty(this.album)) {
            setAlbum("Unknown");
        }
        if (ObjectValidator.isEmpty(this.albumArtist)) {
            setAlbumArtist("Unknown");
        }
        if (ObjectValidator.isEmpty(this.artist)) {
            setAlbumArtist("Unknown");
        }
    }

    override public void validateMetadata()
    {
        super.validateMetadata();
        if (this.container is null) {
            throw new InvalidMetadataException("Unknown audio file type.");
        }
        if (this.bitrate is null) {
            throw new InvalidMetadataException("Unknown bit rate.");
        }
    }

    public String getGenre()
    {
        return this.genre;
    }

    public void setGenre(String genre)
    {
        this.genre = genre;
    }

    public Integer getReleaseYear()
    {
        return this.releaseYear;
    }

    public void setReleaseYear(Integer year)
    {
        this.releaseYear = year;
    }

    public String getAlbum()
    {
        return this.album;
    }

    public void setAlbum(String album)
    {
        this.album = album;
    }

    public Integer getTrackNumber()
    {
        return this.trackNumber;
    }

    public void setTrackNumber(Integer trackNumber)
    {
        this.trackNumber = trackNumber;
    }

    public Integer getDuration()
    {
        return this.duration;
    }

    public void setDuration(Integer duration)
    {
        this.duration = duration;
    }

    public String getAlbumArtist()
    {
        return this.albumArtist;
    }

    public void setAlbumArtist(String albumArtist)
    {
        this.albumArtist = albumArtist;
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

    public String getArtist()
    {
        return this.artist;
    }

    public void setArtist(String artist)
    {
        this.artist = artist;
    }

    public Integer getDiscNumber()
    {
        return this.discNumber;
    }

    public void setDiscNumber(Integer discNumber)
    {
        this.discNumber = discNumber;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("AudioMetadata [container=").append(this.container).append(", genre=").append(this.genre).append(", releaseYear=").append(this.releaseYear).append(", album=").append(this.album).append(", trackNumber=").append(this.trackNumber).append(", duration=").append(this.duration).append(", albumArtist=").append(this.albumArtist).append(", artist=").append(this.artist).append(", discNumber=").append(this.discNumber).append(", bitrate=").append(this.bitrate).append(", channels=").append(this.channels).append(", sampleFrequency=").append(this.sampleFrequency).append("]");

        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.AudioMetadata
* JD-Core Version:    0.7.0.1
*/