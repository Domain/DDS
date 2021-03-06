module org.serviio.external.io.OutputTextReader;

import java.lang.String;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import org.serviio.external.ProcessExecutor;
import org.serviio.util.CollectionUtils;
import org.serviio.util.StringUtils;
import org.serviio.external.io.OutputReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OutputTextReader : OutputReader
{
    private static Logger log;
    private List!(String) lines = new ArrayList!(String)();
    private Object linesLock;
    private ProcessExecutor executor;

    static this()
    {
        log = LoggerFactory.getLogger!(OutputTextReader);
    }

    public this(ProcessExecutor executor, InputStream inputStream)
    {
        super(inputStream);
        this.linesLock = new Object();
        this.executor = executor;
    }

    override protected void processOutput()
    {
        BufferedReader br = null;
        try
        {
            br = new BufferedReader(new InputStreamReader(this.inputStream, Charset.defaultCharset()));
            String line = null;
            while ((line = br.readLine()) !is null) {
                if (line.length() > 0)
                {
                    addLine(line);

                    this.executor.notifyListenersOutputUpdated(line);

                    log.trace(line);
                }
            }
            return;
        }
        catch (IOException e)
        {
            log.warn(java.lang.String.format("Error reading output of an external command:" ~ e.getMessage(), new Object[0]));
        }
        finally
        {
            if (br !is null) {
                //try
                {
                    br.close();
                }
                //catch (Exception e) {}
            }
        }
    }

    override public ByteArrayOutputStream getOutputStream()
    {
        return null;
    }

    override public List!(String) getResults()
    {
        List!(String) clonedResults = new ArrayList!(String)();
        synchronized (this.linesLock)
        {
            clonedResults.addAll(this.lines);
        }
        return clonedResults;
    }

    public String getLast5Lines()
    {
        List!(String) all = getResults();
        if ((all is null) || (all.size() == 0)) {
            return null;
        }
        int start = std.algorithm.max(0, all.size() - 5);
        return CollectionUtils.listToCSV(all.subList(start, all.size()), StringUtils.LINE_SEPARATOR, true);
    }

    private void addLine(String line)
    {
        synchronized (this.linesLock)
        {
            this.lines.add(line);
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.io.OutputTextReader
* JD-Core Version:    0.7.0.1
*/