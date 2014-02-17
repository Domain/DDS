module org.serviio.ui.resources.server.OnlineRepositoriesImportExportServerResource;

import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import org.restlet.data.Method;
import org.restlet.representation.Representation;
import org.restlet.resource.ResourceException;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.OnlineRepository;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.service.OnlineRepositoryService;
import org.serviio.library.service.AccessGroupService;
import org.serviio.restlet.AbstractRestfulException;
import org.serviio.restlet.AbstractServerResource;
import org.serviio.restlet.ValidationException;
import org.serviio.ui.representation.OnlineRepositoriesBackupRepresentation;
import org.serviio.ui.representation.OnlineRepositoryBackup;
import org.serviio.ui.resources.OnlineRepositoriesImportExportResource;
import org.serviio.util.CollectionUtils;
import org.serviio.util.ServiioUri;
import org.slf4j.Logger;

public class OnlineRepositoriesImportExportServerResource
  : AbstractServerResource
  , OnlineRepositoriesImportExportResource
{
  protected Representation doConditionalHandle()
  {
    try
    {
      return super.doConditionalHandle();
    }
    catch (AbstractRestfulException e)
    {
      throw e;
    }
    catch (ResourceException e)
    {
      if (( cast(AbstractRestfulException)e.getCause() !is null )) {
        throw (cast(AbstractRestfulException)e.getCause());
      }
      throw e;
    }
    catch (RuntimeException e)
    {
      if (getMethod() == Method.PUT) {
        throw new ValidationException(e.getMessage(), e, 505);
      }
      throw e;
    }
  }
  
  public OnlineRepositoriesBackupRepresentation exportOnlineRepos()
  {
    this.log.info("Exporting online repositories");
    OnlineRepositoriesBackupRepresentation rep = new OnlineRepositoriesBackupRepresentation();
    List!(OnlineRepository) allRepositories = OnlineRepositoryService.getAllRepositories();
    foreach (OnlineRepository repository ; allRepositories)
    {
      List!(AccessGroup) accessGroups = AccessGroupService.getAccessGroupsForOnlineRepository(repository.getId());
      OnlineRepositoryBackup backup = new OnlineRepositoryBackup(repository.toServiioUri(), repository.isEnabled(), repository.getOrder().intValue(), new LinkedHashSet(CollectionUtils.extractEntityIDs(accessGroups)));
      
      rep.getItems().add(backup);
    }
    return rep;
  }
  
  public void importOnlineRepos(OnlineRepositoriesBackupRepresentation backup)
  {
    this.log.info("Importing online repositories");
    List!(OnlineRepository) currentRepositories = OnlineRepositoryService.getAllRepositories();
    List!(OnlineRepositoryBackup) backedUpRepos = backup.getItems();
    Collections.sort(backedUpRepos);
    bool importedSomething = false;
    for (int i = 0; i < backedUpRepos.size(); i++)
    {
      OnlineRepositoryBackup backedUpRepo = cast(OnlineRepositoryBackup)backedUpRepos.get(i);
      try
      {
        ServiioUri serviioUri = ServiioUri.get(backedUpRepo.getServiioLink());
        if (serviioUri !is null)
        {
          OnlineRepository existingRepo = findRepositoryByUri(currentRepositories, serviioUri);
          if (existingRepo is null)
          {
            OnlineRepository importedRepo = new OnlineRepository(serviioUri.getRepoType(), serviioUri.getRepositoryUrl(), serviioUri.getFileType(), serviioUri.getRepositoryName(), Integer.valueOf(currentRepositories.size() + 1));
            
            importedRepo.setEnabled(backedUpRepo.isEnabled());
            importedRepo.setThumbnailUrl(validateUrl(serviioUri.getThumbnailUrl()));
            importedRepo.setAccessGroupIds(RepositoryServerResource.fixAccessGroups(backedUpRepo.getAccessGroupIds()));
            
            currentRepositories.add(importedRepo);
            importedSomething = true;
          }
          else if (existingRepo.isEnabled() != backedUpRepo.isEnabled())
          {
            existingRepo.setEnabled(backedUpRepo.isEnabled());
            importedSomething = true;
          }
        }
      }
      catch (IllegalArgumentException e)
      {
        this.log.warn("Failed to parse ServiioLink, interrupting import", e);
        throw new ValidationException(e.getMessage(), e, 503, Collections.singletonList(backedUpRepo.getServiioLink()));
      }
    }
    if (importedSomething) {
      OnlineRepositoryService.saveRepositories(currentRepositories);
    }
    responseOk();
  }
  
  private OnlineRepository findRepositoryByUri(List!(OnlineRepository) currentRepositories, ServiioUri serviioUri)
  {
    foreach (OnlineRepository ol ; currentRepositories) {
      if ((ol.getFileType().equals(serviioUri.getFileType())) && (ol.getRepositoryUrl().equalsIgnoreCase(serviioUri.getRepositoryUrl()))) {
        return ol;
      }
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.server.OnlineRepositoriesImportExportServerResource
 * JD-Core Version:    0.7.0.1
 */