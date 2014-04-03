module org.serviio.delivery.resource.transcode.TranscodingCache;

import java.lang;
import org.serviio.dlna.MediaFormatProfile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TranscodingCache
{
    private static Logger log;
    private Long mediaItemId;
    private MediaFormatProfile transcodedProfile;
    private byte[] transcodedData;

    static this()
    {
        log = LoggerFactory.getLogger!(TranscodingCache);
    }

    public void storeInCache(Long mediaItemId, MediaFormatProfile transcodedProfile, byte[] transcodedData)
    {
        log.debug_(String_format("Storing media item %s with profile %s to cache", cast(Object[])[ mediaItemId.toString(), transcodedProfile.toString() ]));
        this.mediaItemId = mediaItemId;
        this.transcodedProfile = transcodedProfile;
        this.transcodedData = transcodedData;
    }

    public bool isInCache(Long mediaItemId, MediaFormatProfile transcodedProfile)
    {
        if ((this.mediaItemId !is null) && (this.mediaItemId.equals(mediaItemId)) && (this.transcodedProfile == transcodedProfile)) {
            return true;
        }
        return false;
    }

    public byte[] getCachedBytes()
    {
        if (this.transcodedData !is null)
        {
            log.debug_(String_format("Retrieving media item %s with profile %s from cache", cast(Object[])[ this.mediaItemId.toString(), this.transcodedProfile.toString() ]));
            byte[] dst = new byte[this.transcodedData.length];
            System.arraycopy(this.transcodedData, 0, dst, 0, this.transcodedData.length);
            return dst;
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.TranscodingCache
* JD-Core Version:    0.7.0.1
*/