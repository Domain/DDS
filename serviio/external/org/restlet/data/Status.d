/// Generate by tools
module org.restlet.data.Status;

import java.lang.exceptions;

public enum Status
{
    SUCCESS_OK,
    SUCCESS_PARTIAL_CONTENT,
    CLIENT_ERROR_REQUESTED_RANGE_NOT_SATISFIABLE,
}

public bool isRedirection(Status status)
{
    implMissing();
}
