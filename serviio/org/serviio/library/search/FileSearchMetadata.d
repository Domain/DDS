module org.serviio.library.search.FileSearchMetadata;

import java.lang;
import java.util.List;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.audio.ListAudioFoldersByNameCommand;
import org.serviio.upnp.service.contentdirectory.command.image.ListImageFoldersByNameCommand;
import org.serviio.upnp.service.contentdirectory.command.video.ListVideoFoldersByNameCommand;
import org.serviio.util.Tupple;
import org.serviio.library.search.AbstractRecursiveSearchMetadata;

public class FileSearchMetadata : AbstractRecursiveSearchMetadata
{
    public this(Long mediaItemId, String fileName, Tupple!(Long, String) root, List!(Tupple!(Long, String)) hierarchy, MediaFileType fileType, Long thumbnailId)
    {
        super(mediaItemId, fileType, ObjectType.ITEMS, SearchCategory.FILES, fileName, thumbnailId);

        String recursiveId = buildIdForTheHierarchy(root, hierarchy, mediaItemId);
        if (fileType == MediaFileType.AUDIO) {
            addCommandMapping(ListAudioFoldersByNameCommand.class_, recursiveId);
        } else if (fileType == MediaFileType.VIDEO) {
            addCommandMapping(ListVideoFoldersByNameCommand.class_, recursiveId);
        } else if (fileType == MediaFileType.IMAGE) {
            addCommandMapping(ListImageFoldersByNameCommand.class_, recursiveId);
        }
        addContext(root, hierarchy, true);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.FileSearchMetadata
* JD-Core Version:    0.7.0.1
*/