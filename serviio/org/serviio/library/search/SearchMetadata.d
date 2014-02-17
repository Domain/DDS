module org.serviio.library.search.SearchMetadata;

import java.util.List;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.definition.ActionNode;

public abstract interface SearchMetadata
{
  public abstract String generateCDSIdentifier(ActionNode paramActionNode);
  
  public abstract String generateCDSParentIdentifier(ActionNode paramActionNode);
  
  public abstract String getIndexId();
  
  public abstract Long getEntityId();
  
  public abstract MediaFileType getFileType();
  
  public abstract SearchIndexer.SearchCategory getCategory();
  
  public abstract String getSearchableValue();
  
  public abstract ObjectType getObjectType();
  
  public abstract Long getThumbnailId();
  
  public abstract List!(String) getContext();
  
  public abstract Long getOnlineRepositoryId();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.SearchMetadata
 * JD-Core Version:    0.7.0.1
 */