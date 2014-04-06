module org.serviio.dlna.AudioContainer;

import java.lang.String;
import java.lang.RuntimeException;

public enum AudioContainer
{
    ANY,  MP3,  MP2,  ASF,  LPCM,  MP4,  FLAC,  OGG,  FLV,  RTP,  RTSP,  ADTS,  WAVPACK,  MUSEPACK,  APE, INVALID
}

public String getFFmpegContainerEncoderName(AudioContainer audioContainer)
{
    final switch (audioContainer)
    {
        case AudioContainer.ANY:
            throw new RuntimeException("Cannot transcode audio into any"); 

        case AudioContainer.MP3:
            return "mp3"; 

        case AudioContainer.MP2:
            return "mp2"; 

        case AudioContainer.ASF:
            throw new RuntimeException("Cannot transcode audio into asf"); 

        case AudioContainer.LPCM:
            return "s16be"; 

        case AudioContainer.MP4:
            throw new RuntimeException("Cannot transcode audio into mp4"); 

        case AudioContainer.FLAC:
            throw new RuntimeException("Cannot transcode audio into flac"); 

        case AudioContainer.OGG:
            throw new RuntimeException("Cannot transcode audio into ogg"); 

        case AudioContainer.FLV:
            throw new RuntimeException("Cannot transcode audio into flv"); 

        case AudioContainer.RTP:
            throw new RuntimeException("Cannot transcode audio into rtp"); 

        case AudioContainer.RTSP:
            throw new RuntimeException("Cannot transcode audio into rtsp"); 

        case AudioContainer.ADTS:
            throw new RuntimeException("Cannot transcode audio into adts");

        case AudioContainer.WAVPACK:
            throw new RuntimeException("Cannot transcode audio into wavpack");

        case AudioContainer.MUSEPACK:
            throw new RuntimeException("Cannot transcode audio into musepack");

        case AudioContainer.APE:
            throw new RuntimeException("Cannot transcode audio into ape");

        case AudioContainer.INVALID:
            throw new RuntimeException("Cannot transcode audio into invalid");
    }
    return "";
}

public AudioContainer getByName(String name)
{
    if (name !is null) {
        if (name.equals("*")) {
            return AudioContainer.ANY;
        }
        if (name.equals("mp3")) {
            return AudioContainer.MP3;
        }
        if (name.equals("mp2")) {
            return AudioContainer.MP2;
        }
        if (name.equals("lpcm")) {
            return AudioContainer.LPCM;
        }
        if ((name.equals("asf")) || (name.equals("wmav1")) || (name.equals("wmav2"))) {
            return AudioContainer.ASF;
        }
        if ((name.equals("mov")) || (name.equals("mp4")) || (name.equals("aac"))) {
            return AudioContainer.MP4;
        }
        if (name.equals("flac")) {
            return AudioContainer.FLAC;
        }
        if (name.equals("ogg")) {
            return AudioContainer.OGG;
        }
        if (name.equals("flv")) {
            return AudioContainer.FLV;
        }
        if (name.equals("rtp")) {
            return AudioContainer.RTP;
        }
        if (name.equals("rtsp")) {
            return AudioContainer.RTSP;
        }
        if (name.equals("adts")) {
            return AudioContainer.ADTS;
        }
        if (name.equals("wavpack")) {
            return AudioContainer.WAVPACK;
        }
        if (name.equals("ape")) {
            return AudioContainer.APE;
        }
        if ((name.startsWith("musepack")) || (name.equals("mpc"))) {
            return AudioContainer.MUSEPACK;
        }
    }
    return AudioContainer.INVALID;
}

/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.AudioContainer
* JD-Core Version:    0.7.0.1
*/