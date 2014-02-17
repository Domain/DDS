module org.serviio.delivery.subtitles.SubtitlesInfo;

import org.serviio.delivery.ResourceInfo;

public class SubtitlesInfo
  : ResourceInfo
{
  public this(Long resourceId, Long fileSize, bool transcoded, String mimeType)
  {
    super(resourceId);
    this.fileSize = fileSize;
    this.mimeType = mimeType;
    this.transcoded = transcoded;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.subtitles.SubtitlesInfo
 * JD-Core Version:    0.7.0.1
 */