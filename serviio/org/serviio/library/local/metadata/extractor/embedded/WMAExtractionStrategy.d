module org.serviio.library.local.metadata.extractor.embedded.WMAExtractionStrategy;

import org.serviio.dlna.AudioContainer;
import org.serviio.library.local.metadata.extractor.embedded.AudioExtractionStrategy;

public class WMAExtractionStrategy : AudioExtractionStrategy
{
	override protected AudioContainer getContainer()
	{
		return AudioContainer.ASF;
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.WMAExtractionStrategy
* JD-Core Version:    0.6.2
*/