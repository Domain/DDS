module org.serviio.upnp.service.contentdirectory.rest.resources.server.FlowPlayerKeyGeneratorServerResource;

import java.lang.String;
import java.security.MessageDigest;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.restlet.Request;
import org.restlet.data.Reference;
import org.restlet.representation.StringRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.resources.FlowPlayerKeyGeneratorResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractRestrictedCDSServerResource;
import org.serviio.util.SecurityUtils;
import org.slf4j.Logger;

public class FlowPlayerKeyGeneratorServerResource : AbstractRestrictedCDSServerResource , FlowPlayerKeyGeneratorResource
{
    private static immutable String PRIVATE_KEY = "8935e021454f50d9a18";
    private static Pattern DOMAIN_MATCHER;

    static this()
    {
        DOMAIN_MATCHER = Pattern.compile("^.*\\.(.+\\..+)$");
    }

    public StringRepresentation generate()
    {
        Request request = getRequest();
        String domain = getSubDomain(request.getReferrerRef().getHostDomain(true));
        this.log.debug_(java.lang.String.format("Generating security key for domain '%s'", cast(Object[])[ domain ]));
        return new StringRepresentation(generateKey(domain));
    }

    protected String getSubDomain(String host)
    {
        this.log.debug_(java.lang.String.format("RefererRef of the incoming request is '%s'", cast(Object[])[ host ]));
        Matcher m = DOMAIN_MATCHER.matcher(host);
        if ((m.matches()) && (m.groupCount() == 1)) {
            return m.group(1);
        }
        return host;
    }

    protected String generateKey(String domain)
    {
        String toEncode = String.format("%s%s", cast(Object[])[ domain, "8935e021454f50d9a18" ]);
        try
        {
            byte[] bytesOfMessage = toEncode.getBytes("UTF-8");
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] thedigest = md.digest(bytesOfMessage);
            return SecurityUtils.byteArrayToHex(thedigest).substring(11, 30);
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.FlowPlayerKeyGeneratorServerResource
* JD-Core Version:    0.7.0.1
*/