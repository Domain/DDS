module org.serviio.delivery.resource.transcode.VideoTranscodingMatch;

import java.lang;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.serviio.dlna.AudioCodec;
import org.serviio.dlna.H264Profile;
import org.serviio.dlna.VideoCodec;
import org.serviio.dlna.VideoContainer;
import org.serviio.library.local.H264LevelType;
import org.serviio.profile.H264LevelCheckType;
import org.serviio.profile.OnlineContentType;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VideoTranscodingMatch
{
    private static Logger log;
    private VideoContainer container;
    private VideoCodec videoCodec;
    private AudioCodec audioCodec;
    private H264Profile h264Profile;
    private Float h264LevelGT;
    private List!(String) ftypNotIn = new ArrayList!(String)();
    private OnlineContentType onlineContentType = OnlineContentType.ANY;
    private Boolean squarePixels;
    private List!(String) vFourCC = new ArrayList!(String)();
    private H264LevelCheckType h264LevelCheckType;

    static this()
    {
        log = LoggerFactory.getLogger!(VideoTranscodingMatch);
    }

    public this(VideoContainer container, VideoCodec videoCodec, AudioCodec audioCodec, H264Profile h264Profile, Float h264LevelGT, String ftypNotIn, OnlineContentType onlineContentType, Boolean squarePixels, String vFourCC, H264LevelCheckType h264LevelCheckType)
    {
        this.container = container;
        this.videoCodec = videoCodec;
        this.audioCodec = audioCodec;
        this.h264Profile = h264Profile;
        this.h264LevelGT = h264LevelGT;
        if (ObjectValidator.isNotEmpty(ftypNotIn)) {
            this.ftypNotIn.addAll(Arrays.asList(ftypNotIn.split(",")));
        }
        this.onlineContentType = onlineContentType;
        this.squarePixels = squarePixels;
        if (ObjectValidator.isNotEmpty(vFourCC)) {
            this.vFourCC.addAll(Arrays.asList(vFourCC.split(",")));
        }
        this.h264LevelCheckType = h264LevelCheckType;
    }

    public this(VideoContainer container)
    {
        this.container = container;
    }

    public bool matches(VideoContainer container, VideoCodec videoCodec, AudioCodec audioCodec, H264Profile h264Profile, Map!(H264LevelType, String) h264Levels, String ftyp, OnlineContentType onlineContentType, bool squarePixels, String vFourCC)
    {
        if (((container == this.container) || (this.container == VideoContainer.ANY)) && ((this.videoCodec is null) || (videoCodec == this.videoCodec)) && ((this.audioCodec is null) || (audioCodec == this.audioCodec)) && (checkFtyp(ftyp)) && (checkVFourCC(vFourCC)) && (checkH264Profile(videoCodec, h264Profile, h264Levels)) && ((this.onlineContentType == OnlineContentType.ANY) || (this.onlineContentType == onlineContentType)) && ((this.squarePixels is null) || (this.squarePixels.equals(Boolean.valueOf(squarePixels))))) {
            return true;
        }
        return false;
    }

    private bool checkFtyp(String ftyp)
    {
        if ((this.ftypNotIn.isEmpty()) || ((ftyp !is null) && (!this.ftypNotIn.contains(StringUtils.localeSafeToLowercase(ftyp))))) {
            return true;
        }
        return false;
    }

    private bool checkVFourCC(String vFourCC)
    {
        if ((this.vFourCC.isEmpty()) || ((vFourCC !is null) && (this.vFourCC.contains(StringUtils.localeSafeToLowercase(vFourCC))))) {
            return true;
        }
        return false;
    }

    private bool checkH264Profile(VideoCodec videoCodec, H264Profile videoH264Profile, Map!(H264LevelType, String) videoH264Levels)
    {
        if (videoCodec == VideoCodec.H264)
        {
            if (this.h264Profile is null) {
                return true;
            }
            if (this.h264LevelGT is null) {
                return (videoH264Profile !is null) && (this.h264Profile == videoH264Profile);
            }
            String videoH264Level = getLevelToMatch(videoH264Levels);
            try
            {
                return (videoH264Profile !is null) && (videoH264Level !is null) && (this.h264Profile == videoH264Profile) && (new Float(videoH264Level).floatValue() > this.h264LevelGT.floatValue());
            }
            catch (NumberFormatException e)
            {
                log.warn(String_format("H264 level of the file is not a valid number: %s", cast(Object[])[ videoH264Level ]));
                return false;
            }
        }
        return true;
    }

    private String getLevelToMatch(Map!(H264LevelType, String) videoH264Levels)
    {
        if (this.h264LevelCheckType == H264LevelCheckType.FILE_ATTRIBUTES) {
            return cast(String)videoH264Levels.get(H264LevelType.RF);
        }
        if (this.h264LevelCheckType == H264LevelCheckType.HEADER) {
            return cast(String)videoH264Levels.get(H264LevelType.H);
        }
        return selectHigherH264Level(cast(String)videoH264Levels.get(H264LevelType.H), cast(String)videoH264Levels.get(H264LevelType.RF));
    }

    private String selectHigherH264Level(String headerLevel, String refFramesLevel)
    {
        if (ObjectValidator.isEmpty(headerLevel)) {
            return refFramesLevel;
        }
        if (ObjectValidator.isEmpty(refFramesLevel)) {
            return headerLevel;
        }
        Float headerLevelFloat = new Float(headerLevel);
        Float refFramesLevelFloat = new Float(refFramesLevel);
        if (headerLevelFloat.floatValue() > refFramesLevelFloat.floatValue()) {
            return headerLevel;
        }
        return refFramesLevel;
    }

    public VideoContainer getContainer()
    {
        return this.container;
    }

    public VideoCodec getVideoCodec()
    {
        return this.videoCodec;
    }

    public AudioCodec getAudioCodec()
    {
        return this.audioCodec;
    }

    public H264Profile getH264Profile()
    {
        return this.h264Profile;
    }

    public Float getH264LevelGT()
    {
        return this.h264LevelGT;
    }

    public List!(String) getFtypNotIn()
    {
        return Collections.unmodifiableList(this.ftypNotIn);
    }

    public OnlineContentType getOnlineContentType()
    {
        return this.onlineContentType;
    }

    public Boolean getSquarePixels()
    {
        return this.squarePixels;
    }

    public H264LevelCheckType getH264LevelCheckType()
    {
        return this.h264LevelCheckType;
    }

    public List!(String) getvFourCC()
    {
        return Collections.unmodifiableList(this.vFourCC);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.VideoTranscodingMatch
* JD-Core Version:    0.7.0.1
*/