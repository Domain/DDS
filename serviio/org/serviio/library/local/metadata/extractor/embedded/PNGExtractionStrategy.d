module org.serviio.library.local.metadata.extractor.embedded.PNGExtractionStrategy;

import java.io.IOException;
import org.apache.sanselan.common.byteSources.ByteSource;
import org.serviio.dlna.ImageContainer;
import org.serviio.library.local.metadata.ImageMetadata;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.serviio.library.local.metadata.extractor.embedded.ImageExtractionStrategy;

public class PNGExtractionStrategy : ImageExtractionStrategy
{
	override public void extractMetadata(ImageMetadata metadata, ByteSource f)
	{
		super.extractMetadata(metadata, f);
	}

	override protected ImageContainer getContainer()
	{
		return ImageContainer.PNG;
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.PNGExtractionStrategy
* JD-Core Version:    0.6.2
*/