module org.serviio.db.DatabaseManager;

import java.lang;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.serviio.ApplicationSettings;
import org.serviio.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DatabaseManager
{
    private static Logger log;
    private static String DB_SCHEMA_URL;
    private static DBConnectionPool pool;
    private static enum MAX_POOL_CONNECTION = 20;
    private static enum CONNECTION_TIMEOUT = 2000L;

    static this()
    {
        log = LoggerFactory.getLogger!(DatabaseManager);
        String systemURL = System.getProperty("dbURL");
        if (systemURL !is null) {
            DB_SCHEMA_URL = systemURL;
        } else {
            DB_SCHEMA_URL = ApplicationSettings.getStringProperty("db_schema_url");
        }
        pool = new DBConnectionPool("Serviio DB Pool", DB_SCHEMA_URL, MAX_POOL_CONNECTION);
    }

    public static Connection getConnection()
    {
        return getConnection(true);
    }

    public static Connection getConnection(bool autoCommit)
    {
        return pool.getConnection(CONNECTION_TIMEOUT, autoCommit);
    }

    public static void releaseConnection(Connection con)
    {
        pool.freeConnection(con);
    }

    public static void stopDatabase()
    {
        try
        {
            log.info("Shutting down database");
            releasePool();
            DriverManager.getConnection("jdbc:derby:;shutdown=true");
        }
        catch (SQLException e)
        {
            log.debug_("DB shutdown returned: " ~ e.getMessage());
        }
    }

    public static void releasePool()
    {
        pool.release();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.db.DatabaseManager
* JD-Core Version:    0.7.0.1
*/