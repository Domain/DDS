/// Generate by tools
module java.util.concurrent.Future;

import java.lang.exceptions;
import java.util.concurrent.TimeUnit;

public interface Future(T)
{
    bool cancel(bool mayInterruptIfRunning);
    bool isCancelled();
    bool isDone();
    T get();
    T get(long timeout, TimeUnit unit);
}
