/// Generate by tools
module java.util.concurrent.ExecutorService;

import java.lang.exceptions;
import java.lang.Runnable;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;
import java.util.List;
import java.util.Collection;

public interface ExecutorService : Executor
{
    void shutdown();
    List!Runnable shutdownNow();
    bool isShutdown();
    bool isTerminated();
    bool awaitTermination(long timeout, TimeUnit unit);
}
