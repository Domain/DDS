module org.serviio.util.UnicodeReader;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PushbackInputStream;
import java.io.Reader;

public class UnicodeReader
  : Reader
{
  private static final int BOM_SIZE = 4;
  private final InputStreamReader reader;
  
  public this(InputStream in, String defaultEncoding)
  {
    byte[] bom = new byte[4];
    

    PushbackInputStream pushbackStream = new PushbackInputStream(in, 4);
    int n = pushbackStream.read(bom, 0, bom.length);
    int unread;
    String encoding;
    int unread;
    if ((bom[0] == -17) && (bom[1] == -69) && (bom[2] == -65))
    {
      String encoding = "UTF-8";
      unread = n - 3;
    }
    else
    {
      int unread;
      if ((bom[0] == -2) && (bom[1] == -1))
      {
        String encoding = "UTF-16BE";
        unread = n - 2;
      }
      else
      {
        int unread;
        if ((bom[0] == -1) && (bom[1] == -2))
        {
          String encoding = "UTF-16LE";
          unread = n - 2;
        }
        else
        {
          int unread;
          if ((bom[0] == 0) && (bom[1] == 0) && (bom[2] == -2) && (bom[3] == -1))
          {
            String encoding = "UTF-32BE";
            unread = n - 4;
          }
          else
          {
            int unread;
            if ((bom[0] == -1) && (bom[1] == -2) && (bom[2] == 0) && (bom[3] == 0))
            {
              String encoding = "UTF-32LE";
              unread = n - 4;
            }
            else
            {
              encoding = defaultEncoding;
              unread = n;
            }
          }
        }
      }
    }
    if (unread > 0) {
      pushbackStream.unread(bom, n - unread, unread);
    } else if (unread < -1) {
      pushbackStream.unread(bom, 0, 0);
    }
    if (encoding is null) {
      this.reader = new InputStreamReader(pushbackStream);
    } else {
      this.reader = new InputStreamReader(pushbackStream, encoding);
    }
  }
  
  public String getEncoding()
  {
    return this.reader.getEncoding();
  }
  
  public int read(char[] cbuf, int off, int len)
  {
    return this.reader.read(cbuf, off, len);
  }
  
  public void close()
  {
    this.reader.close();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.util.UnicodeReader
 * JD-Core Version:    0.7.0.1
 */