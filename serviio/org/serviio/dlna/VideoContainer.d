module org.serviio.dlna.VideoContainer;

import java.lang.String;
import java.lang.RuntimeException;
import org.serviio.util.StringUtils;

public enum VideoContainer
{
    ANY,  
    AVI,  
    MATROSKA,  
    ASF,  
    MP4,  
    MPEG2PS,  
    MPEG2TS,  
    M2TS,  
    MPEG1,  
    FLV,  
    WTV,  
    OGG,  
    THREE_GP,  
    RTP,  
    RTSP,  
    APPLE_HTTP,  
    REAL_MEDIA,
    UNKNOWN,
}

public String getFFmpegValue(VideoContainer container)
{
    final switch (container)
    {
        case VideoContainer.ANY: 
            throw new RuntimeException("Cannot transcode audio into any");
        case VideoContainer.AVI: 
            return "avi";
        case VideoContainer.MATROSKA: 
            return "matroska";
        case VideoContainer.ASF: 
            return "asf";
        case VideoContainer.MP4: 
            return "mp4";
        case VideoContainer.MPEG2PS: 
            return "vob";
        case VideoContainer.MPEG2TS: 
            return "mpegts";
        case VideoContainer.M2TS: 
            return "mpegts";
        case VideoContainer.MPEG1: 
            return "mpegvideo";
        case VideoContainer.FLV: 
            return "flv";
        case VideoContainer.WTV: 
            return "wtv";
        case VideoContainer.OGG: 
            return "ogg";
        case VideoContainer.THREE_GP: 
            return "3gp";
        case VideoContainer.RTP: 
            return "rtp";
        case VideoContainer.RTSP: 
            return "rtsp";
        case VideoContainer.APPLE_HTTP:
            return "segment";
        case VideoContainer.REAL_MEDIA: 
            return "rm";
        case VideoContainer.UNKNOWN: 
            throw new RuntimeException("Cannot transcode audio into unknown");
    }
    throw new RuntimeException("Unknown video container");
}

public bool isSegmentBased(VideoContainer container)
{
    if (container == VideoContainer.APPLE_HTTP)
        return true;
    return false;
}

public VideoContainer getByFFmpegValue(String ffmpegName, String filePath)
{
    if (ffmpegName !is null)
    {
        if (ffmpegName.equals("*")) {
            return VideoContainer.ANY;
        }
        if (ffmpegName.equals("asf")) {
            return VideoContainer.ASF;
        }
        if (ffmpegName.equals("mpegvideo")) {
            return VideoContainer.MPEG1;
        }
        if ((ffmpegName.equals("mpeg")) || (ffmpegName.equals("vob"))) {
            return VideoContainer.MPEG2PS;
        }
        if (ffmpegName.equals("mpegts")) {
            return VideoContainer.MPEG2TS;
        }
        if (ffmpegName.equals("m2ts")) {
            return VideoContainer.M2TS;
        }
        if (ffmpegName.equals("matroska")) {
            return VideoContainer.MATROSKA;
        }
        if (ffmpegName.equals("avi")) {
            return VideoContainer.AVI;
        }
        if ((ffmpegName.equals("mov")) || (ffmpegName.equals("mp4")))
        {
            if ((filePath !is null) && (StringUtils.localeSafeToLowercase(filePath).endsWith(".3gp"))) {
                return VideoContainer.THREE_GP;
            }
            return VideoContainer.MP4;
        }
        if (ffmpegName.equals("flv")) {
            return VideoContainer.FLV;
        }
        if (ffmpegName.equals("wtv")) {
            return VideoContainer.WTV;
        }
        if (ffmpegName.equals("ogg")) {
            return VideoContainer.OGG;
        }
        if (ffmpegName.equals("3gp")) {
            return VideoContainer.THREE_GP;
        }
        if (ffmpegName.equals("rtp")) {
            return VideoContainer.RTP;
        }
        if (ffmpegName.equals("rtsp")) {
            return VideoContainer.RTSP;
        }
        if ((ffmpegName.equals("applehttp")) || (ffmpegName.equals("hls"))) {
            return VideoContainer.APPLE_HTTP;
        }
        if (ffmpegName.equals("rm")) {
            return VideoContainer.REAL_MEDIA;
        }
    }
    return VideoContainer.UNKNOWN;
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.VideoContainer
* JD-Core Version:    0.7.0.1
*/