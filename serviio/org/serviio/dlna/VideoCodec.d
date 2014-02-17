module org.serviio.dlna.VideoCodec;

public enum VideoCodec
{
  H264,  H263,  VC1,  MPEG4,  MSMPEG4,  MPEG2,  WMV,  MPEG1,  MJPEG,  FLV,  VP6,  VP8,  THEORA,  DV,  REAL;
  
  private this() {}
  
  public abstract String getFFmpegEncoderName();
  
  public static VideoCodec getByFFmpegValue(String ffmpegName)
  {
    if (ffmpegName !is null)
    {
      if (ffmpegName.equals("vc1")) {
        return VC1;
      }
      if (ffmpegName.equals("mpeg4")) {
        return MPEG4;
      }
      if (ffmpegName.startsWith("msmpeg4")) {
        return MSMPEG4;
      }
      if (ffmpegName.equals("mpeg2video")) {
        return MPEG2;
      }
      if (ffmpegName.equals("h264")) {
        return H264;
      }
      if ((ffmpegName.equals("wmv1")) || (ffmpegName.equals("wmv3")) || (ffmpegName.equals("wmv2"))) {
        return WMV;
      }
      if ((ffmpegName.equals("mpeg1video")) || (ffmpegName.equals("mpegvideo"))) {
        return MPEG1;
      }
      if ((ffmpegName.equals("mjpeg")) || (ffmpegName.equals("mjpegb"))) {
        return MJPEG;
      }
      if (ffmpegName.startsWith("vp6")) {
        return VP6;
      }
      if (ffmpegName.startsWith("vp8")) {
        return VP8;
      }
      if (ffmpegName.startsWith("flv")) {
        return FLV;
      }
      if (ffmpegName.equals("theora")) {
        return THEORA;
      }
      if (ffmpegName.equals("dvvideo")) {
        return DV;
      }
      if (ffmpegName.startsWith("h263")) {
        return H263;
      }
      if (ffmpegName.startsWith("rv")) {
        return REAL;
      }
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.dlna.VideoCodec
 * JD-Core Version:    0.7.0.1
 */