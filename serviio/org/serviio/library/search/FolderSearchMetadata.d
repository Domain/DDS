module org.serviio.library.search.FolderSearchMetadata;

import java.util.List;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.audio.ListAudioFoldersByNameCommand;
import org.serviio.upnp.service.contentdirectory.command.image.ListImageFoldersByNameCommand;
import org.serviio.upnp.service.contentdirectory.command.video.ListVideoFoldersByNameCommand;
import org.serviio.util.Tupple;

public class FolderSearchMetadata
  : AbstractRecursiveSearchMetadata
{
  public this(Tupple!(Long, String) root, List!(Tupple!(Long, String)) hierarchy, MediaFileType fileType, Long thumbnailId)
  {
    super(getEntityId(hierarchy), fileType, ObjectType.CONTAINERS, SearchIndexer.SearchCategory.FOLDERS, getSearchableValue(hierarchy), thumbnailId);
    
    String recursiveId = buildIdForTheHierarchy(root, hierarchy, null);
    if (fileType == MediaFileType.AUDIO) {
      addCommandMapping(ListAudioFoldersByNameCommand.class_, recursiveId);
    } else if (fileType == MediaFileType.VIDEO) {
      addCommandMapping(ListVideoFoldersByNameCommand.class_, recursiveId);
    } else if (fileType == MediaFileType.IMAGE) {
      addCommandMapping(ListImageFoldersByNameCommand.class_, recursiveId);
    }
    addContext(root, hierarchy, false);
  }
  
  private static String getSearchableValue(List!(Tupple!(Long, String)) hierarchy)
  {
    return (String)(cast(Tupple)hierarchy.get(hierarchy.size() - 1)).getValueB();
  }
  
  private static Long getEntityId(List!(Tupple!(Long, String)) hierarchy)
  {
    if ((hierarchy is null) || (hierarchy.size() == 0)) {
      throw new RuntimeException("FolderSearchMetadata needs some folders");
    }
    return (Long)(cast(Tupple)hierarchy.get(hierarchy.size() - 1)).getValueA();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.FolderSearchMetadata
 * JD-Core Version:    0.7.0.1
 */