module org.serviio.library.online.feed.modules.gametrailers.GameTrailersExModule;

import java.lang.String;
import java.lang.Long;
import com.sun.syndication.feed.modules.Module;

public abstract interface GameTrailersExModule : Module
{
	public static const String URI = "http://www.gametrailers.com/rssexplained.php";

	public abstract Long getFileSize();

	public abstract void setFileSize(Long paramLong);

	public abstract String getThumbnailUrl();

	public abstract void setThumbnailUrl(String paramString);
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.library.online.feed.modules.gametrailers.GameTrailersExModule
* JD-Core Version:    0.6.2
*/