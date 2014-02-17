module org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public enum ObjectClassType
{
  CONTAINER,  AUDIO_ITEM,  VIDEO_ITEM,  IMAGE_ITEM,  MOVIE,  MUSIC_TRACK,  PHOTO,  PLAYLIST_ITEM,  PLAYLIST_CONTAINER,  PERSON,  MUSIC_ARTIST,  GENRE,  MUSIC_GENRE,  ALBUM,  MUSIC_ALBUM,  STORAGE_FOLDER;
  
  private this() {}
  
  public abstract String getClassName();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.ObjectClassType
 * JD-Core Version:    0.7.0.1
 */