module org.serviio.library.local.LibraryManager;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.serviio.config.Configuration;
import org.serviio.library.AbstractLibraryManager;
import org.serviio.library.entities.Repository;
import org.serviio.library.local.metadata.CDSLibraryIndexingListener;
import org.serviio.library.local.metadata.LibraryAdditionsCheckerThread;
import org.serviio.library.local.metadata.LibraryUpdatesCheckerThread;
import org.serviio.library.local.metadata.LocalItemMetadata;
import org.serviio.library.local.metadata.MetadataFactory;
import org.serviio.library.local.metadata.PlaylistMaintainerThread;
import org.serviio.library.local.metadata.extractor.ExtractorType;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.serviio.library.local.metadata.extractor.MetadataExtractor;
import org.serviio.library.local.metadata.extractor.MetadataExtractorFactory;
import org.serviio.library.local.metadata.extractor.MetadataSourceNotAccessibleException;
import org.serviio.library.local.service.MediaService;
import org.serviio.library.metadata.MediaFileType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LibraryManager
  : AbstractLibraryManager
{
  private static final Logger log = LoggerFactory.getLogger!(LibraryManager);
  private static LibraryManager instance;
  private LibraryUpdatesCheckerThread libraryUpdatesCheckerThread;
  private LibraryAdditionsCheckerThread libraryAdditionsCheckerThread;
  private PlaylistMaintainerThread playlistMaintainerThread;
  private bool updatePaused = false;
  
  public static LibraryManager getInstance()
  {
    if (instance is null) {
      instance = new LibraryManager();
    }
    return instance;
  }
  
  private this()
  {
    this.cdsListener = new CDSLibraryIndexingListener();
  }
  
  public synchronized void startLibraryUpdatesCheckerThread()
  {
    if (((this.libraryUpdatesCheckerThread is null) || ((this.libraryUpdatesCheckerThread !is null) && (!this.libraryUpdatesCheckerThread.isWorkerRunning()))) && 
      (!this.updatePaused))
    {
      this.libraryUpdatesCheckerThread = new LibraryUpdatesCheckerThread();
      this.libraryUpdatesCheckerThread.setName("LibraryUpdatesCheckerThread");
      this.libraryUpdatesCheckerThread.setDaemon(true);
      this.libraryUpdatesCheckerThread.setPriority(1);
      this.libraryUpdatesCheckerThread.addListener(this.cdsListener);
      this.libraryUpdatesCheckerThread.start();
    }
  }
  
  public synchronized void startLibraryAdditionsCheckerThread()
  {
    if (((this.libraryAdditionsCheckerThread is null) || ((this.libraryAdditionsCheckerThread !is null) && (!this.libraryAdditionsCheckerThread.isWorkerRunning()))) && 
      (!this.updatePaused))
    {
      this.libraryAdditionsCheckerThread = new LibraryAdditionsCheckerThread();
      this.libraryAdditionsCheckerThread.setName("LibraryAdditionsCheckerThread");
      this.libraryAdditionsCheckerThread.setDaemon(true);
      this.libraryAdditionsCheckerThread.setPriority(2);
      this.libraryAdditionsCheckerThread.addListener(this.cdsListener);
      this.libraryAdditionsCheckerThread.start();
    }
  }
  
  public synchronized void startPlaylistMaintainerThread()
  {
    if (((this.playlistMaintainerThread is null) || ((this.playlistMaintainerThread !is null) && (!this.playlistMaintainerThread.isWorkerRunning()))) && 
      (!this.updatePaused))
    {
      this.playlistMaintainerThread = new PlaylistMaintainerThread();
      this.playlistMaintainerThread.setName("PlaylistMaintainerThread");
      this.playlistMaintainerThread.setDaemon(true);
      this.playlistMaintainerThread.setPriority(2);
      this.playlistMaintainerThread.addListener(this.cdsListener);
      this.playlistMaintainerThread.start();
    }
  }
  
  public synchronized void stopLibraryUpdatesCheckerThread()
  {
    stopThread(this.libraryUpdatesCheckerThread);
    this.libraryUpdatesCheckerThread = null;
  }
  
  public synchronized void stopLibraryAdditionsCheckerThread()
  {
    stopThread(this.libraryAdditionsCheckerThread);
    this.libraryAdditionsCheckerThread = null;
  }
  
  public synchronized void stopPlaylistMaintainerThread()
  {
    stopThread(this.playlistMaintainerThread);
    this.playlistMaintainerThread = null;
  }
  
  public synchronized void pauseUpdates()
  {
    this.updatePaused = true;
    stopLibraryAdditionsCheckerThread();
    stopLibraryUpdatesCheckerThread();
    stopPlaylistMaintainerThread();
  }
  
  public synchronized void resumeUpdates()
  {
    this.updatePaused = false;
    if (Configuration.isAutomaticLibraryRefresh())
    {
      startLibraryAdditionsCheckerThread();
      startLibraryUpdatesCheckerThread();
    }
    startPlaylistMaintainerThread();
  }
  
  public bool isAdditionsInProcess()
  {
    return (this.libraryAdditionsCheckerThread !is null) && (this.libraryAdditionsCheckerThread.isSearchingForFiles());
  }
  
  public bool isUpdatesInProcess()
  {
    return (this.libraryUpdatesCheckerThread !is null) && (this.libraryUpdatesCheckerThread.isSearchingForFiles());
  }
  
  public String getLastAddedFileName()
  {
    return (cast(CDSLibraryIndexingListener)this.cdsListener).getLastAddedFile();
  }
  
  public Integer getNumberOfRecentlyAddedFiles()
  {
    return Integer.valueOf((cast(CDSLibraryIndexingListener)this.cdsListener).getNumberOfAddedFiles());
  }
  
  public String getUpdateId(MediaFileType fileType)
  {
    return (cast(CDSLibraryIndexingListener)this.cdsListener).getUpdateId(fileType);
  }
  
  public LocalItemMetadata extractMetadata(File mediaFile, MediaFileType fileType, Repository repository)
  {
    List!(MetadataExtractor) extractors = MetadataExtractorFactory.getInstance().getExtractors(fileType);
    
    List!(LocalItemMetadata) metadataList = new ArrayList(extractors.size());
    bool dirtyMetadata = false;
    foreach (MetadataExtractor extractor ; extractors) {
      try
      {
        if (isExtractorSupportedByRepository(extractor, repository))
        {
          LocalItemMetadata metadata = extractor.extract(mediaFile, fileType, repository);
          if (metadata !is null)
          {
            log.debug_(String.format("Metadata found via extractor %s: %s", cast(Object[])[ extractor.getExtractorType(), metadata.toString() ]));
            metadataList.add(metadata);
          }
        }
      }
      catch (MetadataSourceNotAccessibleException e)
      {
        log.warn(String.format("Extractor %s failed to connect to metadata source for file %s, will try again later: %s", cast(Object[])[ extractor.getExtractorType(), mediaFile.getPath(), e.getMessage() ]));
        
        dirtyMetadata = true;
      }
      catch (InvalidMediaFormatException e)
      {
        if (extractor.getExtractorType() == ExtractorType.EMBEDDED)
        {
          log.warn(String.format("Skipping processing metadata for an unsupported file (%s). Message: %s", cast(Object[])[ mediaFile.getName(), e.getMessage() ]));
          
          return null;
        }
        log.debug_(String.format("Skipping processing metadata for an unsupported file (%s). Message: %s", cast(Object[])[ mediaFile.getName(), e.getMessage() ]));
      }
      catch (IOException e)
      {
        log.warn(String.format("Cannot read metadata of file %s via extractor %s. Message: %s", cast(Object[])[ mediaFile.getPath(), extractor.getExtractorType(), e.getMessage() ]));
        if (extractor.getExtractorType() == ExtractorType.EMBEDDED) {
          return null;
        }
      }
    }
    LocalItemMetadata mergedMetadata = mergeMetadata(metadataList, fileType, dirtyMetadata);
    return mergedMetadata;
  }
  
  public void forceMetadataUpdate(MediaFileType fileType)
  {
    log.info(String.format("Forcing metadata update for '%s' media files", cast(Object[])[ fileType ]));
    MediaService.markMediaItemsAsDirty(fileType);
  }
  
  public bool isRepositoryUpdatable(Repository rep)
  {
    if (rep.getLastScanned() is null) {
      return true;
    }
    if (rep.isKeepScanningForUpdates()) {
      return true;
    }
    return false;
  }
  
  protected LocalItemMetadata mergeMetadata(List!(LocalItemMetadata) metadataList, MediaFileType fileType, bool dirtyMetadata)
  {
    LocalItemMetadata mergedMetadata = MetadataFactory.getMetadataInstance(fileType);
    

    Collections.reverse(metadataList);
    foreach (LocalItemMetadata metadata ; metadataList) {
      mergedMetadata.merge(metadata);
    }
    mergedMetadata.fillInUnknownEntries();
    
    mergedMetadata.setDirty(dirtyMetadata);
    return mergedMetadata;
  }
  
  private bool isExtractorSupportedByRepository(MetadataExtractor extractor, Repository repository)
  {
    if (extractor.getExtractorType().isDescriptiveMetadataExtractor())
    {
      if (repository.isSupportsDescriptiveMetadata()) {
        return true;
      }
      return false;
    }
    return true;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.LibraryManager
 * JD-Core Version:    0.7.0.1
 */