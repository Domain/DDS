module org.serviio.dlna.AudioCodec;

import java.lang.String;
import java.lang.System;
import java.lang.RuntimeException;

public enum AudioCodec
{
    MP3,  MP2,  MP1,  AAC,  AC3,  LPCM,  DTS,  WMA,  WMA_PRO,  FLAC,  VORBIS,  TRUEHD,  AMR,  REAL, INVALID
}

public String getFFmpegEncoderName(AudioCodec audioCodec)
{
    final switch(audioCodec)
    {
        case AudioCodec.MP3:
            return "libmp3lame"; 

        case AudioCodec.MP2:
            return "mp2"; 

        case AudioCodec.MP1:
            return "mp1"; 

        case AudioCodec.AAC:
            return "aac"; 

        case AudioCodec.AC3:
            if (System.getProperty("serviio.fixedPointEncoders") is null) {
                return "ac3";
            } 
            return "ac3_fixed";

        case AudioCodec.LPCM:
            return "pcm_s16be"; 

        case AudioCodec.DTS:
            return "dca"; 

        case AudioCodec.WMA:
            return "wmav2"; 

        case AudioCodec.WMA_PRO:
            return "wmapro"; 

        case AudioCodec.FLAC:
            return "flac"; 

        case AudioCodec.VORBIS:
            return "vorbis"; 

        case AudioCodec.TRUEHD:
            return "truehd"; 

        case AudioCodec.AMR:
            return "amrnb"; 

        case AudioCodec.REAL:
            throw new RuntimeException("RealAudio is not supported");

        case AudioCodec.INVALID:
            throw new RuntimeException("INVALID is not supported");
    }

    return "";
}

public AudioCodec getByFFmpegDecoderName(String ffmpegName)
{
    if (ffmpegName !is null) {
        if (ffmpegName.equals("mp3"))
            return AudioCodec.MP3;
        if ((ffmpegName.equals("ac3")) || (ffmpegName.startsWith("ac-3")) || (ffmpegName.equals("liba52")) || (ffmpegName.equals("eac3")))
            return AudioCodec.AC3;
        if ((ffmpegName.equals("aac")) || (ffmpegName.equals("mpeg4aac")) || (ffmpegName.equals("aac_latm")))
            return AudioCodec.AAC;
        if ((ffmpegName.startsWith("dca")) || (ffmpegName.startsWith("dts")))
            return AudioCodec.DTS;
        if ((ffmpegName.equals("wmav1")) || (ffmpegName.equals("wmav2")))
            return AudioCodec.WMA;
        if ((ffmpegName.equals("lpcm")) || (ffmpegName.startsWith("pcm_")) || (ffmpegName.startsWith("adpcm_")))
            return AudioCodec.LPCM;
        if ((ffmpegName.equals("wmapro")) || (ffmpegName.equals("0x0162")))
            return AudioCodec.WMA_PRO;
        if (ffmpegName.equals("mp2"))
            return AudioCodec.MP2;
        if (ffmpegName.equals("mp1"))
            return AudioCodec.MP1;
        if (ffmpegName.equals("flac"))
            return AudioCodec.FLAC;
        if (ffmpegName.equals("vorbis"))
            return AudioCodec.VORBIS;
        if (ffmpegName.equals("truehd"))
            return AudioCodec.TRUEHD;
        if ((ffmpegName.equals("amrnb")) || (ffmpegName.equals("amrwb")) || (ffmpegName.equals("amr_nb")) || (ffmpegName.equals("amr_wb")))
            return AudioCodec.AMR;
        if ((ffmpegName.equals("ralf")) || (ffmpegName.startsWith("real")) || (ffmpegName.equals("sipr")) || (ffmpegName.equals("cook"))) {
            return AudioCodec.REAL;
        }
    }
    return AudioCodec.INVALID;
}

/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.AudioCodec
* JD-Core Version:    0.7.0.1
*/