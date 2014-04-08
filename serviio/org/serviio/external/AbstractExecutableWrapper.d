module org.serviio.external.AbstractExecutableWrapper;

import java.lang.InterruptedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.serviio.external.ProcessExecutor;

public abstract class AbstractExecutableWrapper
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(AbstractExecutableWrapper);
    }

    protected static void executeSynchronously(ProcessExecutor executor)
    {
        executor.start();
        try
        {
            executor.join();
        }
        catch (InterruptedException e)
        {
            log.debug_("Interrupted executable invocation, killing the process");
            executor.stopProcess(false);
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.AbstractExecutableWrapper
* JD-Core Version:    0.7.0.1
*/