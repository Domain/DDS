module org.serviio.upnp.service.contentdirectory.command.image.ListImagesForFolderCommand;

import java.lang.String;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Image;
import org.serviio.library.local.service.ImageService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.image.AbstractImagesRetrievalCommand;

public class ListImagesForFolderCommand : AbstractImagesRetrievalCommand
{
	public this(String contextIdentifier, ObjectType objectType, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count)
	{
		super(contextIdentifier, objectType, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count);
	}

	override protected List!(Image) retrieveEntityList()
	{
		List!(Image) images = ImageService.getListOfImagesForFolder(new Long(getInternalObjectId()), accessGroup, startIndex, count);
		return images;
	}

	public int retrieveItemCount()
	{
		return ImageService.getNumberOfImagesForFolder(new Long(getInternalObjectId()), accessGroup);
	}

	override protected String getItemTitle(Image image, bool markedItem)
	{
		return image.getFileName();
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.image.ListImagesForFolderCommand
* JD-Core Version:    0.6.2
*/