module org.serviio.delivery.subtitles.SubtitlesConfiguration;

import java.lang.String;
import java.util.ArrayList;
import java.util.List;
import org.serviio.dlna.VideoContainer;

public class SubtitlesConfiguration
{
    private String softSubsMimeType;
    private List!(VideoContainer) hardSubsRequiredFor = new ArrayList();
    private bool hardSubsSupported = true;

    public this(String softSubsMimeType, List!(VideoContainer) hardSubsRequiredFor, bool hardSubsSupported)
    {
        this.softSubsMimeType = softSubsMimeType;
        this.hardSubsSupported = hardSubsSupported;
        if (hardSubsRequiredFor !is null) {
            this.hardSubsRequiredFor.addAll(hardSubsRequiredFor);
        }
    }

    public bool isSoftSubsEnabled()
    {
        return this.softSubsMimeType !is null;
    }

    public String getSoftSubsMimeType()
    {
        return this.softSubsMimeType;
    }

    public bool isHardSubsSupported()
    {
        return this.hardSubsSupported;
    }

    public List!(VideoContainer) getHardSubsRequiredFor()
    {
        return this.hardSubsRequiredFor;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.subtitles.SubtitlesConfiguration
* JD-Core Version:    0.7.0.1
*/