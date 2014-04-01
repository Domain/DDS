module org.serviio.util.ProcessUtils;

import java.lang;
import java.lang.reflect.Field;
import org.jvnet.winp.WinProcess;
import org.serviio.external.ProcessExecutor;
import org.serviio.external.ProcessExecutorParameter;
import org.serviio.external.ProcessListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProcessUtils
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(ProcessUtils);
    }

    public static void destroy(Process p)
    {
        if (Platform.isWindows())
        {
            WinProcess wp = new WinProcess(p);
            log.debug_("Killing the Windows process: " ~ wp.getPid());
            wp.killRecursively();
        }
        else
        {
            destroyUnixProcess(p);
        }
    }

    private static Integer getProcessID(Process p)
    {
        Integer pid = null;
        if ((p !is null) && (p.getClass().getName().equals("java.lang.UNIXProcess"))) {
            try
            {
                Field f = p.getClass().getDeclaredField("pid");
                f.setAccessible(true);
                pid = Integer.valueOf(f.getInt(p));
            }
            catch (Throwable e)
            {
                log.debug_("Can't determine the Unix process ID: " ~ e.getMessage());
            }
        }
        return pid;
    }

    private static void destroyUnixProcess(Process p)
    {
        if (p !is null)
        {
            Integer pid = getProcessID(p);
            if (pid !is null) {
                kill(p, pid, 9);
            } else {
                p.destroy();
            }
        }
    }

    private static void kill(Process p, Integer pid, int signal)
    {
        log.debug_("Sending kill -" ~ signal ~ " to the Unix process: " ~ pid);
        ProcessExecutor pw = new ProcessExecutor(cast(ProcessExecutorParameter[])[ new ProcessExecutorParameter("kill"), new ProcessExecutorParameter("-" + signal), new ProcessExecutorParameter(pid.toString()) ]);

        pw.addListener(new TaskKillProcessListener(p));
        pw.run();
    }

    private static class TaskKillProcessListener : ProcessListener
    {
        private Process p;

        public this(Process p)
        {
            this.p = p;
        }

        override public void processEnded(bool success)
        {
            if (!success) {
                this.p.destroy();
            }
        }

        override public void outputUpdated(String updatedLine) {}

        override public void releaseResources() {}
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.ProcessUtils
* JD-Core Version:    0.7.0.1
*/