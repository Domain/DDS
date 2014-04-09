module org.serviio.upnp.service.contentdirectory.ProtocolInfo;

import java.lang.String;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ProtocolAdditionalInfo;

public class ProtocolInfo//(T : ProtocolAdditionalInfo)
{
    private String protocol = "http-get";
    private String context = "*";
    private String mimeType;
    private List!ProtocolAdditionalInfo additionalInfos;

    public this(String mimeType, List!ProtocolAdditionalInfo additionalInfos)
    {
        this.mimeType = mimeType;
        this.additionalInfos = additionalInfos;
    }

    public Set!(String) getMediaProtocolInfo(bool transcoded, bool live, MediaFileType fileType, bool durationAvailable)
    {
        Set!(String) result = new LinkedHashSet();
        foreach (ProtocolAdditionalInfo additionalInfo ; this.additionalInfos)
        {
            String additionalInfoField = additionalInfo.buildMediaProtocolInfo(transcoded, live, fileType, durationAvailable);
            result.add(java.lang.String.format("%s:%s:%s:%s", cast(Object[])[ this.protocol, this.context, this.mimeType, additionalInfoField ]));
        }
        return result;
    }

    public Set!(String) getProfileProtocolInfo(MediaFileType fileType)
    {
        Set!(String) result = new LinkedHashSet();
        foreach (ProtocolAdditionalInfo additionalInfo ; this.additionalInfos)
        {
            String additionalInfoField = additionalInfo.buildProfileProtocolInfo(fileType);
            result.add(java.lang.String.format("%s:%s:%s:%s", cast(Object[])[ this.protocol, this.context, this.mimeType, additionalInfoField ]));
        }
        return result;
    }

    public List!ProtocolAdditionalInfo getAdditionalInfos()
    {
        return this.additionalInfos;
    }

    public String getMimeType()
    {
        return this.mimeType;
    }

    public void setMimeType(String mimeType)
    {
        this.mimeType = mimeType;
    }

    public void setAdditionalInfos(List!ProtocolAdditionalInfo additionalInfos)
    {
        this.additionalInfos = additionalInfos;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.ProtocolInfo
* JD-Core Version:    0.7.0.1
*/