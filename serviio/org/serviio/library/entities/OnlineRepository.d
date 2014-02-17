module org.serviio.library.entities.OnlineRepository;

import java.net.URL;
import java.util.List;
import org.serviio.db.entities.PersistedEntity;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.ServiioUri;

public class OnlineRepository
  : PersistedEntity
{
  private String repositoryUrl;
  private MediaFileType fileType;
  private OnlineRepositoryType repoType;
  private URL thumbnailUrl;
  private String repositoryName;
  
  public static enum OnlineRepositoryType
  {
    FEED,  LIVE_STREAM,  WEB_RESOURCE;
    
    private this() {}
  }
  
  private bool enabled = true;
  private List!(Long) accessGroupIds;
  private Integer order;
  
  public this(OnlineRepositoryType repoType, String repositoryUrl, MediaFileType fileType, String repositoryName, Integer order)
  {
    this.repoType = repoType;
    this.repositoryUrl = repositoryUrl;
    this.fileType = fileType;
    this.repositoryName = repositoryName;
    this.order = order;
  }
  
  public ServiioUri toServiioUri()
  {
    return new ServiioUri(this.fileType, this.repoType, this.repositoryUrl, this.thumbnailUrl !is null ? this.thumbnailUrl.toString() : null, this.repositoryName);
  }
  
  public String getRepositoryUrl()
  {
    return this.repositoryUrl;
  }
  
  public void setRepositoryUrl(String repositoryUrl)
  {
    this.repositoryUrl = repositoryUrl;
  }
  
  public MediaFileType getFileType()
  {
    return this.fileType;
  }
  
  public void setFileType(MediaFileType fileType)
  {
    this.fileType = fileType;
  }
  
  public OnlineRepositoryType getRepoType()
  {
    return this.repoType;
  }
  
  public void setRepoType(OnlineRepositoryType repoType)
  {
    this.repoType = repoType;
  }
  
  public URL getThumbnailUrl()
  {
    return this.thumbnailUrl;
  }
  
  public void setThumbnailUrl(URL thumbnailUrl)
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
  
  public List!(Long) getAccessGroupIds()
  {
    return this.accessGroupIds;
  }
  
  public void setAccessGroupIds(List!(Long) accessGroupIds)
  {
    this.accessGroupIds = accessGroupIds;
  }
  
  public Integer getOrder()
  {
    return this.order;
  }
  
  public void setOrder(Integer order)
  {
    this.order = order;
  }
  
  public String toString()
  {
    StringBuilder builder = new StringBuilder();
    builder.append("OnlineRepository [repositoryUrl=").append(this.repositoryUrl).append(", fileType=").append(this.fileType).append(", repoType=").append(this.repoType).append(", thumbnailUrl=").append(this.thumbnailUrl).append(", repositoryName=").append(this.repositoryName).append(", enabled=").append(this.enabled).append(", accessGroupIds=").append(this.accessGroupIds).append(", order=").append(this.order).append(", id=").append(this.id).append("]");
    



    return builder.toString();
  }
  
  public bool thumbnailChanged(URL urlToCompare)
  {
    if ((this.thumbnailUrl is null) && (urlToCompare is null)) {
      return false;
    }
    if (this.thumbnailUrl is null) {
      return true;
    }
    return !this.thumbnailUrl.equals(urlToCompare);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.entities.OnlineRepository
 * JD-Core Version:    0.7.0.1
 */