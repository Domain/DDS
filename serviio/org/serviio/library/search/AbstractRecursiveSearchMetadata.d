module org.serviio.library.search.AbstractRecursiveSearchMetadata;

import java.util.List;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.RecursiveIdGenerator;
import org.serviio.upnp.service.contentdirectory.definition.ActionNode;
import org.serviio.util.CollectionUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.Tupple;

public abstract class AbstractRecursiveSearchMetadata
  : AbstractSearchMetadata
{
  public this(Long mediaItemId, MediaFileType fileType, ObjectType objectType, SearchIndexer.SearchCategory category, String searchableValue, Long thumbnailId)
  {
    super(mediaItemId, fileType, objectType, category, searchableValue, thumbnailId);
  }
  
  public String generateCDSParentIdentifier(ActionNode node)
  {
    String objectId = generateCDSIdentifier(node);
    String recursiveParentId = RecursiveIdGenerator.getRecursiveParentId(objectId);
    if (recursiveParentId is null) {
      return super.generateCDSParentIdentifier(node);
    }
    return recursiveParentId;
  }
  
  protected String buildIdForTheHierarchy(Tupple!(Long, String) root, List!(Tupple!(Long, String)) hierarchy, Long leafId)
  {
    String generatedId = "";
    if (root !is null)
    {
      generatedId = RecursiveIdGenerator.generateRepositoryObjectId(cast(Number)root.getValueA(), null, null);
      if ((hierarchy !is null) && (hierarchy.size() > 0)) {
        foreach (Tupple!(Long, String) hierarchySegment ; hierarchy) {
          generatedId = RecursiveIdGenerator.generateFolderObjectId(cast(Number)hierarchySegment.getValueA(), generatedId);
        }
      }
      if (leafId !is null) {
        generatedId = RecursiveIdGenerator.generateItemObjectId(leafId, generatedId);
      }
    }
    return generatedId;
  }
  
  protected void addContext(Tupple!(Long, String) root, List!(Tupple!(Long, String)) hierarchy, bool includeLeaf)
  {
    if (root !is null)
    {
      addToContext(cast(String)root.getValueB());
      if (ObjectValidator.isNotNullNorEmpty(hierarchy))
      {
        int numberOfSegments = includeLeaf ? hierarchy.size() : hierarchy.size() - 1;
        List!(Tupple!(Long, String)) hierarchyContext = CollectionUtils.getSubList(hierarchy, 0, numberOfSegments);
        foreach (Tupple!(Long, String) hierarchySegment ; hierarchyContext) {
          addToContext(cast(String)hierarchySegment.getValueB());
        }
      }
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.AbstractRecursiveSearchMetadata
 * JD-Core Version:    0.7.0.1
 */