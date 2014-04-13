/// Generate by tools
module java.util.concurrent.ScheduledExecutorService;

import java.lang.exceptions;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.Callable;

public interface ScheduledExecutorService : ExecutorService
{
    ScheduledFuture!T schedule(T)(Runnable command, long delay, TimeUnit unit);
    ScheduledFuture!T schedule(T)(Callable!T callable, long delay, TimeUnit unit);
}
