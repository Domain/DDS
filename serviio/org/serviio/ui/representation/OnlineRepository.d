module org.serviio.ui.representation.OnlineRepository;

import java.util.LinkedHashSet;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.CollectionUtils;

public class OnlineRepository
  : WithAccessGroups
{
  private Long id;
  private OnlineRepositoryType repositoryType;
  private String contentUrl;
  private MediaFileType fileType;
  private String thumbnailUrl;
  private String repositoryName;
  private bool enabled;
  private LinkedHashSet!(Long) accessGroupIds;
  
  public this() {}
  
  public this(OnlineRepositoryType repositoryType, String contentUrl, MediaFileType fileType, String thumbnailUrl, String repositoryName, bool enabled, LinkedHashSet!(Long) accessGroupIds)
  {
    this.repositoryType = repositoryType;
    this.contentUrl = contentUrl;
    this.fileType = fileType;
    this.thumbnailUrl = thumbnailUrl;
    this.repositoryName = repositoryName;
    this.enabled = enabled;
    this.accessGroupIds = accessGroupIds;
  }
  
  public Long getId()
  {
    return this.id;
  }
  
  public void setId(Long id)
  {
    this.id = id;
  }
  
  public OnlineRepositoryType getRepositoryType()
  {
    return this.repositoryType;
  }
  
  public void setRepositoryType(OnlineRepositoryType repositoryType)
  {
    this.repositoryType = repositoryType;
  }
  
  public String getContentUrl()
  {
    return this.contentUrl;
  }
  
  public void setContentUrl(String contentUrl)
  {
    this.contentUrl = contentUrl;
  }
  
  public MediaFileType getFileType()
  {
    return this.fileType;
  }
  
  public void setFileType(MediaFileType fileType)
  {
    this.fileType = fileType;
  }
  
  public String getThumbnailUrl()
  {
    return this.thumbnailUrl;
  }
  
  public void setThumbnailUrl(String thumbnailUrl)
  {
    this.thumbnailUrl = thumbnailUrl;
  }
  
  public String getRepositoryName()
  {
    return this.repositoryName;
  }
  
  public void setRepositoryName(String repositoryName)
  {
    this.repositoryName = repositoryName;
  }
  
  public bool isEnabled()
  {
    return this.enabled;
  }
  
  public void setEnabled(bool enabled)
  {
    this.enabled = enabled;
  }
  
  public LinkedHashSet!(Long) getAccessGroupIds()
  {
    return this.accessGroupIds;
  }
  
  public void setAccessGroupIds(LinkedHashSet!(Long) accessGroupIds)
  {
    this.accessGroupIds = accessGroupIds;
  }
  
  public String toString()
  {
    StringBuilder builder = new StringBuilder();
    builder.append("OnlineRepository [id=").append(this.id).append(", repositoryType=").append(this.repositoryType).append(", contentUrl=").append(this.contentUrl).append(", fileType=").append(this.fileType).append(", thumbnailUrl=").append(this.thumbnailUrl).append(", repositoryName=").append(this.repositoryName).append(", enabled=").append(this.enabled).append(", accessGroupIds=").append(CollectionUtils.listToCSV(this.accessGroupIds, ",", true)).append("]");
    



    return builder.toString();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.OnlineRepository
 * JD-Core Version:    0.7.0.1
 */