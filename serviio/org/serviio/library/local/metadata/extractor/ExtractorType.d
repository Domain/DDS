module org.serviio.library.local.metadata.extractor.ExtractorType;

import org.serviio.library.local.metadata.extractor.embedded.EmbeddedMetadataExtractor;
import org.serviio.library.local.metadata.extractor.video.OnlineVideoSourcesMetadataExtractor;

public enum ExtractorType
{
  EMBEDDED,  COVER_IMAGE_IN_FOLDER,  ONLINE_VIDEO_SOURCES,  SWISSCENTER,  XBMC,  MYMOVIES;
  
  private this() {}
  
  public abstract MetadataExtractor getExtractorInstance();
  
  public abstract int getDefaultPriority();
  
  public abstract bool isDescriptiveMetadataExtractor();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.ExtractorType
 * JD-Core Version:    0.7.0.1
 */