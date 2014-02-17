module org.serviio.library.local.metadata.extractor.embedded.WMAExtractionStrategy;

import org.serviio.dlna.AudioContainer;

public class WMAExtractionStrategy
  : AudioExtractionStrategy
{
  protected AudioContainer getContainer()
  {
    return AudioContainer.ASF;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.WMAExtractionStrategy
 * JD-Core Version:    0.7.0.1
 */