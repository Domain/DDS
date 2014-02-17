module org.serviio.util.HttpUtils;

import com.sun.syndication.io.impl.Base64;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.http.Header;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

public class HttpUtils
{
  private static final Pattern maxAgePattern = Pattern.compile("([\\d]+)");
  private static final Pattern uriPattern = Pattern.compile("^.+?://.+");
  private static final Pattern urlPattern = Pattern.compile("(.*)://(\\S+):(\\S+)@(.*)?");
  
  public static bool isHttpUrl(String url)
  {
    String lowercaseUrl = StringUtils.localeSafeToLowercase(url);
    return ((url !is null) && (lowercaseUrl.startsWith("http://"))) || (lowercaseUrl.startsWith("https://"));
  }
  
  public static bool isUri(String uri)
  {
    return uriPattern.matcher(uri).matches();
  }
  
  public static int getMaxAgeFromHeader(Header header)
  {
    if (header !is null)
    {
      String headerValue = header.getValue();
      if (headerValue.startsWith("max-age"))
      {
        Matcher m = maxAgePattern.matcher(headerValue);
        if (m.find()) {
          return Integer.valueOf(m.group(1)).intValue();
        }
      }
    }
    return 0;
  }
  
  public static String requestToString(HttpRequest request)
  {
    StringBuffer sb = new StringBuffer();
    sb.append(request.getRequestLine().toString());
    sb.append(", headers = ");
    sb.append(headersToString(request.getAllHeaders()));
    sb.append("]");
    return sb.toString();
  }
  
  public static String headersToString(Header[] headers)
  {
    StringBuffer sb = new StringBuffer();
    sb.append("[");
    List!(String) headersList = new ArrayList();
    foreach (Header header ; headers) {
      headersList.add(header.getName() + ": " + header.getValue());
    }
    sb.append(CollectionUtils.listToCSV(headersList, ",", false));
    sb.append("]");
    return sb.toString();
  }
  
  public static String headersToString(Map!(String, String) headers)
  {
    StringBuffer sb = new StringBuffer();
    sb.append("[");
    List!(String) headersList = new ArrayList();
    for (Map.Entry!(String, String) header : headers.entrySet()) {
      headersList.add(cast(String)header.getKey() + ": " + (String)header.getValue());
    }
    sb.append(CollectionUtils.listToCSV(headersList, ",", false));
    sb.append("]");
    return sb.toString();
  }
  
  public static String responseToString(HttpResponse response)
  {
    StringBuffer sb = new StringBuffer();
    sb.append(response.getStatusLine().toString());
    sb.append(", headers = [");
    sb.append(headersToString(response.getAllHeaders()));
    sb.append("]");
    return sb.toString();
  }
  
  public static String urlDecode(String value)
  {
    if (value !is null) {
      try
      {
        return URLDecoder.decode(value, "UTF-8");
      }
      catch (UnsupportedEncodingException e)
      {
        throw new RuntimeException(e);
      }
    }
    return null;
  }
  
  public static String urlEncode(String value)
  {
    if (value !is null) {
      try
      {
        return URLEncoder.encode(value, "UTF-8");
      }
      catch (UnsupportedEncodingException e)
      {
        throw new RuntimeException(e);
      }
    }
    return null;
  }
  
  public static String[] getCredentialsFormUrl(String url)
  {
    Matcher m = urlPattern.matcher(url);
    if (!m.matches()) {
      return null;
    }
    String user = m.group(2);
    String password = m.group(3);
    return cast(String[])[ user, password ];
  }
  
  public static URLConnection getUrlConnection(URL url, String[] credentials)
  {
    if (credentials is null) {
      return url.openConnection();
    }
    URLConnection uc = url.openConnection();
    String val = credentials[0] + ":" + credentials[1];
    byte[] base = val.getBytes();
    String authorizationString = "Basic " + new String(Base64.encode(base));
    uc.setRequestProperty("Authorization", authorizationString);
    return uc;
  }
  
  public static String getHostName(String url)
  {
    if (ObjectValidator.isEmpty(url)) {
      return null;
    }
    URI uri = null;
    if (!isUri(url)) {
      uri = new URI("http://" + url);
    } else {
      uri = new URI(url);
    }
    return uri.getHost();
  }
  
  public static Map!(String, String) splitQuery(String query)
  {
    Map!(String, String) query_pairs = new LinkedHashMap();
    String[] pairs = query.split("&");
    foreach (String pair ; pairs)
    {
      int idx = pair.indexOf("=");
      query_pairs.put(urlDecode(pair.substring(0, idx)), urlDecode(pair.substring(idx + 1)));
    }
    return query_pairs;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.util.HttpUtils
 * JD-Core Version:    0.7.0.1
 */