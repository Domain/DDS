module org.serviio.library.local.metadata.extractor.embedded.LPCMExtractionStrategy;

import org.serviio.dlna.AudioContainer;
import org.serviio.library.local.metadata.extractor.embedded.AudioExtractionStrategy;

public class LPCMExtractionStrategy : AudioExtractionStrategy
{
    override protected AudioContainer getContainer()
    {
        return AudioContainer.LPCM;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.LPCMExtractionStrategy
* JD-Core Version:    0.7.0.1
*/