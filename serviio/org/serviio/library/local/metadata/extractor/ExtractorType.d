module org.serviio.library.local.metadata.extractor.ExtractorType;

import org.serviio.library.local.metadata.extractor.embedded.EmbeddedMetadataExtractor;
import org.serviio.library.local.metadata.extractor.video.OnlineVideoSourcesMetadataExtractor;
import org.serviio.library.local.metadata.extractor.MetadataExtractor;

public enum ExtractorType
{
    EMBEDDED,  COVER_IMAGE_IN_FOLDER,  ONLINE_VIDEO_SOURCES,  SWISSCENTER,  XBMC,  MYMOVIES,  UNKNOWN, 
}

public MetadataExtractor getExtractorInstance(ExtractorType type)
{
    final switch (type)
    {
        case ExtractorType.EMBEDDED:
            return new EmbeddedMetadataExtractor();

        case ExtractorType.COVER_IMAGE_IN_FOLDER:
            return new CoverImageInFolderExtractor();

        case ExtractorType.ONLINE_VIDEO_SOURCES:
            return new OnlineVideoSourcesMetadataExtractor();

        case ExtractorType.SWISSCENTER:
            return new SwissCenterExtractor();

        case ExtractorType.XBMC:
            return new XBMCExtractor();

        case ExtractorType.MYMOVIES:
            return new MyMoviesExtractor();

        case ExtractorType.UNKNOWN:
            return null;
    }
}

public int getDefaultPriority(ExtractorType type)
{
    final switch (type)
    {
        case ExtractorType.EMBEDDED:
            return 0;

        case ExtractorType.COVER_IMAGE_IN_FOLDER:
            return 10;

        case ExtractorType.ONLINE_VIDEO_SOURCES:
            return 1;

        case ExtractorType.SWISSCENTER:
            return 2;

        case ExtractorType.XBMC:
            return 2;

        case ExtractorType.MYMOVIES:
            return 2;

        case ExtractorType.UNKNOWN:
            return 100;
    }
}

public bool isDescriptiveMetadataExtractor(ExtractorType type)
{
    switch (type)
    {
        case ExtractorType.EMBEDDED:
        case ExtractorType.COVER_IMAGE_IN_FOLDER:
            return false;

        case ExtractorType.ONLINE_VIDEO_SOURCES:
        case ExtractorType.SWISSCENTER:
        case ExtractorType.XBMC:
        case ExtractorType.MYMOVIES:
            return true;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.ExtractorType
* JD-Core Version:    0.7.0.1
*/