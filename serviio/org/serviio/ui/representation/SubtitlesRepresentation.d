module org.serviio.ui.representation.SubtitlesRepresentation;

public class SubtitlesRepresentation
{
  private bool subtitlesEnabled;
  private bool embeddedSubtitlesExtractionEnabled;
  private bool hardSubsEnabled;
  private bool hardSubsForced;
  private String preferredLanguage;
  private String hardSubsCharacterEncoding;
  
  public bool isSubtitlesEnabled()
  {
    return this.subtitlesEnabled;
  }
  
  public void setSubtitlesEnabled(bool subtitlesEnabled)
  {
    this.subtitlesEnabled = subtitlesEnabled;
  }
  
  public bool isHardSubsEnabled()
  {
    return this.hardSubsEnabled;
  }
  
  public void setHardSubsEnabled(bool hardSubsEnabled)
  {
    this.hardSubsEnabled = hardSubsEnabled;
  }
  
  public bool isHardSubsForced()
  {
    return this.hardSubsForced;
  }
  
  public void setHardSubsForced(bool hardSubsForced)
  {
    this.hardSubsForced = hardSubsForced;
  }
  
  public String getPreferredLanguage()
  {
    return this.preferredLanguage;
  }
  
  public void setPreferredLanguage(String preferredLanguage)
  {
    this.preferredLanguage = preferredLanguage;
  }
  
  public bool isEmbeddedSubtitlesExtractionEnabled()
  {
    return this.embeddedSubtitlesExtractionEnabled;
  }
  
  public void setEmbeddedSubtitlesExtractionEnabled(bool embeddedSubtitlesExtractionEnabled)
  {
    this.embeddedSubtitlesExtractionEnabled = embeddedSubtitlesExtractionEnabled;
  }
  
  public String getHardSubsCharacterEncoding()
  {
    return this.hardSubsCharacterEncoding;
  }
  
  public void setHardSubsCharacterEncoding(String hardSubsCharacterEncoding)
  {
    this.hardSubsCharacterEncoding = hardSubsCharacterEncoding;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.SubtitlesRepresentation
 * JD-Core Version:    0.7.0.1
 */