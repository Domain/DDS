module org.serviio.library.local.metadata.CDSLibraryIndexingListener;

import org.serviio.library.metadata.AbstractCDSLibraryIndexingListener;
import org.serviio.upnp.service.contentdirectory.ContentDirectory;

public class CDSLibraryIndexingListener
  : AbstractCDSLibraryIndexingListener
{
  protected void performCDSUpdate()
  {
    this.cds.incrementUpdateID();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.CDSLibraryIndexingListener
 * JD-Core Version:    0.7.0.1
 */