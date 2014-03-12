module org.serviio.library.search.OnlineItemSearchMetadata;

import java.lang;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.audio.ListAudioOnlineContentCommand;
import org.serviio.upnp.service.contentdirectory.command.image.ListImageOnlineContentCommand;
import org.serviio.upnp.service.contentdirectory.command.video.ListVideoOnlineContentCommand;
import org.serviio.util.ObjectValidator;
import org.serviio.library.search.AbstractOnlineRecursiveSearchMetadata;

public class OnlineItemSearchMetadata : AbstractOnlineRecursiveSearchMetadata
{
    public this(Long onlineRepositoryId, Long singleUrlStreamItemId, String title, MediaFileType fileType, Long thumbnailId)
    {
        this(onlineRepositoryId, singleUrlStreamItemId, title, null, fileType, thumbnailId, false);
    }

    public this(Long onlineRepositoryId, Long itemId, String title, String repositoryName, MediaFileType fileType, Long thumbnailId)
    {
        this(onlineRepositoryId, itemId, title, repositoryName, fileType, thumbnailId, true);
    }

    private this(Long repositoryId, Long itemId, String title, String repositoryName, MediaFileType fileType, Long thumbnailId, bool isContainerItem)
    {
        super(itemId, fileType, ObjectType.ITEMS, SearchCategory.ONLINE_ITEMS, title, thumbnailId, repositoryId);

        String recursiveId = buildIdForTheHierarchy(repositoryId, itemId, isContainerItem);
        if (fileType == MediaFileType.AUDIO) {
            addCommandMapping(ListAudioOnlineContentCommand.class_, recursiveId);
        } else if (fileType == MediaFileType.VIDEO) {
            addCommandMapping(ListVideoOnlineContentCommand.class_, recursiveId);
        } else if (fileType == MediaFileType.IMAGE) {
            addCommandMapping(ListImageOnlineContentCommand.class_, recursiveId);
        }
        if ((isContainerItem) && (ObjectValidator.isNotEmpty(repositoryName))) {
            addToContext(repositoryName);
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.OnlineItemSearchMetadata
* JD-Core Version:    0.7.0.1
*/