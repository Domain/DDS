module org.serviio.library.playlist.AbstractPlaylistParserStrategy;

import java.lang.String;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import org.apache.commons.io.FilenameUtils;
import org.serviio.util.FileUtils;
import org.serviio.util.HttpUtils;
import org.serviio.util.StringUtils;
import org.serviio.library.playlist.PlaylistParserStrategy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractPlaylistParserStrategy : PlaylistParserStrategy
{
    protected Logger log = LoggerFactory.getLogger(getClass());

    protected String readPlaylistContent(byte[] playlistBytes)
    {
        try
        {
            return StringUtils.readStreamAsString(new ByteArrayInputStream(playlistBytes), "UTF-8");
        }
        catch (IOException e)
        {
            this.log.warn("Error reading playlist content.", e);
        }
        return null;
    }

    protected String getAbsoluteFilePath(String filePath, String playlistLocation)
    {
        if ((HttpUtils.isUri(filePath)) || (FileUtils.isPathAbsoulute(filePath)) || (filePath.startsWith("\\\\"))) {
            return filePath;
        }
        return FilenameUtils.concat(FilenameUtils.getFullPath(playlistLocation), filePath);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.playlist.AbstractPlaylistParserStrategy
* JD-Core Version:    0.7.0.1
*/