module org.serviio.library.online.metadata.NamedOnlineResource;

public class NamedOnlineResource(T)
{
  private T onlineItem;
  private String repositoryName;
  
  public this(T onlineItem, String repositoryName)
  {
    this.onlineItem = onlineItem;
    this.repositoryName = repositoryName;
  }
  
  public T getOnlineItem()
  {
    return this.onlineItem;
  }
  
  public String getRepositoryName()
  {
    return this.repositoryName;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.metadata.NamedOnlineResource
 * JD-Core Version:    0.7.0.1
 */