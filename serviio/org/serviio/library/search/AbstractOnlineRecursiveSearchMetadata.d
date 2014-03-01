module org.serviio.library.search.AbstractOnlineRecursiveSearchMetadata;

import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.OnlineRecursiveIdGenerator;
import org.serviio.upnp.service.contentdirectory.definition.ActionNode;

public abstract class AbstractOnlineRecursiveSearchMetadata
  : AbstractSearchMetadata
{
  private Long onlineRepositoryId;
  
  public this(Long mediaItemId, MediaFileType fileType, ObjectType objectType, SearchCategory category, String searchableValue, Long thumbnailId, Long onlineRepositoryId)
  {
    super(mediaItemId, fileType, objectType, category, searchableValue, thumbnailId);
    this.onlineRepositoryId = onlineRepositoryId;
  }
  
  public String generateCDSParentIdentifier(ActionNode node)
  {
    String objectId = generateCDSIdentifier(node);
    String recursiveParentId = OnlineRecursiveIdGenerator.getRecursiveParentId(objectId);
    if (recursiveParentId is null) {
      return super.generateCDSParentIdentifier(node);
    }
    return recursiveParentId;
  }
  
  protected String buildIdForTheHierarchy(Long containerId, Long leafId, bool isContainerItem)
  {
    String generatedId = "";
    if ((isContainerItem) && (containerId !is null)) {
      generatedId = OnlineRecursiveIdGenerator.generateFolderObjectId(containerId, null, null);
    }
    if (leafId !is null) {
      generatedId = OnlineRecursiveIdGenerator.generateItemObjectId(leafId, generatedId, null);
    }
    return generatedId;
  }
  
  public Long getOnlineRepositoryId()
  {
    return this.onlineRepositoryId;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.AbstractOnlineRecursiveSearchMetadata
 * JD-Core Version:    0.7.0.1
 */