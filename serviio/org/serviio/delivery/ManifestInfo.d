module org.serviio.delivery.ManifestInfo;

import java.lang.Long;
import java.lang.String;
import org.serviio.delivery.ResourceInfo;

public class ManifestInfo : ResourceInfo
{
    public this(Long resourceId, Long fileSize, String mimeType)
    {
        super(resourceId);
        this.fileSize = fileSize;
        this.mimeType = mimeType;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.ManifestInfo
* JD-Core Version:    0.7.0.1
*/