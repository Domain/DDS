module org.serviio.library.metadata.MediaFileType;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import org.serviio.util.CollectionUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;

public enum MediaFileType
{
  IMAGE,  VIDEO,  AUDIO;
  
  private this() {}
  
  public abstract String[] supportedFileExtensions();
  
  public static MediaFileType findMediaFileTypeByExtension(String extension)
  {
    for (MediaFileType mediaFileType : ) {
      foreach (String supportedExtension ; mediaFileType.supportedFileExtensions()) {
        if (extension.equalsIgnoreCase(supportedExtension)) {
          return mediaFileType;
        }
      }
    }
    return null;
  }
  
  public static MediaFileType findMediaFileTypeByMimeType(String mimeType)
  {
    if (ObjectValidator.isNotEmpty(mimeType))
    {
      String mimeTypeLC = StringUtils.localeSafeToLowercase(mimeType);
      if (mimeTypeLC.startsWith("audio")) {
        return AUDIO;
      }
      if (mimeTypeLC.startsWith("image")) {
        return IMAGE;
      }
      if (mimeTypeLC.startsWith("video")) {
        return VIDEO;
      }
    }
    return null;
  }
  
  public static Set!(MediaFileType) parseMediaFileTypesFromString(String fileTypesCSV)
  {
    Set!(MediaFileType) result = new HashSet();
    if (ObjectValidator.isNotEmpty(fileTypesCSV))
    {
      String[] fileTypes = fileTypesCSV.split(",");
      foreach (String fileType ; fileTypes) {
        result.add(valueOf(StringUtils.localeSafeToUppercase(fileType.trim())));
      }
    }
    return result;
  }
  
  public static String parseMediaFileTypesToString(Set!(MediaFileType) fileTypes)
  {
    return CollectionUtils.listToCSV(new ArrayList(fileTypes), ",", true);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.metadata.MediaFileType
 * JD-Core Version:    0.7.0.1
 */