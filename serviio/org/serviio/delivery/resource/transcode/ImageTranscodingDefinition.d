module org.serviio.delivery.resource.transcode.ImageTranscodingDefinition;

import java.util.ArrayList;
import java.util.List;

public class ImageTranscodingDefinition
  : AbstractTranscodingDefinition
{
  private List!(ImageTranscodingMatch) matches = new ArrayList();
  
  public this(TranscodingConfiguration parentConfig, bool forceInheritance)
  {
    super(parentConfig);
    this.forceInheritance = forceInheritance;
  }
  
  public List!(ImageTranscodingMatch) getMatches()
  {
    return this.matches;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.ImageTranscodingDefinition
 * JD-Core Version:    0.7.0.1
 */