module org.serviio.external.io.OutputBytesReader;

import java.lang.String;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.serviio.external.io.OutputReader;

public class OutputBytesReader : OutputReader
{
    private static Logger log = LoggerFactory.getLogger!(OutputBytesReader);
    private ByteArrayOutputStream outputStream;

    public this(InputStream inputStream)
    {
        super(inputStream);
        this.outputStream = new ByteArrayOutputStream();
    }

    override protected void processOutput()
    {
        try
        {
            byte[] buf = new byte[500000];
            int n = 0;
            while ((n = this.inputStream.read(buf)) > 0) {
                this.outputStream.write(buf, 0, n);
            }
        }
        catch (IOException e)
        {
            log.warn(String.format("Error reading bytes stream from external process: %s", cast(Object[])[ e.getMessage() ]));
        }
    }

    override public ByteArrayOutputStream getOutputStream()
    {
        return this.outputStream;
    }

    override public List!(String) getResults()
    {
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.io.OutputBytesReader
* JD-Core Version:    0.7.0.1
*/