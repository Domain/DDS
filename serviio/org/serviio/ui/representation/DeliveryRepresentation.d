module org.serviio.ui.representation.DeliveryRepresentation;

public class DeliveryRepresentation
{
  private TranscodingRepresentation transcoding;
  private SubtitlesRepresentation subtitles;
  
  public TranscodingRepresentation getTranscoding()
  {
    return this.transcoding;
  }
  
  public void setTranscoding(TranscodingRepresentation transcoding)
  {
    this.transcoding = transcoding;
  }
  
  public SubtitlesRepresentation getSubtitles()
  {
    return this.subtitles;
  }
  
  public void setSubtitles(SubtitlesRepresentation subtitles)
  {
    this.subtitles = subtitles;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.DeliveryRepresentation
 * JD-Core Version:    0.7.0.1
 */