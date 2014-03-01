module org.serviio.util.ThreadUtils;

import java.lang.Runnable;

public class ThreadUtils
{
    public static void currentThreadSleep(long milliseconds)
    {
        try
        {
            Thread.sleep(milliseconds);
        }
        catch (InterruptedException e) {}
    }

    public static void runAsynchronously(Runnable runnable)
    {
        ServiioThreadFactory.getInstance().newThread(runnable).start();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.ThreadUtils
* JD-Core Version:    0.7.0.1
*/