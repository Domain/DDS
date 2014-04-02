module org.serviio.upnp.webserver.ServiioHttpService;

import java.io.IOException;
import org.apache.http.ConnectionReuseStrategy;
import org.apache.http.HttpException;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.HttpResponseFactory;
import org.apache.http.StatusLine;
import org.apache.http.protocol.HttpContext;
import org.apache.http.protocol.HttpProcessor;
import org.apache.http.protocol.HttpService;
import org.serviio.util.HttpUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ServiioHttpService : HttpService
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(ServiioHttpService);
    }

    public this(HttpProcessor proc, ConnectionReuseStrategy connStrategy, HttpResponseFactory responseFactory)
    {
        super(proc, connStrategy, responseFactory);
    }

    protected void doService(HttpRequest request, HttpResponse response, HttpContext context)
    {
        if (log.isDebugEnabled()) {
            log.debug_(String.format("Incoming request from %s: %s", cast(Object[])[ context.getAttribute("remote_ip_address"), HttpUtils.requestToString(request) ]));
        }
        super.doService(request, response, context);
        if (response.getStatusLine().getStatusCode() == 501) {
            response.setStatusCode(404);
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.webserver.ServiioHttpService
* JD-Core Version:    0.7.0.1
*/