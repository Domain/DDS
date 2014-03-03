module org.serviio.library.metadata.AbstractCDSLibraryIndexingListener;

import java.lang;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;
import org.serviio.upnp.Device;
import org.serviio.upnp.service.contentdirectory.ContentDirectory;
import org.serviio.util.ServiioThreadFactory;
import org.serviio.util.ThreadUtils;
import org.serviio.library.metadata.LibraryIndexingListener;
import org.serviio.library.metadata.MediaFileType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractCDSLibraryIndexingListener : LibraryIndexingListener
{
    private static Logger log;
    private static immutable int UPDATE_THREAD_INTERVAL_SECONDS = 5;
    private int threadUpdateInterval = 5;
    protected ContentDirectory cds = cast(ContentDirectory)Device.getInstance().getServiceById("urn:upnp-org:serviceId:ContentDirectory");
    private AtomicBoolean libraryUpdated = new AtomicBoolean(false);
    private String lastAddedFile;
    private int numberOfAddedFiles = 0;
    private Map!(MediaFileType, String) fileTypeUpdateIds = new HashMap();

    static this()
    {
        log = LoggerFactory.getLogger!(AbstractCDSLibraryIndexingListener);
    }

    public this()
    {
        ServiioThreadFactory.getInstance().newThread(new CDSNotifierThread(null), "CDS library notifier", true).start();

        storeNewUpdateId(MediaFileType.IMAGE);
        storeNewUpdateId(MediaFileType.VIDEO);
        storeNewUpdateId(MediaFileType.AUDIO);
    }

    public this(int intervalSeconds)
    {
        this();
        this.threadUpdateInterval = intervalSeconds;
    }

    public void resetForAdding()
    {
        this.lastAddedFile = null;
        this.numberOfAddedFiles = 0;
    }

    public void itemAdded(MediaFileType fileType, String file)
    {
        this.lastAddedFile = file;
        this.numberOfAddedFiles += 1;
        storeNewUpdateId(fileType);
        isLibraryUpdated().set(true);
    }

    public void itemDeleted(MediaFileType fileType, String file)
    {
        storeNewUpdateId(fileType);
        isLibraryUpdated().set(true);
    }

    public void itemUpdated(MediaFileType fileType, String file)
    {
        storeNewUpdateId(fileType);
        isLibraryUpdated().set(true);
    }

    protected abstract void performCDSUpdate();

    protected void notifyCDS()
    {
        log.debug_("Library updated, notifying CDS");
        performCDSUpdate();
        isLibraryUpdated().set(false);
    }

    public String getUpdateId(MediaFileType fileType)
    {
        return cast(String)this.fileTypeUpdateIds.get(fileType);
    }

    public AtomicBoolean isLibraryUpdated()
    {
        return this.libraryUpdated;
    }

    public String getLastAddedFile()
    {
        return this.lastAddedFile;
    }

    public int getNumberOfAddedFiles()
    {
        return this.numberOfAddedFiles;
    }

    private void storeNewUpdateId(MediaFileType fileType)
    {
        if (fileType !is null) {
            this.fileTypeUpdateIds.put(fileType, UUID.randomUUID().toString());
        }
    }

    private class CDSNotifierThread : Runnable
    {
        private this() {}

        public void run()
        {
            for (;;)
            {
                if (this.outer.isLibraryUpdated().get()) {
                    this.outer.notifyCDS();
                }
                ThreadUtils.currentThreadSleep(this.outer.threadUpdateInterval * 1000);
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.metadata.AbstractCDSLibraryIndexingListener
* JD-Core Version:    0.7.0.1
*/