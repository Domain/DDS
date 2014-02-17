module org.serviio.delivery.resource.transcode.TranscodingConfiguration;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.serviio.library.metadata.MediaFileType;

public class TranscodingConfiguration
{
  private bool keepStreamOpen = true;
  private Map!(MediaFileType, List!(TranscodingDefinition)) config = new HashMap();
  
  public List!(TranscodingDefinition) getDefinitions(MediaFileType fileType)
  {
    List!(TranscodingDefinition) result = cast(List)this.config.get(fileType);
    if (result !is null) {
      return Collections.unmodifiableList(cast(List)this.config.get(fileType));
    }
    return Collections.emptyList();
  }
  
  public List!(TranscodingDefinition) getDefinitions()
  {
    List!(TranscodingDefinition) result = new ArrayList();
    foreach (List!(TranscodingDefinition) configs ; this.config.values()) {
      result.addAll(configs);
    }
    return Collections.unmodifiableList(result);
  }
  
  public void addDefinition(MediaFileType fileType, TranscodingDefinition definition)
  {
    if (!this.config.containsKey(fileType)) {
      this.config.put(fileType, new ArrayList());
    }
    List!(TranscodingDefinition) defs = cast(List)this.config.get(fileType);
    defs.add(definition);
  }
  
  public bool isKeepStreamOpen()
  {
    return this.keepStreamOpen;
  }
  
  public void setKeepStreamOpen(bool keepStreamOpen)
  {
    this.keepStreamOpen = keepStreamOpen;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.TranscodingConfiguration
 * JD-Core Version:    0.7.0.1
 */