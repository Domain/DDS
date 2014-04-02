module org.serviio.upnp.service.contentdirectory.rest.resources.server.LoginServerResource;

import java.lang.String;
import java.util.Collections;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.config.Configuration;
import org.serviio.delivery.CDSUrlParameters;
import org.serviio.restlet.AuthenticationException;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.resources.LoginResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.TokenCache;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractCDSServerResource;
import org.serviio.util.ObjectValidator;
import org.serviio.util.SecurityUtils;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public class LoginServerResource : AbstractCDSServerResource, LoginResource
{
    private static immutable String X_SERVIIO_DATE_HEADER = "X-Serviio-Date";
    private static immutable String AUTH_HEADER = "Authorization";
    private static Pattern authHeaderPattern;
    private static TokenCache storedTokens;

    static this()
    {
        authHeaderPattern = Pattern.compile("Serviio\\s(.*)$", 2);
        storedTokens = new TokenCache("tokens");
    }

    public static void shutdownTokenCache()
    {
        storedTokens.shutdown();
    }

    public static void storeToken(String token)
    {
        storedTokens.storeToken(token);
    }

    public static void removeToken(String token)
    {
        storedTokens.evictToken(token);
    }

    public static void removeAllTokens()
    {
        storedTokens.evictAll();
    }

    public static void validateToken(String token)
    {
        if (ObjectValidator.isEmpty(token)) {
            throw new AuthenticationException("No authentication token has been provided for a restricted resource.", 553);
        }
        if (storedTokens.retrieveToken(token) !is null) {
            storeToken(token);
        } else if (!CDSUrlParameters.getSharedSecurityToken().equals(token)) {
            throw new AuthenticationException("The provided authentication token is invalid or expired.", 553);
        }
    }

    public ResultRepresentation login()
    {
        String webPassword = Configuration.getWebPassword();
        if (ObjectValidator.isEmpty(webPassword)) {
            throw new AuthenticationException("Cannot log in with an empty password.", 556);
        }
        Map!(String, String) requestHeaders = getRequestHeaders(getRequest());
        String authHeader = getHeaderStringValue("Authorization", requestHeaders);
        if (ObjectValidator.isEmpty(authHeader)) {
            throw new AuthenticationException("Cannot retrieve Auth header from authentication request.", 551);
        }
        String signature = getAuthenticationKey(authHeader);

        String dateHeader = getHeaderStringValue("X-Serviio-Date", requestHeaders);
        if (dateHeader is null) {
            dateHeader = getHeaderStringValue("Date", requestHeaders);
        }
        if (ObjectValidator.isEmpty(dateHeader)) {
            throw new AuthenticationException("Cannot retrieve Date header from authentication request.", 550);
        }
        String expectedSignature = generateExpectedKey(dateHeader, webPassword);
        if (expectedSignature.equals(signature))
        {
            this.log.debug_("Successful login, generating security token");
            String token = StringUtils.generateRandomToken();
            storeToken(token);
            ResultRepresentation result = responseOk();
            result.setParameters(Collections.singletonList(token));
            return result;
        }
        throw new AuthenticationException("Received authentication doesn't match, probably wrong password.", 552);
    }

    protected String generateExpectedKey(String date, String password)
    {
        try
        {
            return SecurityUtils.generateMacAsBase64(password, date, "HmacSHA1");
        }
        catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }

    protected String getAuthenticationKey(String headerHalue)
    {
        Matcher m = authHeaderPattern.matcher(headerHalue);
        String key = null;
        if (m.matches()) {
            key = m.group(1);
        }
        if (ObjectValidator.isEmpty(key)) {
            throw new AuthenticationException("Value of Auth header from authentication request is invalid.", 551);
        }
        return key;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.LoginServerResource
* JD-Core Version:    0.7.0.1
*/