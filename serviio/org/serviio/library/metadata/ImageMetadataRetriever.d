module org.serviio.library.metadata.ImageMetadataRetriever;

import java.lang.String;
import java.io.IOException;
import org.serviio.external.DCRawWrapper;
import org.serviio.library.local.metadata.ImageMetadata;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ImageMetadataRetriever
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(ImageMetadataRetriever);
    }

    public static void retrieveImageMetadata(ImageMetadata md, String imageLocation, bool local)
    {
        try
        {
            SanselanMetadataRetriever.retrieveImageMetadata(md, imageLocation, local);
        }
        catch (InvalidMediaFormatException e)
        {
            if (DCRawWrapper.dcrawPresent())
            {
                log.debug_("Unknown image format, trying raw format");
                DCRawMetadataRetriever.retrieveImageMetadata(md, imageLocation, local);
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.metadata.ImageMetadataRetriever
* JD-Core Version:    0.7.0.1
*/