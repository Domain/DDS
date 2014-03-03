module org.serviio.library.online.metadata.TechnicalMetadata;

import java.lang;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import org.serviio.dlna.AudioCodec;
import org.serviio.dlna.AudioContainer;
import org.serviio.dlna.H264Profile;
import org.serviio.dlna.ImageContainer;
import org.serviio.dlna.SamplingMode;
import org.serviio.dlna.SourceAspectRatio;
import org.serviio.dlna.VideoCodec;
import org.serviio.dlna.VideoContainer;
import org.serviio.library.local.H264LevelType;

public class TechnicalMetadata : Serializable, Cloneable
{
    private static long serialVersionUID = 3657481392836745888L;
    private ImageContainer imageContainer;
    private SamplingMode chromaSubsampling;
    private AudioContainer audioContainer;
    private VideoContainer videoContainer;
    private AudioCodec audioCodec;
    private VideoCodec videoCodec;
    private Integer channels;
    private String fps;
    private Integer videoStreamIndex;
    private Integer audioStreamIndex;
    private Integer videoBitrate;
    private Integer audioBitrate;
    private String ftyp;
    private H264Profile h264Profile;
    private HashMap!(H264LevelType, String) h264Levels = new HashMap();
    private SourceAspectRatio sar;
    private Long fileSize;
    private Integer width;
    private Integer height;
    private Integer bitrate;
    private Long duration;
    private Integer samplingRate;

    public ImageContainer getImageContainer()
    {
        return this.imageContainer;
    }

    public void setImageContainer(ImageContainer imageContainer)
    {
        this.imageContainer = imageContainer;
    }

    public Long getFileSize()
    {
        return this.fileSize;
    }

    public void setFileSize(Long fileSize)
    {
        this.fileSize = fileSize;
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

    public Long getDuration()
    {
        return this.duration;
    }

    public void setDuration(Long duration)
    {
        this.duration = duration;
    }

    public Integer getSamplingRate()
    {
        return this.samplingRate;
    }

    public void setSamplingRate(Integer samplingRate)
    {
        this.samplingRate = samplingRate;
    }

    public AudioContainer getAudioContainer()
    {
        return this.audioContainer;
    }

    public void setAudioContainer(AudioContainer audioContainer)
    {
        this.audioContainer = audioContainer;
    }

    public VideoContainer getVideoContainer()
    {
        return this.videoContainer;
    }

    public void setVideoContainer(VideoContainer videoContainer)
    {
        this.videoContainer = videoContainer;
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

    public Map!(H264LevelType, String) getH264Levels()
    {
        return this.h264Levels;
    }

    public void setH264Levels(HashMap!(H264LevelType, String) h264Levels)
    {
        this.h264Levels = h264Levels;
    }

    public String getFps()
    {
        return this.fps;
    }

    public void setFps(String fps)
    {
        this.fps = fps;
    }

    public Integer getVideoStreamIndex()
    {
        return this.videoStreamIndex;
    }

    public void setVideoStreamIndex(Integer videoStreamIndex)
    {
        this.videoStreamIndex = videoStreamIndex;
    }

    public Integer getAudioStreamIndex()
    {
        return this.audioStreamIndex;
    }

    public void setAudioStreamIndex(Integer audioStreamIndex)
    {
        this.audioStreamIndex = audioStreamIndex;
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

    public Integer getBitrate()
    {
        return this.bitrate;
    }

    public void setBitrate(Integer bitrate)
    {
        this.bitrate = bitrate;
    }

    public String getFtyp()
    {
        return this.ftyp;
    }

    public void setFtyp(String ftyp)
    {
        this.ftyp = ftyp;
    }

    public H264Profile getH264Profile()
    {
        return this.h264Profile;
    }

    public void setH264Profile(H264Profile h264Profile)
    {
        this.h264Profile = h264Profile;
    }

    public SourceAspectRatio getSar()
    {
        return this.sar;
    }

    public void setSar(SourceAspectRatio sar)
    {
        this.sar = sar;
    }

    public SamplingMode getChromaSubsampling()
    {
        return this.chromaSubsampling;
    }

    public void setChromaSubsampling(SamplingMode chromaSubsampling)
    {
        this.chromaSubsampling = chromaSubsampling;
    }

    protected TechnicalMetadata clone()
    {
        TechnicalMetadata copy = new TechnicalMetadata();
        copy.setAudioBitrate(this.audioBitrate !is null ? new Integer(this.audioBitrate.intValue()) : null);
        copy.setAudioCodec(this.audioCodec);
        copy.setAudioContainer(this.audioContainer);
        copy.setAudioStreamIndex(this.audioStreamIndex !is null ? new Integer(this.audioStreamIndex.intValue()) : null);
        copy.setBitrate(this.bitrate !is null ? new Integer(this.bitrate.intValue()) : null);
        copy.setChannels(this.channels !is null ? new Integer(this.channels.intValue()) : null);
        copy.setDuration(this.duration !is null ? new Long(this.duration.longValue()) : null);
        copy.setFileSize(this.fileSize !is null ? new Long(this.fileSize.longValue()) : null);
        copy.setFps(this.fps !is null ? new String(this.fps) : null);
        copy.setHeight(this.height !is null ? new Integer(this.height.intValue()) : null);
        copy.setImageContainer(this.imageContainer);
        copy.setSamplingRate(this.samplingRate !is null ? new Integer(this.samplingRate.intValue()) : null);
        copy.setVideoBitrate(this.videoBitrate !is null ? new Integer(this.videoBitrate.intValue()) : null);
        copy.setVideoCodec(this.videoCodec);
        copy.setVideoContainer(this.videoContainer);
        copy.setVideoStreamIndex(this.videoStreamIndex !is null ? new Integer(this.videoStreamIndex.intValue()) : null);
        copy.setWidth(this.width !is null ? new Integer(this.width.intValue()) : null);
        copy.setFtyp(this.ftyp);
        copy.setH264Levels(cast(HashMap)this.h264Levels.clone());
        copy.setH264Profile(this.h264Profile);
        copy.setSar(this.sar);
        copy.setChromaSubsampling(this.chromaSubsampling);
        return copy;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.metadata.TechnicalMetadata
* JD-Core Version:    0.7.0.1
*/