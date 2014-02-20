module org.serviio.dlna.AudioContainer;

public enum AudioContainer
{
    ANY,  MP3,  MP2,  ASF,  LPCM,  MP4,  FLAC,  OGG,  FLV,  RTP,  RTSP,  ADTS,  WAVPACK,  MUSEPACK,  APE
}

public String getFFmpegContainerEncoderName(AudioContainer audioContainer)
{
    switch (audioContainer)
    {
        case ANY:
            throw new RuntimeException("Cannot transcode audio into any"); 

        case MP3:
            return "mp3"; 

        case ASF:
            throw new RuntimeException("Cannot transcode audio into asf"); 

        case LPCM:
            return "s16be"; 

        case MP4:
            throw new RuntimeException("Cannot transcode audio into mp4"); 

        case FLAC:
            throw new RuntimeException("Cannot transcode audio into flac"); 

        case OGG:
            throw new RuntimeException("Cannot transcode audio into ogg"); 

        case FLV:
            throw new RuntimeException("Cannot transcode audio into flv"); 

        case RTP:
            throw new RuntimeException("Cannot transcode audio into rtp"); 

        case RTSP:
            throw new RuntimeException("Cannot transcode audio into rtsp"); 

        case ADTS:
            throw new RuntimeException("Cannot transcode audio into adts");

        case WAVPACK:
            throw new RuntimeException("Cannot transcode audio into wavpack");

        case MUSEPACK:
            throw new RuntimeException("Cannot transcode audio into musepack");

        case APE:
            throw new RuntimeException("Cannot transcode audio into ape");
    }
    return "";
}

public AudioContainer getByName(String name)
{
    if (name !is null) {
        if (name.equals("*")) {
            return ANY;
        }
        if (name.equals("mp3")) {
            return MP3;
        }
        if (name.equals("mp2")) {
            return MP2;
        }
        if (name.equals("lpcm")) {
            return LPCM;
        }
        if ((name.equals("asf")) || (name.equals("wmav1")) || (name.equals("wmav2"))) {
            return ASF;
        }
        if ((name.equals("mov")) || (name.equals("mp4")) || (name.equals("aac"))) {
            return MP4;
        }
        if (name.equals("flac")) {
            return FLAC;
        }
        if (name.equals("ogg")) {
            return OGG;
        }
        if (name.equals("flv")) {
            return FLV;
        }
        if (name.equals("rtp")) {
            return RTP;
        }
        if (name.equals("rtsp")) {
            return RTSP;
        }
        if (name.equals("adts")) {
            return ADTS;
        }
        if (name.equals("wavpack")) {
            return WAVPACK;
        }
        if (name.equals("ape")) {
            return APE;
        }
        if ((name.startsWith("musepack")) || (name.equals("mpc"))) {
            return MUSEPACK;
        }
    }
    return null;
}

/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.AudioContainer
* JD-Core Version:    0.7.0.1
*/