module org.serviio.library.entities.Video;

import java.lang;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.serviio.dlna.AudioCodec;
import org.serviio.dlna.H264Profile;
import org.serviio.dlna.SourceAspectRatio;
import org.serviio.dlna.VideoCodec;
import org.serviio.dlna.VideoContainer;
import org.serviio.library.local.ContentType;
import org.serviio.library.local.EmbeddedSubtitles;
import org.serviio.library.local.H264LevelType;
import org.serviio.library.local.OnlineDBIdentifier;
import org.serviio.library.local.metadata.MPAARating;
import org.serviio.library.local.metadata.TransportStreamTimestamp;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.entities.MediaItem;

public class Video : MediaItem
{
    private Integer duration;
    private Long genreId;
    private Integer bitrate;
    private Integer audioBitrate;
    private Integer audioStreamIndex;
    private Integer videoStreamIndex;
    private String videoFourCC;
    private Integer width;
    private Integer height;
    private Integer channels;
    private String fps;
    private Integer frequency;
    private MPAARating rating;
    private Long seriesId;
    private Integer episodeNumber;
    private Integer seasonNumber;
    private Integer releaseYear;
    private VideoContainer container;
    private AudioCodec audioCodec;
    private VideoCodec videoCodec;
    private ContentType contentType;
    private TransportStreamTimestamp timestampType;
    private H264Profile h264Profile;
    private Map!(H264LevelType, String) h264Levels = new HashMap!(H264LevelType, String)();
    private String ftyp;
    private SourceAspectRatio sar;
    private Map!(OnlineDBIdentifier, String) onlineIdentifiers = new HashMap!(OnlineDBIdentifier, String)();
    private List!(EmbeddedSubtitles) embeddedSubtitles = new ArrayList!(EmbeddedSubtitles)();

    public this(String title, VideoContainer container, String fileName, String filePath, Long fileSize, Long folderId, Long repositoryId, Date date)
    {
        super(title, fileName, filePath, fileSize, folderId, repositoryId, date, MediaFileType.VIDEO);
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

    public Integer getWidth()
    {
        return this.width;
    }

    public void setWidth(Integer width)
    {
        this.width = width;
    }

    public Integer getHeight()
    {
        return this.height;
    }

    public void setHeight(Integer height)
    {
        this.height = height;
    }

    public MPAARating getRating()
    {
        return this.rating;
    }

    public void setRating(MPAARating rating)
    {
        this.rating = rating;
    }

    public Long getSeriesId()
    {
        return this.seriesId;
    }

    public void setSeriesId(Long seriesId)
    {
        this.seriesId = seriesId;
    }

    public Integer getEpisodeNumber()
    {
        return this.episodeNumber;
    }

    public void setEpisodeNumber(Integer episodeNumber)
    {
        this.episodeNumber = episodeNumber;
    }

    public Integer getSeasonNumber()
    {
        return this.seasonNumber;
    }

    public void setSeasonNumber(Integer seasonNumber)
    {
        this.seasonNumber = seasonNumber;
    }

    public VideoContainer getContainer()
    {
        return this.container;
    }

    public void setContainer(VideoContainer container)
    {
        this.container = container;
    }

    public AudioCodec getAudioCodec()
    {
        return this.audioCodec;
    }

    public void setAudioCodec(AudioCodec audioCodec)
    {
        this.audioCodec = audioCodec;
    }

    public VideoCodec getVideoCodec()
    {
        return this.videoCodec;
    }

    public void setVideoCodec(VideoCodec videoCodec)
    {
        this.videoCodec = videoCodec;
    }

    public Integer getChannels()
    {
        return this.channels;
    }

    public void setChannels(Integer channels)
    {
        this.channels = channels;
    }

    public String getFps()
    {
        return this.fps;
    }

    public void setFps(String fps)
    {
        this.fps = fps;
    }

    public Integer getFrequency()
    {
        return this.frequency;
    }

    public void setFrequency(Integer frequency)
    {
        this.frequency = frequency;
    }

    public ContentType getContentType()
    {
        return this.contentType;
    }

    public void setContentType(ContentType contentType)
    {
        this.contentType = contentType;
    }

    public TransportStreamTimestamp getTimestampType()
    {
        return this.timestampType;
    }

    public void setTimestampType(TransportStreamTimestamp timestampType)
    {
        this.timestampType = timestampType;
    }

    public Integer getAudioBitrate()
    {
        return this.audioBitrate;
    }

    public void setAudioBitrate(Integer audioBitrate)
    {
        this.audioBitrate = audioBitrate;
    }

    public Integer getAudioStreamIndex()
    {
        return this.audioStreamIndex;
    }

    public void setAudioStreamIndex(Integer audioStreamIndex)
    {
        this.audioStreamIndex = audioStreamIndex;
    }

    public Integer getVideoStreamIndex()
    {
        return this.videoStreamIndex;
    }

    public void setVideoStreamIndex(Integer videoStreamIndex)
    {
        this.videoStreamIndex = videoStreamIndex;
    }

    public H264Profile getH264Profile()
    {
        return this.h264Profile;
    }

    public void setH264Profile(H264Profile h264Profile)
    {
        this.h264Profile = h264Profile;
    }

    public String getFtyp()
    {
        return this.ftyp;
    }

    public void setFtyp(String ftyp)
    {
        this.ftyp = ftyp;
    }

    public Map!(OnlineDBIdentifier, String) getOnlineIdentifiers()
    {
        return this.onlineIdentifiers;
    }

    public void setOnlineIdentifiers(Map!(OnlineDBIdentifier, String) onlineIdentifiers)
    {
        this.onlineIdentifiers = onlineIdentifiers;
    }

    public Map!(H264LevelType, String) getH264Levels()
    {
        return this.h264Levels;
    }

    public void setH264Levels(Map!(H264LevelType, String) h264Levels)
    {
        this.h264Levels = h264Levels;
    }

    public SourceAspectRatio getSar()
    {
        return this.sar;
    }

    public void setSar(SourceAspectRatio sar)
    {
        this.sar = sar;
    }

    public String getVideoFourCC()
    {
        return this.videoFourCC;
    }

    public void setVideoFourCC(String videoFourCC)
    {
        this.videoFourCC = videoFourCC;
    }

    public List!(EmbeddedSubtitles) getEmbeddedSubtitles()
    {
        return this.embeddedSubtitles;
    }

    public Integer getReleaseYear()
    {
        return this.releaseYear;
    }

    public void setReleaseYear(Integer releaseYear)
    {
        this.releaseYear = releaseYear;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.entities.Video
* JD-Core Version:    0.7.0.1
*/