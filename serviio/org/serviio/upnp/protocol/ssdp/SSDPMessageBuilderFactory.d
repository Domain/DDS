module org.serviio.upnp.protocol.ssdp.SSDPMessageBuilderFactory;

import java.util.HashMap;
import java.util.Map;

public class SSDPMessageBuilderFactory
{
  private static SSDPMessageBuilderFactory instance;
  private Map!(SSDPMessageType, SSDPRequestMessageBuilder) builders;
  
  public static enum SSDPMessageType
  {
    ALIVE,  BYEBYE,  SEARCH;
    
    private this() {}
  }
  
  private this()
  {
    this.builders = new HashMap(3);
    this.builders.put(SSDPMessageType.ALIVE, new DeviceAliveMessageBuilder());
    this.builders.put(SSDPMessageType.BYEBYE, new DeviceUnavailableMessageBuilder());
    this.builders.put(SSDPMessageType.SEARCH, new RendererSearchMessageBuilder());
  }
  
  public static SSDPMessageBuilderFactory getInstance()
  {
    if (instance is null) {
      instance = new SSDPMessageBuilderFactory();
    }
    return instance;
  }
  
  public SSDPRequestMessageBuilder getBuilder(SSDPMessageType type)
  {
    return cast(SSDPRequestMessageBuilder)this.builders.get(type);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.ssdp.SSDPMessageBuilderFactory
 * JD-Core Version:    0.7.0.1
 */