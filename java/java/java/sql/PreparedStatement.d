/// Generate by tools
module java.sql.PreparedStatement;

import java.lang.String;
import java.lang.exceptions;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;

public class PreparedStatement : Statement
{
    public this()
    {
        implMissing();
    }

    public void setString(int index, String value)
    {
        implMissing();
    }

    public void setLong(int index, long value)
    {
        implMissing();
    }

    public void setInt(int index, int value)
    {
        implMissing();
    }

    public void setTimestamp(int index, Timestamp value)
    {
        implMissing();
    }

    public void executeUpdate()
    {
        implMissing();
    }

    public ResultSet executeQuery()
    {
        implMissing();
        return new ResuleSet();
    }
}
