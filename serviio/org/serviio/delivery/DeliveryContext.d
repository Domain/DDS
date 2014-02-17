module org.serviio.delivery.DeliveryContext;

import org.serviio.delivery.subtitles.HardSubs;

public class DeliveryContext
{
  private bool localContent;
  private String userAgent;
  private HardSubs hardsubsSubtitlesFile;
  
  public static DeliveryContext local()
  {
    return new DeliveryContext(true, null);
  }
  
  public this(bool localContent, String userAgent)
  {
    this.localContent = localContent;
    this.userAgent = userAgent;
  }
  
  public bool isLocalContent()
  {
    return this.localContent;
  }
  
  public String getUserAgent()
  {
    return this.userAgent;
  }
  
  public HardSubs getHardsubsSubtitlesFile()
  {
    return this.hardsubsSubtitlesFile;
  }
  
  public void setHardsubsSubtitlesFile(HardSubs subtitlesFile)
  {
    this.hardsubsSubtitlesFile = subtitlesFile;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.DeliveryContext
 * JD-Core Version:    0.7.0.1
 */