module org.serviio.SystemProperties;

public abstract interface SystemProperties
{
  public static immutable String SERVIIO_HOME = "serviio.home";
  public static immutable String FFMPEG_LOCATION = "ffmpeg.location";
  public static immutable String DCRAW_LOCATION = "dcraw.location";
  public static immutable String PLUGINS_LOCATION = "plugins.location";
  public static immutable String PLUGINS_CHECK = "plugins.check";
  public static immutable String BOUND_ADDRESS = "serviio.boundAddr";
  public static immutable String REMOTE_HOST = "serviio.remoteHost";
  public static immutable String DB_URL = "dbURL";
  public static immutable String NETWORK_SOCKET_BUFFER = "serviio.socketBuffer";
  public static immutable String ADVERTISEMENT_DURATION = "serviio.advertisementDuration";
  public static immutable String DEFAULT_TRANSCODE_FOLDER = "serviio.defaultTranscodeFolder";
  public static immutable String USE_FIXED_POINT_ENCODERS = "serviio.fixedPointEncoders";
  public static immutable String ONLINE_CONTENT_TIMEOUT = "serviio.onlineContentTimeout";
  public static immutable String AUTO_CONSOLE_OPEN = "serviio.consoleOpen";
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.SystemProperties
 * JD-Core Version:    0.7.0.1
 */