module java.util.concurrent.Executor;

import java.lang.Runnable;

public interface Executor {

    /**
    * Executes the given command at some time in the future.  The command
    * may execute in a new thread, in a pooled thread, or in the calling
    * thread, at the discretion of the <tt>Executor</tt> implementation.
    *
    * @param command the runnable task
    * @throws RejectedExecutionException if this task cannot be
    * accepted for execution.
    * @throws NullPointerException if command is null
    */
    void execute(Runnable command);
}