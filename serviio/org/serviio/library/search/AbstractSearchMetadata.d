module org.serviio.library.search.AbstractSearchMetadata;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.command.NonRecursiveIdGenerator;
import org.serviio.upnp.service.contentdirectory.definition.ActionNode;
import org.serviio.upnp.service.contentdirectory.definition.ContainerNode;
import org.serviio.upnp.service.contentdirectory.definition.StaticContainerNode;

public abstract class AbstractSearchMetadata
  : SearchMetadata
{
  private final Long entityId;
  private final MediaFileType fileType;
  private final ObjectType objectType;
  private final SearchIndexer.SearchCategory category;
  private immutable String searchableValue;
  private final Long thumbnailId;
  private final List!(String) context = new ArrayList();
  private final Map/*!(Class!(?)*/, Object) commands = new HashMap();
  
  public this(Long mediaItemId, MediaFileType fileType, ObjectType objectType, SearchIndexer.SearchCategory category, String searchableValue, Long thumbnailId)
  {
    this.entityId = mediaItemId;
    this.fileType = fileType;
    this.searchableValue = searchableValue;
    this.category = category;
    this.objectType = objectType;
    this.thumbnailId = thumbnailId;
  }
  
  public static String generateIndexId(SearchIndexer.SearchCategory category, Long entityId)
  {
    return String.format("%s-%s", cast(Object[])[ entityId, category ]);
  }
  
  public String generateCDSIdentifier(ActionNode node)
  {
    List!(ContainerNode) nodesChain = getDefinitionNodesChain(node);
    return buildIdFromNodesChain(nodesChain);
  }
  
  public String generateCDSParentIdentifier(ActionNode node)
  {
    List!(ContainerNode) nodesChain = getDefinitionNodesChain(node);
    return buildIdFromNodesChain(nodesChain.subList(0, nodesChain.size() - 1));
  }
  
  public String getIndexId()
  {
    return generateIndexId(this.category, this.entityId);
  }
  
  public Long getEntityId()
  {
    return this.entityId;
  }
  
  public MediaFileType getFileType()
  {
    return this.fileType;
  }
  
  public SearchIndexer.SearchCategory getCategory()
  {
    return this.category;
  }
  
  public ObjectType getObjectType()
  {
    return this.objectType;
  }
  
  public Long getThumbnailId()
  {
    return this.thumbnailId;
  }
  
  public String getSearchableValue()
  {
    return this.searchableValue;
  }
  
  public List!(String) getContext()
  {
    return this.context;
  }
  
  public Long getOnlineRepositoryId()
  {
    return null;
  }
  
  protected List!(ContainerNode) getDefinitionNodesChain(ActionNode node)
  {
    List!(ContainerNode) nodesChain = new ArrayList();
    ContainerNode dn = node;
    while ((dn !is null) && (( cast(ActionNode)dn !is null )))
    {
      nodesChain.add(dn);
      dn = cast(ContainerNode)dn.getParent();
    }
    nodesChain.add(dn);
    
    Collections.reverse(nodesChain);
    return nodesChain;
  }
  
  private String buildIdFromNodesChain(List!(ContainerNode) nodesChain)
  {
    String generatedId = "";
    foreach (ContainerNode idNode ; nodesChain) {
      if (( cast(ActionNode)idNode !is null ))
      {
        ActionNode an = cast(ActionNode)idNode;
        generatedId = NonRecursiveIdGenerator.generateId(generatedId, an.getIdPrefix(), getMetadataAttributeForNode(an).toString());
      }
      else if (( cast(StaticContainerNode)idNode !is null ))
      {
        generatedId = generatedId + (cast(StaticContainerNode)idNode).getId();
      }
    }
    return generatedId;
  }
  
  private Object getMetadataAttributeForNode(ActionNode an)
  {
    Class/*!(?)*/ clazz;
    try
    {
      clazz = Class.forName(an.getCommandClass());
      for (Map.Entry/*!(Class!(?)*/, Object) entry : this.commands.entrySet()) {
        if ((cast(Class)entry.getKey()).isAssignableFrom(clazz)) {
          return entry.getValue();
        }
      }
    }
    catch (Exception e) {}
    throw new CommandNotSuitableForSearchMetadataException();
  }
  
  protected void addCommandMapping(Class/*!(?)*/ commandClass, Object value)
  {
    this.commands.put(commandClass, value);
  }
  
  protected void addToContext(String contextField)
  {
    this.context.add(contextField);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.AbstractSearchMetadata
 * JD-Core Version:    0.7.0.1
 */