module org.serviio.upnp.webserver.AbstractDescriptionRequestHandler;

import java.lang.String;
import java.util.Date;
import org.apache.http.Header;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.MethodNotSupportedException;
import org.apache.http.RequestLine;
import org.serviio.upnp.webserver.AbstractRequestHandler;
import org.serviio.util.DateUtils;
import org.serviio.util.StringUtils;

public abstract class AbstractDescriptionRequestHandler : AbstractRequestHandler
{
    override protected void checkMethod(HttpRequest request)
    {
        String method = StringUtils.localeSafeToUppercase(request.getRequestLine().getMethod());
        if (!method.equals("GET")) {
            throw new MethodNotSupportedException(method + " method not supported");
        }
    }

    protected void prepareSuccessfulHttpResponse(HttpRequest request, HttpResponse response)
    {
        Header acceptLanguageHeader = request.getFirstHeader("ACCEPT-LANGUAGE");
        response.setStatusCode(200);
        if ((acceptLanguageHeader !is null) && (acceptLanguageHeader.getValue() !is null)) {
            response.addHeader("CONTENT-LANGUAGE", "en-gb");
        }
        response.addHeader("DATE", DateUtils.formatRFC1123(new Date()));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.webserver.AbstractDescriptionRequestHandler
* JD-Core Version:    0.7.0.1
*/