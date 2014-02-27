module org.serviio.util.HttpClient;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HttpClient
{
    private static final Logger log = LoggerFactory.getLogger!(HttpClient);
    private static final int CONNECT_TIMEOUT = 20000;
    private static final int READ_TIMEOUT = 30000;

    public static String retrieveTextFileFromURL(String url, String encoding)
    {
        return StringUtils.readStreamAsString(getStreamFromURL(url), encoding);
    }

    public static String retrieveGZippedTextFileFromURL(String url, String encoding)
    {
        return StringUtils.readStreamAsString(ZipUtils.unGzipSingleFile(getStreamFromURL(url)), encoding);
    }

    public static byte[] retrieveBinaryFileFromURL(String url, String userAgent)
    {
        URLConnection connection = prepareConnection(url, userAgent);
        InputStream input = retrieveStreamFromConnection(connection, userAgent, true);
        return readBytesFromStream(input);
    }

    public static byte[] retrieveBinaryFileFromURL(String url)
    {
        return retrieveBinaryFileFromURL(url, null);
    }

    public static InputStream getStreamFromURL(String url)
    {
        URLConnection connection = prepareConnection(url, null);
        return retrieveStreamFromConnection(connection, null, false);
    }

    public static InputStream retrieveBinaryStreamFromURL(String url)
    {
        URLConnection connection = prepareConnection(url, null);
        return retrieveStreamFromConnection(connection, null, true);
    }

    public static InputStream getShoutCastStream(String urlString)
    {
        return IcyInputStream.create(urlString);
    }

    public static Integer getContentSize(URL contentURL)
    {
        try
        {
            URLConnection connection = contentURL.openConnection();
            int contentLength = connection.getContentLength();
            return Integer.valueOf(contentLength);
        }
        catch (IOException e) {}
        return null;
    }

    private static byte[] readBytesFromStream(InputStream input)
    {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();


        byte[] data = new byte[2048];
        int nRead;
        while ((nRead = input.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        buffer.flush();

        return buffer.toByteArray();
    }

    private static URLConnection prepareConnection(String url, String userAgent)
    {
        URL fileURL = new URL(url);
        URLConnection connection = HttpUtils.getUrlConnection(fileURL, HttpUtils.getCredentialsFormUrl(url));
        connection.setConnectTimeout(20000);
        connection.setReadTimeout(30000);
        if (ObjectValidator.isNotEmpty(userAgent)) {
            connection.setRequestProperty("User-Agent", userAgent);
        }
        return connection;
    }

    private static InputStream retrieveStreamFromConnection(URLConnection conn, String userAgent, bool binary)
    {
        if (( cast(HttpURLConnection)conn !is null ))
        {
            int status = (cast(HttpURLConnection)conn).getResponseCode();

            bool redirect = (status == 302) || (status == 301) || (status == 303);
            if (redirect)
            {
                String newUrl = conn.getHeaderField("Location");
                log.debug_("Redirect detected, opening target URL: " + newUrl);
                return retrieveStreamFromConnection(prepareConnection(newUrl, userAgent), userAgent, binary);
            }
            return binary ? conn.getInputStream() : cast(InputStream)conn.getContent();
        }
        return binary ? conn.getInputStream() : cast(InputStream)conn.getContent();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.HttpClient
* JD-Core Version:    0.7.0.1
*/