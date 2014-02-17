module org.serviio.library.entities.Folder;

import org.serviio.db.entities.PersistedEntity;

public class Folder
  : PersistedEntity
{
  public static final int NAME_MAX_LENGTH = 128;
  private String name;
  private Long parentFolderId;
  private Long repositoryId;
  
  public this(String name, Long repositoryId, Long parentFolderId)
  {
    this.name = name;
    this.repositoryId = repositoryId;
    this.parentFolderId = parentFolderId;
  }
  
  public String getName()
  {
    return this.name;
  }
  
  public void setName(String name)
  {
    this.name = name;
  }
  
  public Long getParentFolderId()
  {
    return this.parentFolderId;
  }
  
  public void setParentFolderId(Long parentFolderId)
  {
    this.parentFolderId = parentFolderId;
  }
  
  public Long getRepositoryId()
  {
    return this.repositoryId;
  }
  
  public void setRepositoryId(Long repositoryId)
  {
    this.repositoryId = repositoryId;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.entities.Folder
 * JD-Core Version:    0.7.0.1
 */