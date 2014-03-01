module org.serviio.delivery.OnlineInputStream;

import java.lang;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Collections;
import java.util.List;
import org.restlet.Client;
import org.restlet.Request;
import org.restlet.Response;
import org.restlet.data.ChallengeResponse;
import org.restlet.data.ChallengeScheme;
import org.restlet.data.Method;
import org.restlet.data.Protocol;
import org.restlet.data.Range;
import org.restlet.data.Reference;
import org.restlet.data.Status;
import org.restlet.representation.EmptyRepresentation;
import org.restlet.representation.Representation;
import org.serviio.util.FileUtils;
import org.serviio.util.HttpClient;
import org.serviio.util.HttpUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OnlineInputStream : InputStream
{
    private static immutable int DEFAULT_CHUNK_SIZE = 1512000;
    private static Logger log = LoggerFactory.getLogger!(OnlineInputStream);
    private URL contentURL;
    private String[] credentials;
    private Long contentSize;
    private long pos;
    private int bufferPos;
    private /*volatile*/ byte[] onlineBuffer;
    bool allConsumed = false;
    bool supportsRange = true;
    private InputStream wholeStream;
    private Client restletClient = new Client(Protocol.HTTP);
    private int chunkSize = 1512000;

    public this(URL contentUrl, Long contentSize, bool supportsByterange)
    {
        this.contentURL = contentUrl;
        this.contentSize = contentSize;
        this.credentials = HttpUtils.getCredentialsFormUrl(contentUrl.toString());
        this.supportsRange = supportsByterange;
    }

    public this(URL contentUrl, Long contentSize, bool supportsByterange, int chunkSize)
    {
        this(contentUrl, contentSize, supportsByterange);
        this.chunkSize = chunkSize;
    }

    override public int read()
    {
        if ((this.supportsRange) || ((!this.supportsRange) && (this.wholeStream is null))) {
            try
            {
                if ((!this.allConsumed) && ((this.onlineBuffer is null) || (this.bufferPos >= this.chunkSize))) {
                    fill();
                }
                if ((this.onlineBuffer !is null) && (this.bufferPos < this.onlineBuffer.length))
                {
                    this.pos += 1L;
                    return this.onlineBuffer[(this.bufferPos++)] & 0xFF;
                }
                cleanup();
                return -1;
            }
            catch (RangeNotSupportedException e)
            {
                this.supportsRange = false;
                return this.wholeStream.read();
            }
        }
        return this.wholeStream.read();
    }

    override public long skip(long n)
    {
        if (this.supportsRange)
        {
            this.pos += n;
            try
            {
                fill();
            }
            catch (RangeNotSupportedException e)
            {
                this.supportsRange = false;
                return super.skip(n);
            }
            return n;
        }
        return this.wholeStream !is null ? this.wholeStream.skip(n) : 0L;
    }

    override public int available()
    {
        if (this.supportsRange)
        {
            if (this.onlineBuffer !is null) {
                return this.onlineBuffer.length - this.bufferPos;
            }
            return 0;
        }
        return this.wholeStream !is null ? this.wholeStream.available() : 0;
    }

    override public void close()
    {
        log.debug_("Closing stream");
        try
        {
            if (this.wholeStream !is null) {
                this.wholeStream.close();
            }
        }
        finally
        {
            cleanup();
        }
    }

    private void cleanup()
    {
        try
        {
            this.restletClient.stop();
            this.onlineBuffer = null;
        }
        catch (Exception e)
        {
            log.warn("Exception during HTTP client closing: " + e.getMessage());
        }
    }

    private void fill()
    {
        this.onlineBuffer = readFileChunk(this.pos, this.chunkSize);
        this.bufferPos = 0;
        if (this.onlineBuffer.length < this.chunkSize) {
            this.allConsumed = true;
        }
    }

    private byte[] readFileChunk(long startByte, long byteCount)
    {
        log.debug_(String.format("Reading %s bytes starting at %s", cast(Object[])[ Long.valueOf(byteCount), Long.valueOf(startByte) ]));
        Request request = new Request(Method.GET, this.contentURL.toString());
        if (this.credentials !is null)
        {
            ChallengeScheme scheme = ChallengeScheme.HTTP_BASIC;
            ChallengeResponse authentication = new ChallengeResponse(scheme, this.credentials[0], this.credentials[1]);
            request.setChallengeResponse(authentication);
        }
        if (this.supportsRange)
        {
            Range byteRange = new Range(startByte, byteCount);
            if ((this.contentSize !is null) && (startByte + byteCount > this.contentSize.longValue())) {
                byteRange = new Range(startByte, this.contentSize.longValue() - startByte);
            }
            List!(Range) ranges = Collections.singletonList(byteRange);
            request.setRanges(ranges);
        }
        Response response = this.restletClient.handle(request);
        if ((Status.SUCCESS_OK.equals(response.getStatus())) || (new Status(-1).equals(response.getStatus())))
        {
            log.debug_(String.format("Byte range not supported for %s, returning the whole stream", cast(Object[])[ this.contentURL.toString() ]));
            this.wholeStream = getResponseStream(response);
            throw new RangeNotSupportedException();
        }
        if (Status.SUCCESS_PARTIAL_CONTENT.equals(response.getStatus()))
        {
            InputStream content = getResponseStream(response);
            byte[] bytes = FileUtils.readFileBytes(content);
            log.debug_(String.format("Returning %s bytes from partial content response", cast(Object[])[ Integer.valueOf(bytes.length) ]));
            return bytes;
        }
        if (response.getStatus().isRedirection())
        {
            this.contentURL = response.getLocationRef().toUrl();
            log.debug_(String.format("302 returned, redirecting to %s", cast(Object[])[ this.contentURL ]));
            return readFileChunk(startByte, byteCount);
        }
        if (response.getStatus().equals(Status.CLIENT_ERROR_REQUESTED_RANGE_NOT_SATISFIABLE))
        {
            this.wholeStream = getResponseStream(response);
            log.debug_(String.format("Byte range not satisfiable for %s, returning the whole stream", cast(Object[])[ this.contentURL.toString() ]));
            throw new RangeNotSupportedException();
        }
        throw new IOException(String.format("Status '%s' received from '%s', cancelling transfer", cast(Object[])[ response.getStatus(), this.contentURL.toString() ]));
    }

    private InputStream getResponseStream(Response response)
    {
        if ((response.getEntity() !is null) && (!( cast(EmptyRepresentation)response.getEntity() !is null ))) {
            return response.getEntity().getStream();
        }
        if (HttpUtils.isHttpUrl(this.contentURL.toString()))
        {
            log.debug_("Trying basic stream handler");
            try
            {
                return HttpClient.getStreamFromURL(this.contentURL.toString());
            }
            catch (IOException e)
            {
                log.debug_("Trying ShoutCast stream handler");
                InputStream stream = HttpClient.getShoutCastStream(this.contentURL.toString());
                if (stream !is null) {
                    return stream;
                }
            }
        }
        throw new IOException(String.format("Cannot open stream from '%s', possibly incorrect URL or invalid HTTP response", cast(Object[])[ this.contentURL.toString() ]));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.OnlineInputStream
* JD-Core Version:    0.7.0.1
*/