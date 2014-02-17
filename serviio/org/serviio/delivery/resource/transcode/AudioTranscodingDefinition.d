module org.serviio.delivery.resource.transcode.AudioTranscodingDefinition;

import java.util.ArrayList;
import java.util.List;
import org.serviio.dlna.AudioContainer;

public class AudioTranscodingDefinition
  : AbstractTranscodingDefinition
{
  private AudioContainer targetContainer;
  private List!(AudioTranscodingMatch) matches = new ArrayList();
  
  public this(TranscodingConfiguration parentConfig, AudioContainer targetContainer, Integer audioBitrate, Integer audioSamplerate, bool forceInheritance)
  {
    super(parentConfig);
    this.targetContainer = targetContainer;
    this.audioBitrate = audioBitrate;
    this.audioSamplerate = audioSamplerate;
    this.forceInheritance = forceInheritance;
  }
  
  public AudioContainer getTargetContainer()
  {
    return this.targetContainer;
  }
  
  public List!(AudioTranscodingMatch) getMatches()
  {
    return this.matches;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.AudioTranscodingDefinition
 * JD-Core Version:    0.7.0.1
 */