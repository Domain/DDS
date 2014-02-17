module org.serviio.delivery.HttpDeliveryContainer;

import java.io.InputStream;
import java.util.Map;
import org.apache.http.ProtocolVersion;
import org.serviio.upnp.protocol.http.transport.TransferMode;

public class HttpDeliveryContainer
{
  private Map!(String, Object) responseHeaders;
  private InputStream contentStream;
  private bool partialContent;
  private ProtocolVersion requestHttpVersion;
  private Long fileSize;
  private TransferMode transferMode;
  private bool transcoded;
  
  public this(Map!(String, Object) responseHeaders)
  {
    this.responseHeaders = responseHeaders;
  }
  
  public this(Map!(String, Object) responseHeaders, InputStream contentStream, bool partialContent, ProtocolVersion requestHttpVersion, TransferMode transferMode, bool transcoded, Long fileSize)
  {
    this.responseHeaders = responseHeaders;
    this.contentStream = contentStream;
    this.partialContent = partialContent;
    this.requestHttpVersion = requestHttpVersion;
    this.fileSize = fileSize;
    this.transcoded = transcoded;
    this.transferMode = transferMode;
  }
  
  public Map!(String, Object) getResponseHeaders()
  {
    return this.responseHeaders;
  }
  
  public InputStream getContentStream()
  {
    return this.contentStream;
  }
  
  public bool isPartialContent()
  {
    return this.partialContent;
  }
  
  public ProtocolVersion getRequestHttpVersion()
  {
    return this.requestHttpVersion;
  }
  
  public Long getFileSize()
  {
    return this.fileSize;
  }
  
  public TransferMode getTransferMode()
  {
    return this.transferMode;
  }
  
  public bool isTranscoded()
  {
    return this.transcoded;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.HttpDeliveryContainer
 * JD-Core Version:    0.7.0.1
 */