module org.serviio.upnp.service.contentdirectory.command.AbstractListFlatFoldersByNameCommand;

import java.lang.Long;
import java.lang.String;
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
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand;

public abstract class AbstractListFlatFoldersByNameCommand : AbstractEntityContainerCommand!(Folder)
{
	protected MediaFileType fileType;

	public this(String objectId, ObjectType objectType, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, MediaFileType fileType)
	{
		super(objectId, objectType, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count);
		this.fileType = fileType;
	}

	override protected Set!(ObjectClassType) getSupportedClasses()
	{
		return new HashSet!(ObjectClassType)(Arrays.asList(cast(ObjectClassType[])[ ObjectClassType.CONTAINER, ObjectClassType.STORAGE_FOLDER ]));
	}

	override protected List!(Folder) retrieveEntityList()
	{
		List!(Folder) folders = FolderService.getListOfFoldersWithMedia(fileType, accessGroup, startIndex, count);
		return folders;
	}

	override protected Folder retrieveSingleEntity(Long entityId)
	{
		Folder folder = FolderService.getFolder(entityId);
		return folder;
	}

	override public int retrieveItemCount()
	{
		return FolderService.getNumberOfFoldersWithMedia(fileType, accessGroup);
	}

	override protected String getContainerTitle(Folder folder)
	{
		return folder.getName();
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractListFlatFoldersByNameCommand
* JD-Core Version:    0.6.2
*/