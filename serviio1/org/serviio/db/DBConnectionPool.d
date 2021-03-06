module org.serviio.db.DBConnectionPool;

import java.lang.String;
import java.lang.InterruptedException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Date;
import java.util.Enumeration;
import java.util.Vector;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class DBConnectionPool
{
    private static Logger log;
    private int checkedOut;
    private Vector!(Connection) freeConnections;
    private int maxConn;
    private String name;
    private String URL;

    static this()
    {
        log = LoggerFactory.getLogger!(DBConnectionPool)();
    }

    public this(String name, String URL, int maxConn)
    {
        freeConnections = new Vector!(Connection)();
        this.name = name;
        this.URL = URL;
        this.maxConn = maxConn;
    }
    
    public synchronized void freeConnection(Connection con)
    {
        if (con !is null) {
            (cast(Vector!Connection)freeConnections).addElement(con);
        }
        checkedOut -= 1;
        //notifyAll();
        if (log.isTraceEnabled())
            log.trace(String_format("Releasing connection from pool %s", cast(Object[])[ name ]));
    }

    public synchronized Connection getConnection(bool autoCommit)
    {
        Connection con = null;
        if ((cast(Vector!Connection)freeConnections).size() > 0)
        {
            con = cast(Connection)(cast(Vector!Connection)freeConnections).firstElement();
            (cast(Vector!Connection)freeConnections).removeElementAt(0);
            if (log.isTraceEnabled())
                log.trace(String_format("Getting pooled connection from pool %s", cast(Object[])[ name ]));
            try
            {
                if (con.isClosed()) {
                    if (log.isTraceEnabled()) {
                        log.trace("Removed bad connection from " + name);
                    }

                    con = getConnection(autoCommit);
                }
            } catch (SQLException e) {
                if (log.isTraceEnabled()) {
                    log.trace("Removed bad connection from " + name);
                }

                con = getConnection(autoCommit);
            }
        } else if ((maxConn == 0) || (checkedOut < maxConn)) {
            con = newConnection();
        }
        if (con !is null) {
            checkedOut += 1;
            con.setAutoCommit(autoCommit);
        }

        return con;
    }

    public synchronized Connection getConnection(long timeout, bool autoCommit)
    {
        long startTime = (new Date()).getTime();
        Connection con;
        while ((con = getConnection(autoCommit)) is null) {
            try {
                //wait(timeout);
            } catch (InterruptedException e) {
            }
            if ((new Date()).getTime() - startTime >= timeout)
            {
                return null;
            }
        }

        return con;
    }

    public synchronized void release()
    {
        Enumeration!(Connection) allConnections = (cast(Vector!Connection)freeConnections).elements();
        while (allConnections.hasMoreElements()) {
            Connection con = cast(Connection)((cast(Vector!Connection)freeConnections).nextElement());
            try {
                con.close();
                log.debug_("Closed connection for pool " ~ name);
            } catch (SQLException e) {
                log.debug_("Can't close connection for pool " ~ name, e);
            }
        }
        (cast(Vector!Connection)freeConnections).removeAllElements();
    }

    private synchronized Connection newConnection()
    {
        Connection con = null;
        try {
            con = DriverManager.getConnection(URL);
            if (log.isTraceEnabled())
                log.trace("Created a new connection in pool " ~ name);
        }
        catch (SQLException e) {
            log.warn("Can't create a new connection for " ~ URL, e);
            return null;
        }
        return con;
    }
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.db.DBConnectionPool
* JD-Core Version:    0.6.2
*/