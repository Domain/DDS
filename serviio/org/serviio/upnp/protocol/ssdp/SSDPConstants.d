module org.serviio.upnp.protocol.ssdp.SSDPConstants;

import org.serviio.MediaServer;

public class SSDPConstants
{
  public static immutable String SERVER = System.getProperty("os.name") + ", UPnP/1.0 DLNADOC/1.50, Serviio/" + MediaServer.VERSION;
  public static immutable String DEFAULT_MULTICAST_HOST = "239.255.255.250";
  public static final int DEFAULT_MULTICAST_PORT = 1900;
  public static final int DEFAULT_TTL = 4;
  public static final int DEFAULT_TIMEOUT = 250;
  public static final int ADVERTISEMENT_DURATION = 1800;
  public static final int ADVERTISEMENT_SEND_COUNT = 3;
  public static final int EVENT_SUBSCRIPTION_DURATION = 300;
  public static immutable String EVENT_SUBSCRIPTION_DURATION_INFINITE = "infinite";
  public static immutable String NTS_ALIVE = "ssdp:alive";
  public static immutable String NTS_BYEBYE = "ssdp:byebye";
  public static immutable String HTTP_METHOD_NOTIFY = "NOTIFY";
  public static immutable String HTTP_METHOD_SEARCH = "M-SEARCH";
  public static immutable String HTTP_METHOD_SUBSCRIBE = "SUBSCRIBE";
  public static immutable String HTTP_METHOD_UNSUBSCRIBE = "UNSUBSCRIBE";
  public static immutable String SEARCH_TARGET_ALL = "ssdp:all";
  public static immutable String SEARCH_TARGET_ROOT_DEVICE = "upnp:rootdevice";
  public static immutable String NOTIFICATION_TYPE_EVENT = "upnp:event";
  public static immutable String NOTIFICATION_SUBTYPE_EVENT = "upnp:propchange";
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.ssdp.SSDPConstants
 * JD-Core Version:    0.7.0.1
 */