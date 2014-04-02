module org.serviio.library.search.SearchManager;

import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import org.apache.lucene.index.IndexWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.serviio.library.search.SearchIndexer;
import org.serviio.library.search.Searcher;

public class SearchManager
{
    private static SearchManager instance;
    private static Logger log;
    private SearchIndexer _localIndexer;
    private SearchIndexer _onlineIndexer;
    private Searcher _searcher;
    private ScheduledExecutorService commitExecutorService;

    static this()
    {
        log = LoggerFactory.getLogger!(SearchManager);
    }

    private this()
    {
        commitExecutorService = Executors.newSingleThreadScheduledExecutor();
        log.info("Starting up search engine");
        this._localIndexer = new SearchIndexer(false);
        this._onlineIndexer = new SearchIndexer(true);
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
        this._localIndexer.close();
        this._onlineIndexer.close();
        if (this._searcher !is null) {
            this._searcher.close();
        }
        this.commitExecutorService.shutdown();
    }

    public SearchIndexer localIndexer()
    {
        return this._localIndexer;
    }

    public SearchIndexer onlineIndexer()
    {
        return this._onlineIndexer;
    }

    public Searcher searcher()
    {
        if (this._searcher is null) {
            try
            {
                this._searcher = new Searcher(cast(SearchIndexer[])[ this._localIndexer, this._onlineIndexer ]);
            }
            catch (IOException e)
            {
                throw new RuntimeException("Cannot initialize _searcher, the index is possibly corrupted.", e);
            }
        }
        return this._searcher;
    }

    public synchronized void commitIndex()
    {
        log.debug_("Committing search index");
        _localIndexer().getWriter().commit();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.SearchManager
* JD-Core Version:    0.7.0.1
*/