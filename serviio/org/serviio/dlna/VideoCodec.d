module org.serviio.dlna.VideoCodec;

import java.lang.String;
import java.lang.RuntimeException;

public enum VideoCodec
{
    H264,  H263,  VC1,  MPEG4,  MSMPEG4,  MPEG2,  WMV,  MPEG1,  MJPEG,  FLV,  VP6,  VP8,  THEORA,  DV,  REAL,  UNKNOWN, 
}

public String getFFmpegEncoderName(VideoCodec codec)
{
    final switch (codec)
    {
        case VideoCodec.H264: 
            return "libx264";
        case VideoCodec.H263: 
            throw new RuntimeException("Canot transcode to H263");
        case VideoCodec.VC1: 
            throw new RuntimeException("Canot transcode to VC1");
        case VideoCodec.MPEG4: 
            throw new RuntimeException("Canot transcode to MPEG4");
        case VideoCodec.MSMPEG4: 
            throw new RuntimeException("Canot transcode to MSMPEG4");
        case VideoCodec.MPEG2: 
            return "mpeg2video";
        case VideoCodec.WMV: 
            return "wmv2";
        case VideoCodec.MPEG1: 
            throw new RuntimeException("Canot transcode to Mpeg1");
        case VideoCodec.MJPEG: 
            throw new RuntimeException("Canot transcode to MJpeg");
        case VideoCodec.FLV: 
            return "flv";
        case VideoCodec.VP6: 
            throw new RuntimeException("Canot transcode to VP6");
        case VideoCodec.VP8: 
            throw new RuntimeException("Canot transcode to VP8");
        case VideoCodec.THEORA: 
            throw new RuntimeException("Canot transcode to Theora");
        case VideoCodec.DV: 
            throw new RuntimeException("Canot transcode to DV");
        case VideoCodec.REAL: 
            throw new RuntimeException("Canot transcode to Real Video");
        case VideoCodec.UNKNOWN: 
            throw new RuntimeException("Canot transcode to Unknown");
    }
    throw new RuntimeException("Unknown video codec");
}

public VideoCodec getByFFmpegValue(String ffmpegName)
{
    if (ffmpegName !is null)
    {
        if (ffmpegName.equals("vc1")) {
            return VideoCodec.VC1;
        }
        if (ffmpegName.equals("mpeg4")) {
            return VideoCodec.MPEG4;
        }
        if (ffmpegName.startsWith("msmpeg4")) {
            return VideoCodec.MSMPEG4;
        }
        if (ffmpegName.equals("mpeg2video")) {
            return VideoCodec.MPEG2;
        }
        if (ffmpegName.equals("h264")) {
            return VideoCodec.H264;
        }
        if ((ffmpegName.equals("wmv1")) || (ffmpegName.equals("wmv3")) || (ffmpegName.equals("wmv2"))) {
            return VideoCodec.WMV;
        }
        if ((ffmpegName.equals("mpeg1video")) || (ffmpegName.equals("mpegvideo"))) {
            return VideoCodec.MPEG1;
        }
        if ((ffmpegName.equals("mjpeg")) || (ffmpegName.equals("mjpegb"))) {
            return VideoCodec.MJPEG;
        }
        if (ffmpegName.startsWith("vp6")) {
            return VideoCodec.VP6;
        }
        if (ffmpegName.startsWith("vp8")) {
            return VideoCodec.VP8;
        }
        if (ffmpegName.startsWith("flv")) {
            return VideoCodec.FLV;
        }
        if (ffmpegName.equals("theora")) {
            return VideoCodec.THEORA;
        }
        if (ffmpegName.equals("dvvideo")) {
            return VideoCodec.DV;
        }
        if (ffmpegName.startsWith("h263")) {
            return VideoCodec.H263;
        }
        if (ffmpegName.startsWith("rv")) {
            return VideoCodec.REAL;
        }
    }
    return VideoCodec.UNKNOWN;
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.VideoCodec
* JD-Core Version:    0.7.0.1
*/