module org.serviio.library.dao.MediaItemDAO;

import java.lang;
import java.io.File;
import java.util.List;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.metadata.MediaFileType;

public abstract interface MediaItemDAO
{
    public abstract bool isMediaItemPresent(String paramString);

    public abstract MediaItem getMediaItem(String paramString, bool paramBoolean);

    public abstract MediaItem read(Long paramLong);

    public abstract File getFile(Long paramLong);

    public abstract List!(MediaItem) getMediaItemsInRepository(Long paramLong);

    public abstract List!(MediaItem) getMediaItemsInRepository(Long paramLong, MediaFileType paramMediaFileType);

    public abstract void markMediaItemAsDirty(Long paramLong);

    public abstract void markMediaItemsAsDirty(MediaFileType paramMediaFileType);

    public abstract List!(MediaItem) getDirtyMediaItemsInRepository(Long paramLong);

    public abstract void markMediaItemAsRead(Long paramLong);

    public abstract void setMediaItemBookmark(Long paramLong, Integer paramInteger);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.MediaItemDAO
* JD-Core Version:    0.7.0.1
*/