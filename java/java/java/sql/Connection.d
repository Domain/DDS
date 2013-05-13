/// Generate by tools
module java.sql.Connection;

import java.lang.String;
import java.lang.exceptions;
import java.sql.PreparedStatement;

public class Connection
{
    public this()
    {
        implMissing();
    }

    public PreparedStatement prepareStatement(String statement)
    {
        return new PreparedStatement();
    }

    public PreparedStatement prepareStatement(String statement, int paramInt)
    {
        return new PreparedStatement();
    }

    public bool isClosed()
    {
        implMissing();
    }

    public void setAutoCommit(bool autoCommit)
    {
        implMissgin();
    }

    public void close()
    {
        implMissing();
    }
}
