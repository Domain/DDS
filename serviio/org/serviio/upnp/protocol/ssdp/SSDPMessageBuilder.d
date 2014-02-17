module org.serviio.upnp.protocol.ssdp.SSDPMessageBuilder;

import java.util.List;

public abstract interface SSDPMessageBuilder
{
  public abstract List!(String) generateSSDPMessages(Integer paramInteger, String paramString);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.ssdp.SSDPMessageBuilder
 * JD-Core Version:    0.7.0.1
 */