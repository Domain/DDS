module org.serviio.upnp.service.contentdirectory.SimpleProtocolInfo;

import java.lang.String;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ProtocolAdditionalInfo;

public class SimpleProtocolInfo : ProtocolAdditionalInfo
{
    public String buildMediaProtocolInfo(bool transcoded, bool live, MediaFileType fileType, bool durationAvailable)
    {
        return "*";
    }

    public String buildProfileProtocolInfo(MediaFileType fileType)
    {
        return "*";
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.SimpleProtocolInfo
* JD-Core Version:    0.7.0.1
*/