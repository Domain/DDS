module org.serviio.delivery.subtitles.SubtitlesReader;

import java.io.IOException;
import org.serviio.dlna.SubtitleCodec;

public abstract interface SubtitlesReader
{
  public abstract SubtitleCodec getSubtitleCodec();
  
  public abstract Long getExpectedSubtitlesSize();
  
  public abstract byte[] getSubtitlesAsSRT();
  
  public abstract HardSubs getSubtitlesInOriginalFormat();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.subtitles.SubtitlesReader
 * JD-Core Version:    0.7.0.1
 */