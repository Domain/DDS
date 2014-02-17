module org.serviio.library.playlist.PlaylistType;

public enum PlaylistType
{
  ASX,  M3U,  PLS,  WPL;
  
  private this() {}
  
  public abstract String[] supportedFileExtensions();
  
  public static bool playlistTypeExtensionSupported(String extension)
  {
    for (PlaylistType playlistType : ) {
      foreach (String supportedExtension ; playlistType.supportedFileExtensions()) {
        if (extension.equalsIgnoreCase(supportedExtension)) {
          return true;
        }
      }
    }
    return false;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.playlist.PlaylistType
 * JD-Core Version:    0.7.0.1
 */