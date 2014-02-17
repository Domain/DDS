module org.serviio.upnp.service.contentdirectory.command.image.ListImagesForFolderCommand;

import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Image;
import org.serviio.library.local.service.ImageService;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public class ListImagesForFolderCommand
  : AbstractImagesRetrievalCommand
{
  public this(String contextIdentifier, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
  {
    super(contextIdentifier, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, idPrefix, startIndex, count, disablePresentationSettings);
  }
  
  protected List!(Image) retrieveEntityList()
  {
    List!(Image) images = ImageService.getListOfImagesForFolder(new Long(getInternalObjectId()), this.accessGroup, this.startIndex, this.count);
    return images;
  }
  
  public int retrieveItemCount()
  {
    return ImageService.getNumberOfImagesForFolder(new Long(getInternalObjectId()), this.accessGroup);
  }
  
  protected String getItemTitle(Image image, bool markedItem)
  {
    return image.getFileName();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.image.ListImagesForFolderCommand
 * JD-Core Version:    0.7.0.1
 */