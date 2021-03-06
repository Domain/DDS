module org.serviio.external.io.OutputReader;

import java.lang;
import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

public abstract class OutputReader : Thread
{
    protected InputStream inputStream;

    public this(InputStream inputStream)
    {
        this.inputStream = new BufferedInputStream(inputStream);
    }

    override public final void run()
    {
        try
        {
            processOutput();
        }
        finally
        {
            closeStream();
        }
    }

    protected abstract void processOutput();

    public abstract OutputStream getOutputStream();

    public abstract List!(String) getResults();

    public void closeStream()
    {
        try
        {
            this.inputStream.close();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.io.OutputReader
* JD-Core Version:    0.7.0.1
*/