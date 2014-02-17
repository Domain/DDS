module org.serviio.delivery.resource.transcode.TranscodedMediaInputStream;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import org.serviio.delivery.Client;
import org.serviio.util.ThreadUtils;

public class TranscodedMediaInputStream
  : FileInputStream
  , TranscodeInputStream
{
  private bool transcodeFinished = false;
  private Client client;
  
  public this(File file, Client client)
  {
    super(file);
    this.client = client;
  }
  
  public int available()
  {
    int av = super.available();
    if ((av < 0) && (!this.transcodeFinished)) {
      return 1;
    }
    return av;
  }
  
  public int read(byte[] b, int off, int len)
  {
    int n = -1;
    while (n == -1)
    {
      n = super.read(b, off, len);
      if ((n < 0) && (!this.transcodeFinished)) {
        ThreadUtils.currentThreadSleep(1000L);
      } else if ((n < 0) && (this.transcodeFinished)) {
        return n;
      }
    }
    return n;
  }
  
  public void setTranscodeFinished(bool transcodeFinished)
  {
    this.transcodeFinished = transcodeFinished;
  }
  
  public Client getClient()
  {
    return this.client;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.TranscodedMediaInputStream
 * JD-Core Version:    0.7.0.1
 */