module org.serviio.library.entities.Playlist;

import java.util.Date;
import java.util.Set;
import org.serviio.db.entities.PersistedEntity;
import org.serviio.library.metadata.MediaFileType;

public class Playlist
  : PersistedEntity
{
  public static final int TITLE_MAX_LENGTH = 128;
  private String title;
  private Set!(MediaFileType) fileTypes;
  private String filePath;
  private Date dateUpdated;
  private Long repositoryId;
  private bool allItemsFound;
  
  public this(String title, Set!(MediaFileType) fileTypes, String filePath, Date dateUpdated, Long repositoryId)
  {
    this.title = title;
    this.fileTypes = fileTypes;
    this.filePath = filePath;
    this.dateUpdated = dateUpdated;
    this.repositoryId = repositoryId;
  }
  
  public String getTitle()
  {
    return this.title;
  }
  
  public void setTitle(String title)
  {
    this.title = title;
  }
  
  public Set!(MediaFileType) getFileTypes()
  {
    return this.fileTypes;
  }
  
  public void setFileTypes(Set!(MediaFileType) fileTypes)
  {
    this.fileTypes = fileTypes;
  }
  
  public String getFilePath()
  {
    return this.filePath;
  }
  
  public void setFilePath(String filePath)
  {
    this.filePath = filePath;
  }
  
  public Date getDateUpdated()
  {
    return this.dateUpdated;
  }
  
  public void setDateUpdated(Date dateUpdated)
  {
    this.dateUpdated = dateUpdated;
  }
  
  public Long getRepositoryId()
  {
    return this.repositoryId;
  }
  
  public void setRepositoryId(Long repositoryId)
  {
    this.repositoryId = repositoryId;
  }
  
  public bool isAllItemsFound()
  {
    return this.allItemsFound;
  }
  
  public void setAllItemsFound(bool allItemsFound)
  {
    this.allItemsFound = allItemsFound;
  }
  
  public String toString()
  {
    return String.format("Playlist [id=%s, title=%s]", cast(Object[])[ this.id, this.title ]);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.entities.Playlist
 * JD-Core Version:    0.7.0.1
 */