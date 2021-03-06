module org.serviio.db.DBConnectionPool;

import java.lang;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Date;
import java.util.Enumeration;
import java.util.Vector;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/*synchronized*/ class DBConnectionPool
{
    private static Logger log;
    private int checkedOut;
    private Vector!(Connection) freeConnections = new Vector!(Connection)();
    private int maxConn;
    private String name;
    private String URL;

    static this()
    {
        log = LoggerFactory.getLogger!(DBConnectionPool);
    }

    public this(String name, String URL, int maxConn)
    {
        this.name = name;
        this.URL = URL;
        this.maxConn = maxConn;
    }

    public /*synchronized*/ void freeConnection(Connection con)
    {
        if (con !is null) {
            this.freeConnections.addElement(con);
        }
        this.checkedOut -= 1;
        //notifyAll();
        if (log.isTraceEnabled()) {
            log.trace(String_format("Releasing connection from pool %s", cast(Object[])[ this.name ]));
        }
    }

    public /*synchronized*/ Connection getConnection(bool autoCommit)
    {
        Connection con = null;
        if (this.freeConnections.size() > 0)
        {
            con = cast(Connection)this.freeConnections.firstElement();
            this.freeConnections.removeElementAt(0);
            if (log.isTraceEnabled()) {
                log.trace(String_format("Getting pooled connection from pool %s", cast(Object[])[ this.name ]));
            }
            try
            {
                if (con.isClosed())
                {
                    if (log.isTraceEnabled()) {
                        log.trace("Removed bad connection from " ~ this.name);
                    }
                    con = getConnection(autoCommit);
                }
            }
            catch (SQLException e)
            {
                if (log.isTraceEnabled()) {
                    log.trace("Removed bad connection from " ~ this.name);
                }
                con = getConnection(autoCommit);
            }
        }
        else if ((this.maxConn == 0) || (this.checkedOut < this.maxConn))
        {
            con = newConnection();
        }
        if (con !is null)
        {
            this.checkedOut += 1;
            con.setAutoCommit(autoCommit);
        }
        return con;
    }

    public /*synchronized*/ Connection getConnection(long timeout, bool autoCommit)
    {
        long startTime = new Date().getTime();
        Connection con;
        while ((con = getConnection(autoCommit)) is null)
        {
            try
            {
                //wait(timeout);
            }
            catch (InterruptedException e) {}
            if (new Date().getTime() - startTime >= timeout) {
                return null;
            }
        }
        return con;
    }

    public /*synchronized*/ void release()
    {
        Enumeration!(Connection) allConnections = this.freeConnections.elements();
        while (allConnections.hasMoreElements())
        {
            Connection con = cast(Connection)allConnections.nextElement();
            try
            {
                con.close();
                log.debug_("Closed connection for pool " ~ this.name);
            }
            catch (SQLException e)
            {
                log.debug_("Can't close connection for pool " ~ this.name, e);
            }
        }
        this.freeConnections.removeAllElements();
    }

    private Connection newConnection()
    {
        Connection con = null;
        try
        {
            con = DriverManager.getConnection(this.URL);
            if (log.isTraceEnabled()) {
                log.trace("Created a new connection in pool " ~ this.name);
            }
        }
        catch (SQLException e)
        {
            log.warn("Can't create a new connection for " ~ this.URL, e);
            return null;
        }
        return con;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.db.DBConnectionPool
* JD-Core Version:    0.7.0.1
*/