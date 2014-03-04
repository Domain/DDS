module org.serviio.upnp.service.contentdirectory.ProtocolAdditionalInfo;

import java.lang.String;
import org.serviio.library.metadata.MediaFileType;

public abstract interface ProtocolAdditionalInfo
{
    public abstract String buildMediaProtocolInfo(bool paramBoolean1, bool paramBoolean2, MediaFileType paramMediaFileType, bool paramBoolean3);

    public abstract String buildProfileProtocolInfo(MediaFileType paramMediaFileType);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.ProtocolAdditionalInfo
* JD-Core Version:    0.7.0.1
*/