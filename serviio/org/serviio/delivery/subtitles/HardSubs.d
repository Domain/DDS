module org.serviio.delivery.subtitles.HardSubs;

import java.lang.String;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.io.FilenameUtils;

public class HardSubs
{
    private String subtitlesFile;

    public this(String subtitlesFile)
    {
        this.subtitlesFile = subtitlesFile;
    }

    public String getIdentifier()
    {
        return DigestUtils.md5Hex(FilenameUtils.getName(this.subtitlesFile));
    }

    public String getSubtitlesFile()
    {
        return this.subtitlesFile;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.subtitles.HardSubs
* JD-Core Version:    0.7.0.1
*/