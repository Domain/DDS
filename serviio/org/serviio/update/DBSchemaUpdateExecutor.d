module org.serviio.update.DBSchemaUpdateExecutor;

import java.lang.String;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.serviio.config.Configuration;
import org.serviio.db.dao.DAOFactory;
import org.serviio.db.dao.PersistenceException;
import org.serviio.library.online.OnlineLibraryManager;
import org.serviio.update.dao.DBLogDAO;
import org.serviio.upnp.Device;
import org.serviio.upnp.service.contentdirectory.ContentDirectory;
import org.serviio.util.JdbcUtils;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DBSchemaUpdateExecutor
{
    private static Logger log;
    private static immutable String[] scripts = [ "script-0.1.sql", "script-0.1.1.sql", "script-0.2.sql", "script-0.3.1.sql", "script-0.4.sql", "script-0.4.1.sql", "script-0.4.2.sql", "script-0.5.sql", "script-0.5.1.sql", "script-0.6.sql", "script-0.6.1.sql", "script-0.6.2.sql", "script-1.0.sql", "script-1.1.sql", "script-1.2.sql", "script-1.2.1.sql", "script-1.3.sql", "script-1.4.sql" ];

    static this()
    {
        log = LoggerFactory.getLogger!(DBSchemaUpdateExecutor);
    }

    public static void updateDBSchema()
    {
        log.info("Checking if DB schema needs to be updated");
        List!(String) scriptsToRun = new ArrayList();
        foreach (String scriptFile ; scripts)
        {
            bool scriptRun = false;
            try
            {
                scriptRun = DAOFactory.getDBLogDAO().isScriptPresent(scriptFile);
            }
            catch (PersistenceException e)
            {
                log.debug_("Error reading db log table, probably doesn't exist yet. Will execute the script.");
            }
            if (!scriptRun) {
                scriptsToRun.add(scriptFile);
            }
        }
        if (scriptsToRun.size() > 0)
        {
            log.info("Updating DB schema");
            foreach (String scriptFile ; scriptsToRun) {
                try
                {
                    String sql = StringUtils.readStreamAsString(DBSchemaUpdateExecutor.class_.getResourceAsStream("/sql/" + scriptFile), "UTF-8");
                    JdbcUtils.executeBatchStatement(sql);
                }
                catch (IOException e)
                {
                    log.error(String.format("Cannot read script file %s", cast(Object[])[ scriptFile ]));
                }
            }
            log.info("Cleaning temporary cache");
            Device.getInstance().getCDS().incrementUpdateID();
            log.info("Cleaning persistent cache");
            OnlineLibraryManager.getInstance().removePersistentCaches();
            log.debug_("Setting a new database update ID");
            Configuration.setDatabaseUpdateId(StringUtils.generateRandomToken());
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.update.DBSchemaUpdateExecutor
* JD-Core Version:    0.7.0.1
*/