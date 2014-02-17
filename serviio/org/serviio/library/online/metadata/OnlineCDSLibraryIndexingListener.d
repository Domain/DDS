module org.serviio.library.online.metadata.OnlineCDSLibraryIndexingListener;

import org.serviio.library.metadata.AbstractCDSLibraryIndexingListener;
import org.serviio.upnp.service.contentdirectory.ContentDirectory;

public class OnlineCDSLibraryIndexingListener
  : AbstractCDSLibraryIndexingListener
{
  protected void performCDSUpdate()
  {
    this.cds.incrementUpdateID(false);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.metadata.OnlineCDSLibraryIndexingListener
 * JD-Core Version:    0.7.0.1
 */