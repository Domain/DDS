module org.serviio.ui.resources.server.OnlinePluginsServerResource;

import java.util.Set;
import org.serviio.library.online.AbstractOnlineItemParser;
import org.serviio.library.online.AbstractUrlExtractor;
import org.serviio.restlet.AbstractServerResource;
import org.serviio.ui.representation.OnlinePlugin;
import org.serviio.ui.representation.OnlinePluginsRepresentation;
import org.serviio.ui.resources.OnlinePluginsResource;

public class OnlinePluginsServerResource
  : AbstractServerResource
  , OnlinePluginsResource
{
  public OnlinePluginsRepresentation load()
  {
    OnlinePluginsRepresentation rep = new OnlinePluginsRepresentation();
    foreach (AbstractUrlExtractor plugin ; AbstractOnlineItemParser.getListOfPlugins()) {
      rep.getPlugins().add(new OnlinePlugin(plugin.getExtractorName(), plugin.getVersion()));
    }
    return rep;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.server.OnlinePluginsServerResource
 * JD-Core Version:    0.7.0.1
 */