module org.serviio.delivery.resource.transcode.AbstractTranscodingDefinition;

public abstract class AbstractTranscodingDefinition
  : TranscodingDefinition
{
  private TranscodingConfiguration trConfig;
  protected Integer audioBitrate;
  protected Integer audioSamplerate;
  protected bool forceInheritance = false;
  
  protected this(TranscodingConfiguration trConfig)
  {
    this.trConfig = trConfig;
  }
  
  public Integer getAudioBitrate()
  {
    return this.audioBitrate;
  }
  
  public Integer getAudioSamplerate()
  {
    return this.audioSamplerate;
  }
  
  public bool isForceInheritance()
  {
    return this.forceInheritance;
  }
  
  public TranscodingConfiguration getTranscodingConfiguration()
  {
    return this.trConfig;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.AbstractTranscodingDefinition
 * JD-Core Version:    0.7.0.1
 */