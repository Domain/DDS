module org.serviio.db.DatabaseManager;

import java.lang.String;
import java.lang.System;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.serviio.ApplicationSettings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.serviio.db.DBConnectionPool;

public class DatabaseManager
{
    private static const int MAX_POOL_CONNECTION = 20;
    private static const long CONNECTION_TIMEOUT = 2000L;
    private static Logger log;
    private static String DB_SCHEMA_URL;
    private static shared DBConnectionPool pool;

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
        } catch (SQLException e) {
            log.debug_("DB shutdown returned: " ~ e/*.getMessage()*/);
        }
    }

    public static void releasePool()
    {
        pool.release();
    }

    static this()
    {
        log = LoggerFactory.getLogger!(DatabaseManager)();
        pool = new shared(DBConnectionPool)("Serviio DB Pool", DB_SCHEMA_URL, MAX_POOL_CONNECTION);
        String systemURL = System.getProperty("dbURL");
        if (systemURL !is null)
            DB_SCHEMA_URL = systemURL;
        else
            DB_SCHEMA_URL = ApplicationSettings.getStringProperty("db_schema_url");
    }
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.db.DatabaseManager
* JD-Core Version:    0.6.2
*/