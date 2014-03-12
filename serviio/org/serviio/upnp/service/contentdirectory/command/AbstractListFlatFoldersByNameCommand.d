module org.serviio.upnp.service.contentdirectory.command.AbstractListFlatFoldersByNameCommand;

import java.lang;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Folder;
import org.serviio.library.local.service.FolderService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand;

public abstract class AbstractListFlatFoldersByNameCommand : AbstractEntityContainerCommand!(Folder)
{
    public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.STORAGE_FOLDER ]));
    }

    override protected List!(Folder) retrieveEntityList()
    {
        List!(Folder) folders = FolderService.getListOfFoldersWithMedia(this.fileType, this.accessGroup, this.startIndex, this.count);
        return folders;
    }

    override protected Folder retrieveSingleEntity(Long entityId)
    {
        Folder folder = FolderService.getFolder(entityId);
        return folder;
    }

    override public int retrieveItemCount()
    {
        return FolderService.getNumberOfFoldersWithMedia(this.fileType, this.accessGroup);
    }

    override protected String getContainerTitle(Folder folder)
    {
        return folder.getName();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractListFlatFoldersByNameCommand
* JD-Core Version:    0.7.0.1
*/