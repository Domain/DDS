module org.serviio.library.AbstractLibraryManager;

import org.serviio.library.metadata.AbstractLibraryCheckerThread;
import org.serviio.library.metadata.LibraryIndexingListener;
import org.serviio.util.ThreadUtils;

public abstract class AbstractLibraryManager
{
  protected LibraryIndexingListener cdsListener;
  
  protected void stopThread(AbstractLibraryCheckerThread thread)
  {
    if (thread !is null)
    {
      thread.stopWorker();
      while (thread.isAlive()) {
        ThreadUtils.currentThreadSleep(100L);
      }
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.AbstractLibraryManager
 * JD-Core Version:    0.7.0.1
 */