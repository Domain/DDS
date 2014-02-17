module org.serviio.delivery.resource.transcode.TranscodeInputStream;

import java.io.Closeable;
import org.serviio.delivery.Client;

public abstract interface TranscodeInputStream
  : Closeable
{
  public abstract void setTranscodeFinished(bool paramBoolean);
  
  public abstract Client getClient();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.TranscodeInputStream
 * JD-Core Version:    0.7.0.1
 */