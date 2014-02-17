module org.serviio.delivery.resource.transcode.TranscodingDefinition;

public abstract interface TranscodingDefinition
{
  public abstract Integer getAudioBitrate();
  
  public abstract Integer getAudioSamplerate();
  
  public abstract bool isForceInheritance();
  
  public abstract TranscodingConfiguration getTranscodingConfiguration();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.TranscodingDefinition
 * JD-Core Version:    0.7.0.1
 */