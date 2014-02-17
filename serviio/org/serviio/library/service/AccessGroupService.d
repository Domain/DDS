module org.serviio.library.service.AccessGroupService;

import java.util.List;
import org.serviio.db.dao.DAOFactory;
import org.serviio.library.dao.AccessGroupDAO;
import org.serviio.library.entities.AccessGroup;
import org.serviio.licensing.LicensingManager;
import org.serviio.renderer.entities.Renderer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AccessGroupService
{
  private static final Logger log = LoggerFactory.getLogger!(AccessGroupService);
  
  public static AccessGroup getAccessGroupForRenderer(Renderer renderer)
  {
    if ((renderer is null) || (renderer.getAccessGroupId() is null))
    {
      log.debug_("Could not find a access group for renderer. Using ANY.");
      return AccessGroup.ANY;
    }
    if (!LicensingManager.getInstance().isProVersion()) {
      return AccessGroup.ANY;
    }
    AccessGroup profile = cast(AccessGroup)DAOFactory.getAccessGroupDAO().read(renderer.getAccessGroupId());
    if (profile is null)
    {
      log.debug_(String.format("Could not find a access group with id '%s' for renderer. Using ANY.", cast(Object[])[ renderer.getAccessGroupId() ]));
      return AccessGroup.ANY;
    }
    return profile;
  }
  
  public static List!(AccessGroup) getAccessGroupsForRepository(Long repositoryId)
  {
    return DAOFactory.getAccessGroupDAO().getAccessGroupsForRepository(repositoryId);
  }
  
  public static List!(AccessGroup) getAccessGroupsForOnlineRepository(Long repositoryId)
  {
    return DAOFactory.getAccessGroupDAO().getAccessGroupsForOnlineRepository(repositoryId);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.service.AccessGroupService
 * JD-Core Version:    0.7.0.1
 */