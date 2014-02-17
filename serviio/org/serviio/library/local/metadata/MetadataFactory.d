module org.serviio.library.local.metadata.MetadataFactory;

import org.serviio.library.metadata.MediaFileType;

public class MetadataFactory
{
  public static LocalItemMetadata getMetadataInstance(MediaFileType fileType)
  {
    if (fileType == MediaFileType.AUDIO) {
      return new AudioMetadata();
    }
    if (fileType == MediaFileType.VIDEO) {
      return new VideoMetadata();
    }
    return new ImageMetadata();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.MetadataFactory
 * JD-Core Version:    0.7.0.1
 */