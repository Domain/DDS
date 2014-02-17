module org.serviio.upnp.service.contentdirectory.rest.representation.AbstractCDSObjectRepresentation;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import org.serviio.library.metadata.MediaFileType;

public abstract class AbstractCDSObjectRepresentation
{
  @XStreamAsAttribute
  private String id;
  @XStreamAsAttribute
  private DirectoryObjectType type;
  @XStreamAsAttribute
  private MediaFileType fileType;
  @XStreamAsAttribute
  private String parentId;
  private String title;
  private String thumbnailUrl;
  
  public static enum DirectoryObjectType
  {
    CONTAINER,  ITEM;
    
    private this() {}
  }
  
  public this(DirectoryObjectType type, String title, String id)
  {
    this.type = type;
    this.title = title;
    this.id = id;
  }
  
  public DirectoryObjectType getType()
  {
    return this.type;
  }
  
  public void setType(DirectoryObjectType type)
  {
    this.type = type;
  }
  
  public String getTitle()
  {
    return this.title;
  }
  
  public void setTitle(String title)
  {
    this.title = title;
  }
  
  public String getId()
  {
    return this.id;
  }
  
  public void setId(String id)
  {
    this.id = id;
  }
  
  public String getParentId()
  {
    return this.parentId;
  }
  
  public void setParentId(String parentId)
  {
    this.parentId = parentId;
  }
  
  public String getThumbnailUrl()
  {
    return this.thumbnailUrl;
  }
  
  public void setThumbnailUrl(String thumbnailUrl)
  {
    this.thumbnailUrl = thumbnailUrl;
  }
  
  public MediaFileType getFileType()
  {
    return this.fileType;
  }
  
  public void setFileType(MediaFileType fileType)
  {
    this.fileType = fileType;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.AbstractCDSObjectRepresentation
 * JD-Core Version:    0.7.0.1
 */