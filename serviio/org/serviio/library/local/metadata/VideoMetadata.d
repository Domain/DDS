module org.serviio.library.local.metadata.VideoMetadata;

import java.lang;
import java.util.ArrayList;
import java.util.Arrays;
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
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.util.ObjectValidator;
import org.serviio.library.local.metadata.LocalItemMetadata;
import org.serviio.library.local.metadata.TransportStreamTimestamp;
import org.serviio.library.local.metadata.MPAARating;
import org.serviio.library.local.metadata.ImageDescriptor;

public class VideoMetadata : LocalItemMetadata
{
    private VideoContainer container;
    private Integer width;
    private Integer height;
    private Integer duration;
    private Integer channels;
    private String fps;
    private String genre;
    private Integer frequency;
    private AudioCodec audioCodec;
    private VideoCodec videoCodec;
    private String videoFourCC;
    private Integer videoStreamIndex;
    private Integer audioStreamIndex;
    private Integer bitrate;
    private Integer videoBitrate;
    private Integer audioBitrate;
    private TransportStreamTimestamp timestampType;
    private H264Profile h264Profile;
    private HashMap!(H264LevelType, String) h264Levels = new HashMap();
    private String ftyp;
    private SourceAspectRatio sar;
    private List!(String) actors = new ArrayList();
    private List!(String) directors = new ArrayList();
    private List!(String) producers = new ArrayList();
    private MPAARating mpaaRating;
    private String seriesName;
    private Integer seasonNumber;
    private ImageDescriptor seriesCoverImage;
    private Integer episodeNumber;
    private ContentType contentType;
    private Map!(OnlineDBIdentifier, String) onlineIdentifiers = new HashMap();
    private List!(EmbeddedSubtitles) embeddedSubtitles = new ArrayList();

    override public void merge(LocalItemMetadata additionalMetadata)
    {
        if (( cast(VideoMetadata)additionalMetadata !is null ))
        {
            VideoMetadata additionalVideoMetadata = cast(VideoMetadata)additionalMetadata;

            super.merge(additionalVideoMetadata);
            if (this.container is null) {
                setContainer(additionalVideoMetadata.getContainer());
            }
            if (this.contentType is null) {
                setContentType(additionalVideoMetadata.getContentType());
            }
            if (ObjectValidator.isEmpty(this.genre)) {
                setGenre(additionalVideoMetadata.getGenre());
            }
            if (this.audioCodec is null) {
                setAudioCodec(additionalVideoMetadata.getAudioCodec());
            }
            if (this.videoCodec is null) {
                setVideoCodec(additionalVideoMetadata.getVideoCodec());
            }
            if (this.videoFourCC is null) {
                setVideoFourCC(additionalVideoMetadata.getVideoFourCC());
            }
            if (this.videoStreamIndex is null) {
                setVideoStreamIndex(additionalVideoMetadata.getVideoStreamIndex());
            }
            if (this.audioStreamIndex is null) {
                setAudioStreamIndex(additionalVideoMetadata.getAudioStreamIndex());
            }
            if (this.duration is null) {
                setDuration(additionalVideoMetadata.getDuration());
            }
            if (this.bitrate is null) {
                setBitrate(additionalVideoMetadata.getBitrate());
            }
            if (this.audioBitrate is null) {
                setAudioBitrate(additionalVideoMetadata.getAudioBitrate());
            }
            if (this.videoBitrate is null) {
                setVideoBitrate(additionalVideoMetadata.getVideoBitrate());
            }
            if (this.timestampType is null) {
                setTimestampType(additionalVideoMetadata.getTimestampType());
            }
            if ((this.h264Levels is null) || (this.h264Levels.size() == 0)) {
                this.h264Levels.putAll(additionalVideoMetadata.getH264Levels());
            }
            if (this.h264Profile is null) {
                setH264Profile(additionalVideoMetadata.getH264Profile());
            }
            if (this.ftyp is null) {
                setFtyp(additionalVideoMetadata.getFtyp());
            }
            if (this.sar is null) {
                setSar(additionalVideoMetadata.getSar());
            }
            if (this.width is null) {
                setWidth(additionalVideoMetadata.getWidth());
            }
            if (this.height is null) {
                setHeight(additionalVideoMetadata.getHeight());
            }
            if (this.channels is null) {
                setChannels(additionalVideoMetadata.getChannels());
            }
            if (this.fps is null) {
                setFps(additionalVideoMetadata.getFps());
            }
            if (this.frequency is null) {
                setFrequency(additionalVideoMetadata.getFrequency());
            }
            if ((this.actors is null) || (this.actors.size() == 0)) {
                setActors(additionalVideoMetadata.getActors());
            }
            if ((this.directors is null) || (this.directors.size() == 0)) {
                setDirectors(additionalVideoMetadata.getDirectors());
            }
            if ((this.producers is null) || (this.producers.size() == 0)) {
                setProducers(additionalVideoMetadata.getProducers());
            }
            if (ObjectValidator.isEmpty(this.seriesName)) {
                setSeriesName(additionalVideoMetadata.getSeriesName());
            }
            if (this.seasonNumber is null) {
                setSeasonNumber(additionalVideoMetadata.getSeasonNumber());
            }
            if (this.episodeNumber is null) {
                setEpisodeNumber(additionalVideoMetadata.getEpisodeNumber());
            }
            if (this.seriesCoverImage is null) {
                setSeriesCoverImage(additionalVideoMetadata.getSeriesCoverImage());
            }
            if ((this.onlineIdentifiers is null) || (this.onlineIdentifiers.size() == 0)) {
                this.onlineIdentifiers.putAll(additionalVideoMetadata.getOnlineIdentifiers());
            }
            if ((this.embeddedSubtitles is null) || (this.embeddedSubtitles.size() == 0)) {
                this.embeddedSubtitles.addAll(additionalVideoMetadata.getEmbeddedSubtitles());
            }
            if (this.mpaaRating is null) {
                setMPAARating(additionalVideoMetadata.getMPAARating());
            }
        }
    }

    override public void fillInUnknownEntries()
    {
        super.fillInUnknownEntries();
        if (ObjectValidator.isEmpty(this.genre)) {
            setGenre("Unknown");
        }
        if ((this.directors is null) || (this.directors.size() == 0)) {
            setDirectors(Arrays.asList(cast(String[])[ "Unknown" ]));
        }
        if ((this.producers is null) || (this.producers.size() == 0)) {
            setProducers(Arrays.asList(cast(String[])[ "Unknown" ]));
        }
        if ((this.actors is null) || (this.actors.size() == 0)) {
            setActors(Arrays.asList(cast(String[])[ "Unknown" ]));
        }
        if (this.mpaaRating is null) {
            setMPAARating(MPAARating.UNKNOWN);
        }
    }

    override public void validateMetadata()
    {
        super.validateMetadata();
        if (this.contentType is null) {
            throw new InvalidMetadataException("Content type missing");
        }
    }

    public Integer getDuration()
    {
        return this.duration;
    }

    public void setDuration(Integer duration)
    {
        this.duration = duration;
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

    public String getGenre()
    {
        return this.genre;
    }

    public void setGenre(String genre)
    {
        this.genre = genre;
    }

    public Integer getBitrate()
    {
        return this.bitrate;
    }

    public void setBitrate(Integer bitrate)
    {
        this.bitrate = bitrate;
    }

    public List!(String) getActors()
    {
        return this.actors;
    }

    public void setActors(List!(String) actors)
    {
        this.actors = actors;
    }

    public List!(String) getDirectors()
    {
        return this.directors;
    }

    public void setDirectors(List!(String) directors)
    {
        this.directors = directors;
    }

    public List!(String) getProducers()
    {
        return this.producers;
    }

    public void setProducers(List!(String) producers)
    {
        this.producers = producers;
    }

    public String getSeriesName()
    {
        return this.seriesName;
    }

    public void setSeriesName(String seriesName)
    {
        this.seriesName = seriesName;
    }

    public Integer getSeasonNumber()
    {
        return this.seasonNumber;
    }

    public void setSeasonNumber(Integer seasonNumber)
    {
        this.seasonNumber = seasonNumber;
    }

    public Integer getEpisodeNumber()
    {
        return this.episodeNumber;
    }

    public void setEpisodeNumber(Integer episodeNumber)
    {
        this.episodeNumber = episodeNumber;
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

    public VideoContainer getContainer()
    {
        return this.container;
    }

    public void setContainer(VideoContainer container)
    {
        this.container = container;
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

    public Integer getVideoBitrate()
    {
        return this.videoBitrate;
    }

    public void setVideoBitrate(Integer videoBitrate)
    {
        this.videoBitrate = videoBitrate;
    }

    public Integer getAudioBitrate()
    {
        return this.audioBitrate;
    }

    public void setAudioBitrate(Integer audioBitrate)
    {
        this.audioBitrate = audioBitrate;
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

    public Integer getVideoStreamIndex()
    {
        return this.videoStreamIndex;
    }

    public void setVideoStreamIndex(Integer videoTrackIndex)
    {
        this.videoStreamIndex = videoTrackIndex;
    }

    public Integer getAudioStreamIndex()
    {
        return this.audioStreamIndex;
    }

    public void setAudioStreamIndex(Integer audioTrackIndex)
    {
        this.audioStreamIndex = audioTrackIndex;
    }

    public H264Profile getH264Profile()
    {
        return this.h264Profile;
    }

    public void setH264Profile(H264Profile h264Profile)
    {
        this.h264Profile = h264Profile;
    }

    public HashMap!(H264LevelType, String) getH264Levels()
    {
        return this.h264Levels;
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

    public ImageDescriptor getSeriesCoverImage()
    {
        return this.seriesCoverImage;
    }

    public void setSeriesCoverImage(ImageDescriptor seriesCoverImage)
    {
        this.seriesCoverImage = seriesCoverImage;
    }

    public MPAARating getMPAARating()
    {
        return this.mpaaRating;
    }

    public void setMPAARating(MPAARating mpaaRating)
    {
        this.mpaaRating = mpaaRating;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("VideoMetadata [title=").append(this.title).append(", filePath=").append(this.filePath).append(", fileSize=").append(this.fileSize).append(", audioBitrate=").append(this.audioBitrate).append(", audioCodec=").append(this.audioCodec).append(", audioStreamIndex=").append(this.audioStreamIndex).append(", bitrate=").append(this.bitrate).append(", channels=").append(this.channels).append(", container=").append(this.container).append(", contentType=").append(this.contentType).append(", duration=").append(this.duration).append(", episodeNumber=").append(this.episodeNumber).append(", fps=").append(this.fps).append(", frequency=").append(this.frequency).append(", h264Levels=").append(this.h264Levels).append(", h264Profile=").append(this.h264Profile).append(", ftyp=").append(this.ftyp).append(", height=").append(this.height).append(", seasonNumber=").append(this.seasonNumber).append(", seriesName=").append(this.seriesName).append(", timestampType=").append(this.timestampType).append(", videoBitrate=").append(this.videoBitrate).append(", videoCodec=").append(this.videoCodec).append(", videoFourCC=").append(this.videoFourCC).append(", videoStreamIndex=").append(this.videoStreamIndex).append(", width=").append(this.width).append(", embeddedSubtitles=").append(this.embeddedSubtitles).append("]");

        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.VideoMetadata
* JD-Core Version:    0.7.0.1
*/