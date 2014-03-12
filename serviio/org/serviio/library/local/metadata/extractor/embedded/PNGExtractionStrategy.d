module org.serviio.library.local.metadata.extractor.embedded.PNGExtractionStrategy;

import java.io.IOException;
import org.apache.commons.imaging.common.bytesource.ByteSource;
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


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.PNGExtractionStrategy
* JD-Core Version:    0.7.0.1
*/