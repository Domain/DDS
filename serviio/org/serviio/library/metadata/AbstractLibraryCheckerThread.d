module org.serviio.library.metadata.AbstractLibraryCheckerThread;

import java.lang;
import java.util.HashSet;
import java.util.Set;
import org.serviio.library.metadata.LibraryIndexingListener;
import org.serviio.library.metadata.MediaFileType;

public abstract class AbstractLibraryCheckerThread : Thread
{
    protected bool workerRunning = false;
    protected bool searchingForFiles = false;
    protected bool isSleeping = false;
    protected bool dontSleep = false;
    private Set!(LibraryIndexingListener) listeners = new HashSet();

    public void stopWorker()
    {
        this.workerRunning = false;

        interrupt();
    }

    public void invoke()
    {
        if (this.isSleeping) {
            interrupt();
        } else {
            this.dontSleep = true;
        }
    }

    public bool isWorkerRunning()
    {
        return this.workerRunning;
    }

    public bool isSearchingForFiles()
    {
        return this.searchingForFiles;
    }

    public void addListener(LibraryIndexingListener listener)
    {
        this.listeners.add(listener);
    }

    protected void notifyListenersAdd(MediaFileType fileType, String item)
    {
        foreach (LibraryIndexingListener l ; this.listeners) {
            l.itemAdded(fileType, item);
        }
    }

    protected void notifyListenersUpdate(MediaFileType fileType, String item)
    {
        foreach (LibraryIndexingListener l ; this.listeners) {
            l.itemUpdated(fileType, item);
        }
    }

    protected void notifyListenersRemove(MediaFileType fileType, String item)
    {
        foreach (LibraryIndexingListener l ; this.listeners) {
            l.itemDeleted(fileType, item);
        }
    }

    protected void notifyListenersResetForAdding()
    {
        foreach (LibraryIndexingListener l ; this.listeners) {
            l.resetForAdding();
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.metadata.AbstractLibraryCheckerThread
* JD-Core Version:    0.7.0.1
*/