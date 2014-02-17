module org.serviio.upnp.service.contentdirectory.classes.ClassProperties;

public enum ClassProperties
{
  OBJECT_CLASS,  ID,  PARENT_ID,  TITLE,  CREATOR,  GENRE,  CHILD_COUNT,  REF_ID,  DESCRIPTION,  LONG_DESCRIPTION,  LANGUAGE,  PUBLISHER,  ACTOR,  DIRECTOR,  PRODUCER,  ARTIST,  RIGHTS,  RATING,  RESTRICTED,  SEARCHABLE,  ALBUM,  RESOURCE_URL,  RESOURCE_SIZE,  RESOURCE_DURATION,  RESOURCE_BITRATE,  RESOURCE_PROTOCOLINFO,  RESOURCE_CHANNELS,  RESOURCE_SAMPLE_FREQUENCY,  RESOURCE_RESOLUTION,  RESOURCE_COLOR_DEPTH,  ORIGINAL_TRACK_NUMBER,  DATE,  ALBUM_ART_URI,  ICON,  SUBTITLES_URL,  DCM_INFO,  MEDIA_CLASS,  LIVE,  ONLINE_DB_IDENTIFIERS,  CONTENT_TYPE;
  
  private this() {}
  
  public abstract String getAttributeName();
  
  public abstract String[] getPropertyFilterNames();
  
  public String getFirstPropertyXMLName()
  {
    int attributeSep = getPropertyFilterNames()[0].indexOf("@");
    if (attributeSep > -1) {
      return getPropertyFilterNames()[0].substring(attributeSep + 1);
    }
    return getPropertyFilterNames()[0];
  }
  
  public static ClassProperties getByFilterName(String filterName)
  {
    for (ClassProperties cp : ) {
      foreach (String fn ; cp.getPropertyFilterNames()) {
        if (fn.equalsIgnoreCase(filterName)) {
          return cp;
        }
      }
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.ClassProperties
 * JD-Core Version:    0.7.0.1
 */