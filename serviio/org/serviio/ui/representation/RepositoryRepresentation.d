module org.serviio.ui.representation.RepositoryRepresentation;

import java.util.List;
import org.serviio.library.online.PreferredQuality;

public class RepositoryRepresentation
{
  private List!(SharedFolder) sharedFolders;
  private Boolean searchHiddenFiles;
  private Boolean searchForUpdates;
  private Boolean automaticLibraryUpdate;
  private Integer automaticLibraryUpdateInterval;
  private List!(OnlineRepository) onlineRepositories;
  private Integer maxNumberOfItemsForOnlineFeeds;
  private Integer onlineFeedExpiryInterval;
  private PreferredQuality onlineContentPreferredQuality;
  
  public List!(SharedFolder) getSharedFolders()
  {
    return this.sharedFolders;
  }
  
  public void setSharedFolders(List!(SharedFolder) repositories)
  {
    this.sharedFolders = repositories;
  }
  
  public Boolean isSearchHiddenFiles()
  {
    return this.searchHiddenFiles;
  }
  
  public void setSearchHiddenFiles(Boolean searchHiddenFiles)
  {
    this.searchHiddenFiles = searchHiddenFiles;
  }
  
  public Boolean isAutomaticLibraryUpdate()
  {
    return this.automaticLibraryUpdate;
  }
  
  public void setAutomaticLibraryUpdate(Boolean automaticLibraryUpdate)
  {
    this.automaticLibraryUpdate = automaticLibraryUpdate;
  }
  
  public Integer getAutomaticLibraryUpdateInterval()
  {
    return this.automaticLibraryUpdateInterval;
  }
  
  public void setAutomaticLibraryUpdateInterval(Integer automaticLibraryUpdateInterval)
  {
    this.automaticLibraryUpdateInterval = automaticLibraryUpdateInterval;
  }
  
  public Boolean isSearchForUpdates()
  {
    return this.searchForUpdates;
  }
  
  public void setSearchForUpdates(Boolean searchForUpdates)
  {
    this.searchForUpdates = searchForUpdates;
  }
  
  public List!(OnlineRepository) getOnlineRepositories()
  {
    return this.onlineRepositories;
  }
  
  public void setOnlineRepositories(List!(OnlineRepository) onlineRepositories)
  {
    this.onlineRepositories = onlineRepositories;
  }
  
  public Integer getMaxNumberOfItemsForOnlineFeeds()
  {
    return this.maxNumberOfItemsForOnlineFeeds;
  }
  
  public void setMaxNumberOfItemsForOnlineFeeds(Integer maxNumberOfItemsForOnlineFeeds)
  {
    this.maxNumberOfItemsForOnlineFeeds = maxNumberOfItemsForOnlineFeeds;
  }
  
  public Integer getOnlineFeedExpiryInterval()
  {
    return this.onlineFeedExpiryInterval;
  }
  
  public void setOnlineFeedExpiryInterval(Integer onlineFeedExpiryInterval)
  {
    this.onlineFeedExpiryInterval = onlineFeedExpiryInterval;
  }
  
  public PreferredQuality getOnlineContentPreferredQuality()
  {
    return this.onlineContentPreferredQuality;
  }
  
  public void setOnlineContentPreferredQuality(PreferredQuality onlineContentPreferredQuality)
  {
    this.onlineContentPreferredQuality = onlineContentPreferredQuality;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.RepositoryRepresentation
 * JD-Core Version:    0.7.0.1
 */