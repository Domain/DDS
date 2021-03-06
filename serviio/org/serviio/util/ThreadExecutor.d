module org.serviio.util.ThreadExecutor;

import java.lang.Runnable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ThreadExecutor
{
    private static ExecutorService executor;

    static this()
    {
        executor = Executors.newFixedThreadPool(10);
    }

    public static void execute(Runnable r)
    {
        executor.execute(r);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.ThreadExecutor
* JD-Core Version:    0.7.0.1
*/