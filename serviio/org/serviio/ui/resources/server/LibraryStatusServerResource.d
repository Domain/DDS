module org.serviio.ui.resources.server.LibraryStatusServerResource;

import org.serviio.library.local.LibraryManager;
import org.serviio.restlet.AbstractServerResource;
import org.serviio.ui.representation.LibraryStatusRepresentation;
import org.serviio.ui.resources.LibraryStatusResource;

public class LibraryStatusServerResource
  : AbstractServerResource
  , LibraryStatusResource
{
  public LibraryStatusRepresentation load()
  {
    LibraryStatusRepresentation rep = new LibraryStatusRepresentation();
    LibraryManager manager = LibraryManager.getInstance();
    rep.setLibraryUpdatesCheckerRunning(manager.isUpdatesInProcess());
    rep.setLibraryAdditionsCheckerRunning(manager.isAdditionsInProcess());
    rep.setLastAddedFileName(manager.getLastAddedFileName());
    rep.setNumberOfAddedFiles(manager.getNumberOfRecentlyAddedFiles().intValue());
    return rep;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.server.LibraryStatusServerResource
 * JD-Core Version:    0.7.0.1
 */