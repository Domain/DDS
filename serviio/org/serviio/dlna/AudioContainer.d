module org.serviio.dlna.AudioContainer;

public enum AudioContainer
{
  ANY,  MP3,  MP2,  ASF,  LPCM,  MP4,  FLAC,  OGG,  FLV,  RTP,  RTSP,  ADTS,  WAVPACK,  MUSEPACK,  APE;
  
  private this() {}
  
  public abstract String getFFmpegContainerEncoderName();
  
  public static AudioContainer getByName(String name)
  {
    if (name !is null)
    {
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
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.dlna.AudioContainer
 * JD-Core Version:    0.7.0.1
 */