module org.serviio.config.dao.ConfigEntryDAO;

import java.util.List;
import org.serviio.config.entities.ConfigEntry;
import org.serviio.db.dao.GenericDAO;

public abstract interface ConfigEntryDAO
  : GenericDAO!(ConfigEntry)
{
  public abstract ConfigEntry findConfigEntryByName(String paramString);
  
  public abstract List!(ConfigEntry) findAllConfigEntries();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.config.dao.ConfigEntryDAO
 * JD-Core Version:    0.7.0.1
 */