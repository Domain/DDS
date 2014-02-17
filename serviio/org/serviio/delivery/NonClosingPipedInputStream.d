module org.serviio.delivery.NonClosingPipedInputStream;

import java.io.IOException;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import org.serviio.external.ProcessListener;

public class NonClosingPipedInputStream
  : PipedInputStream
  , ClosableStreamDelegator
{
  private final TimeoutStreamDelegator closingDelegator;
  
  public this(ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing)
  {
    this.closingDelegator = new TimeoutStreamDelegator(this, processListener, client, deliveryListener, forceClosing);
  }
  
  public this(int pipeSize, ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing)
  {
    super(pipeSize);
    this.closingDelegator = new TimeoutStreamDelegator(this, processListener, client, deliveryListener, forceClosing);
  }
  
  public this(PipedOutputStream src, int pipeSize, ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing)
  {
    super(src, pipeSize);
    this.closingDelegator = new TimeoutStreamDelegator(this, processListener, client, deliveryListener, forceClosing);
  }
  
  public this(PipedOutputStream src, ProcessListener processListener, Client client, DeliveryListener deliveryListener, bool forceClosing)
  {
    super(src);
    this.closingDelegator = new TimeoutStreamDelegator(this, processListener, client, deliveryListener, forceClosing);
  }
  
  public synchronized int read()
  {
    this.closingDelegator.onRead();
    return super.read();
  }
  
  public synchronized int read(byte[] b, int off, int len)
  {
    this.closingDelegator.onRead();
    return super.read(b, off, len);
  }
  
  public synchronized void close()
  {
    this.closingDelegator.close();
  }
  
  public void closeParent()
  {
    super.close();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.NonClosingPipedInputStream
 * JD-Core Version:    0.7.0.1
 */