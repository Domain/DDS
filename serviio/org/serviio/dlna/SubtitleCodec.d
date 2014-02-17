module org.serviio.dlna.SubtitleCodec;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.serviio.util.FileUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;

public enum SubtitleCodec
{
  SRT,  ASS,  SUB,  SMI,  VTT,  MOV_TEXT,  UNKNOWN;
  
  private this() {}
  
  public abstract List!(String) getFileExtensions();
  
  public String getFFmpegEncoderName()
  {
    return null;
  }
  
  public static List!(String) getAllSupportedExtensions()
  {
    List!(String) all = new ArrayList();
    foreach (SubtitleCodec sc ; values()) {
      all.addAll(sc.getFileExtensions());
    }
    return all;
  }
  
  public static SubtitleCodec getByFileName(String subtitleFileName)
  {
    if (subtitleFileName !is null)
    {
      String extension = FileUtils.getFileExtension(subtitleFileName);
      if (ObjectValidator.isNotEmpty(extension))
      {
        String normalizedExtension = StringUtils.localeSafeToLowercase(extension);
        foreach (SubtitleCodec sc ; values()) {
          if (sc.getFileExtensions().contains(normalizedExtension)) {
            return sc;
          }
        }
      }
    }
    return null;
  }
  
  public static SubtitleCodec getByFFmpegValue(String ffmpegName)
  {
    if (ffmpegName !is null)
    {
      if ((ffmpegName.equals("srt")) || (ffmpegName.equals("subrip"))) {
        return SRT;
      }
      if (ffmpegName.equals("microdvd")) {
        return SUB;
      }
      if ((ffmpegName.equals("ass")) || (ffmpegName.equals("ssa"))) {
        return ASS;
      }
      if (ffmpegName.equals("sami")) {
        return SMI;
      }
      if (ffmpegName.equals("webvtt")) {
        return VTT;
      }
      if (ffmpegName.equals("mov_text")) {
        return MOV_TEXT;
      }
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.dlna.SubtitleCodec
 * JD-Core Version:    0.7.0.1
 */