module org.serviio.db.JdbcExecutor;

import java.lang.String;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.serviio.util.JdbcUtils;
import org.serviio.db.DatabaseManager;

public abstract class JdbcExecutor//(T)
{
    private static List!(String) lockErrorCodes;

    static this()
    {
        lockErrorCodes = Arrays.asList(cast(String[])[ "40XL1", "40XL2", "40001" ]);
    }

    public void executeUpdate()
    {
        Connection con = null;
        PreparedStatement ps = null;
        try
        {
            con = DatabaseManager.getConnection();
            ps = processStatement(con);
        }
        catch (SQLException e)
        {
            if (lockErrorCodes.contains(e.getSQLState())) {
                ps = processStatement(con);
            } else {
                throw e;
            }
        }
        finally
        {
            JdbcUtils.closeStatement(ps);
            DatabaseManager.releaseConnection(con);
        }
    }

    protected abstract PreparedStatement processStatement(Connection paramConnection);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.db.JdbcExecutor
* JD-Core Version:    0.7.0.1
*/