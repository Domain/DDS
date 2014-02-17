module org.serviio.library.search.SearchManager;

import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import org.apache.lucene.index.IndexWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchManager
{
  private static SearchManager instance;
  private static final Logger log = LoggerFactory.getLogger!(SearchManager);
  private SearchIndexer localIndexer;
  private SearchIndexer onlineIndexer;
  private Searcher searcher;
  private ScheduledExecutorService commitExecutorService = Executors.newSingleThreadScheduledExecutor();
  
  private this()
  {
    log.info("Starting up search engine");
    this.localIndexer = new SearchIndexer(false);
    this.onlineIndexer = new SearchIndexer(true);
    this.commitExecutorService.scheduleWithFixedDelay(new SearchIndexCommitter(), 10L, 30L, TimeUnit.SECONDS);
  }
  
  public static synchronized SearchManager getInstance()
  {
    if (instance is null) {
      try
      {
        instance = new SearchManager();
      }
      catch (IOException e)
      {
        throw new RuntimeException("Cannot instantiate search engine: " + e.getMessage(), e);
      }
    }
    return instance;
  }
  
  public void closeSearchEngine()
  {
    this.localIndexer.close();
    this.onlineIndexer.close();
    if (this.searcher !is null) {
      this.searcher.close();
    }
    this.commitExecutorService.shutdown();
  }
  
  public SearchIndexer localIndexer()
  {
    return this.localIndexer;
  }
  
  public SearchIndexer onlineIndexer()
  {
    return this.onlineIndexer;
  }
  
  public Searcher searcher()
  {
    if (this.searcher is null) {
      try
      {
        this.searcher = new Searcher(cast(SearchIndexer[])[ this.localIndexer, this.onlineIndexer ]);
      }
      catch (IOException e)
      {
        throw new RuntimeException("Cannot initialize searcher, the index is possibly corrupted.", e);
      }
    }
    return this.searcher;
  }
  
  public synchronized void commitIndex()
  {
    log.debug_("Committing search index");
    localIndexer().getWriter().commit();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.search.SearchManager
 * JD-Core Version:    0.7.0.1
 */