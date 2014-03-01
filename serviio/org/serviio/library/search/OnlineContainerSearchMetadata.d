module org.serviio.library.search.OnlineContainerSearchMetadata;

import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.audio.ListAudioOnlineContentCommand;
import org.serviio.upnp.service.contentdirectory.command.image.ListImageOnlineContentCommand;
import org.serviio.upnp.service.contentdirectory.command.video.ListVideoOnlineContentCommand;

public class OnlineContainerSearchMetadata
  : AbstractOnlineRecursiveSearchMetadata
{
  public this(Long containerId, String title, MediaFileType fileType, Long thumbnailId, Long onlineRepositoryId)
  {
    super(containerId, fileType, ObjectType.CONTAINERS, SearchCategory.ONLINE_CONTAINERS, title, thumbnailId, onlineRepositoryId);
    
    String recursiveId = buildIdForTheHierarchy(containerId, null, true);
    if (fileType == MediaFileType.AUDIO) {
      addCommandMapping(ListAudioOnlineContentCommand.class_, recursiveId);
    } else if (fileType == MediaFileType.VIDEO) {
      addCommandMapping(ListVideoOnlineContentCommand.class_, recursiveId);
    } else if (fileType == MediaFileType.IMAGE) {
      addCommandMapping(ListImageOnlineContentCommand.class_, recursiveId);
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.OnlineContainerSearchMetadata
 * JD-Core Version:    0.7.0.1
 */