module org.serviio.ui.resources.OnlineRepositoriesImportExportResource;

import org.restlet.resource.Get;
import org.restlet.resource.Put;
import org.serviio.ui.representation.OnlineRepositoriesBackupRepresentation;

public abstract interface OnlineRepositoriesImportExportResource
{
  //@Get("xml")
  public abstract OnlineRepositoriesBackupRepresentation exportOnlineRepos();
  
  //@Put("xml")
  public abstract void importOnlineRepos(OnlineRepositoriesBackupRepresentation paramOnlineRepositoriesBackupRepresentation);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.OnlineRepositoriesImportExportResource
 * JD-Core Version:    0.7.0.1
 */