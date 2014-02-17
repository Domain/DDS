module org.serviio.delivery.subtitles.ExternalFileSubtitlesReader;

import java.io.File;
import java.io.IOException;
import org.serviio.dlna.SubtitleCodec;
import org.serviio.external.FFMPEGWrapper;
import org.serviio.util.FileUtils;

public class ExternalFileSubtitlesReader
  : SubtitlesReader
{
  private File subtitlesFile;
  
  public this(File subtitlesFile)
  {
    this.subtitlesFile = subtitlesFile;
  }
  
  public Long getExpectedSubtitlesSize()
  {
    return Long.valueOf(this.subtitlesFile.length());
  }
  
  public SubtitleCodec getSubtitleCodec()
  {
    return SubtitleCodec.getByFileName(this.subtitlesFile.getName());
  }
  
  public byte[] getSubtitlesAsSRT()
  {
    if (getSubtitleCodec() == SubtitleCodec.SRT) {
      return FileUtils.readFileBytes(this.subtitlesFile);
    }
    return FFMPEGWrapper.transcodeSubtitleFileToSRT(this.subtitlesFile);
  }
  
  public HardSubs getSubtitlesInOriginalFormat()
  {
    return new HardSubs(FileUtils.getProperFilePath(this.subtitlesFile));
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.subtitles.ExternalFileSubtitlesReader
 * JD-Core Version:    0.7.0.1
 */