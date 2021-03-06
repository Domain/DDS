module org.serviio.update.dao.DBLogDAOImpl;

import java.lang.String;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.serviio.db.DatabaseManager;
import org.serviio.db.dao.PersistenceException;
import org.serviio.util.JdbcUtils;
import org.serviio.update.dao.DBLogDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DBLogDAOImpl : DBLogDAO
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(DBLogDAOImpl);
    }

    public bool isScriptPresent(String fileScript)
    {
        log.debug_(java.lang.String.format("Checking if script '%s' has been run", cast(Object[])[ fileScript ]));
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = con.prepareStatement("SELECT count(id) as c FROM db_schema_version where script_file = ?");
            ps.setString(1, fileScript);
            ResultSet rs = ps.executeQuery();
            Integer count;
            if (rs.next())
            {
                count = Integer.valueOf(rs.getInt("c"));
                return count.intValue() != 0;
            }
            return 0;
        }
        catch (SQLException e)
        {
            throw new PersistenceException(java.lang.String.format("Cannot check if script '%s' has been run", cast(Object[])[ fileScript ]), e);
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.update.dao.DBLogDAOImpl
* JD-Core Version:    0.7.0.1
*/