module org.serviio.library.local.metadata.extractor.ExtractorType;

import org.serviio.library.local.metadata.extractor.embedded.EmbeddedMetadataExtractor;
import org.serviio.library.local.metadata.extractor.video.OnlineVideoSourcesMetadataExtractor;

public enum ExtractorType
{
    EMBEDDED,  COVER_IMAGE_IN_FOLDER,  ONLINE_VIDEO_SOURCES,  SWISSCENTER,  XBMC,  MYMOVIES
}
public MetadataExtractor getExtractorInstance(ExtractorType type)
{
    final switch (type)
    {
        case EMBEDDED:
            return new EmbeddedMetadataExtractor();

        case COVER_IMAGE_IN_FOLDER:
            return new CoverImageInFolderExtractor();

        case ONLINE_VIDEO_SOURCES:
            return new OnlineVideoSourcesMetadataExtractor();

        case SWISSCENTER:
            return new SwissCenterExtractor();

        case XBMC:
            return new XBMCExtractor();

        case MYMOVIES:
            return new MyMoviesExtractor();
    }
}

public int getDefaultPriority(ExtractorType type)
{
    final switch (type)
    {
        case EMBEDDED:
            return 0;

        case COVER_IMAGE_IN_FOLDER:
            return 10;

        case ONLINE_VIDEO_SOURCES:
            return 1;

        case SWISSCENTER:
            return 2;

        case XBMC:
            return 2;

        case MYMOVIES:
            return 2;
    }
}

public bool isDescriptiveMetadataExtractor(ExtractorType type)
{
    switch (type)
    {
        case EMBEDDED:
        case COVER_IMAGE_IN_FOLDER:
            return false;

        case ONLINE_VIDEO_SOURCES:
        case SWISSCENTER:
        case XBMC:
        case MYMOVIES:
            return true;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.ExtractorType
* JD-Core Version:    0.7.0.1
*/