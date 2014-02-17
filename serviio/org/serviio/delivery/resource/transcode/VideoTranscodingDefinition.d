module org.serviio.delivery.resource.transcode.VideoTranscodingDefinition;

import java.util.ArrayList;
import java.util.List;
import org.serviio.dlna.AudioCodec;
import org.serviio.dlna.DisplayAspectRatio;
import org.serviio.dlna.VideoCodec;
import org.serviio.dlna.VideoContainer;

public class VideoTranscodingDefinition
  : AbstractTranscodingDefinition
{
  private VideoContainer targetContainer;
  private VideoCodec targetVideoCodec;
  private AudioCodec targetAudioCodec;
  private Integer maxVideoBitrate;
  private Integer maxHeight;
  private bool forceVTranscoding;
  private bool forceStereo;
  private DisplayAspectRatio dar;
  private List!(VideoTranscodingMatch) matches = new ArrayList();
  
  public this(TranscodingConfiguration parentConfig, VideoContainer targetContainer, VideoCodec targetVideoCodec, AudioCodec targetAudioCodec, Integer maxVideoBitrate, Integer maxHeight, Integer audioBitrate, Integer audioSamplerate, bool forceVTranscoding, bool forceStereo, bool forceInheritance, DisplayAspectRatio dar)
  {
    super(parentConfig);
    this.targetContainer = targetContainer;
    this.targetVideoCodec = targetVideoCodec;
    this.targetAudioCodec = targetAudioCodec;
    this.maxVideoBitrate = maxVideoBitrate;
    this.audioBitrate = audioBitrate;
    this.audioSamplerate = audioSamplerate;
    this.forceVTranscoding = forceVTranscoding;
    this.forceStereo = forceStereo;
    this.forceInheritance = forceInheritance;
    this.maxHeight = maxHeight;
    this.dar = dar;
  }
  
  public VideoContainer getTargetContainer()
  {
    return this.targetContainer;
  }
  
  public VideoCodec getTargetVideoCodec()
  {
    return this.targetVideoCodec;
  }
  
  public AudioCodec getTargetAudioCodec()
  {
    return this.targetAudioCodec;
  }
  
  public Integer getMaxVideoBitrate()
  {
    return this.maxVideoBitrate;
  }
  
  public List!(VideoTranscodingMatch) getMatches()
  {
    return this.matches;
  }
  
  public bool isForceVTranscoding()
  {
    return this.forceVTranscoding;
  }
  
  public bool isForceStereo()
  {
    return this.forceStereo;
  }
  
  public Integer getMaxHeight()
  {
    return this.maxHeight;
  }
  
  public DisplayAspectRatio getDar()
  {
    return this.dar;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.VideoTranscodingDefinition
 * JD-Core Version:    0.7.0.1
 */