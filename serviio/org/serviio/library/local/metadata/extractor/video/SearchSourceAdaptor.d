module org.serviio.library.local.metadata.extractor.video.SearchSourceAdaptor;

import java.io.IOException;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.local.metadata.extractor.MetadataSourceNotAccessibleException;

public abstract interface SearchSourceAdaptor
{
  public abstract String search(VideoDescription paramVideoDescription);
  
  public abstract void retrieveMetadata(String paramString, VideoMetadata paramVideoMetadata);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.video.SearchSourceAdaptor
 * JD-Core Version:    0.7.0.1
 */