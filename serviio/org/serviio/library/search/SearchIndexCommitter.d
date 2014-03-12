module org.serviio.library.search.SearchIndexCommitter;

import java.lang.Runnable;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchIndexCommitter : Runnable
{
    private static Logger log = LoggerFactory.getLogger!(SearchIndexCommitter);

    public void run()
    {
        try
        {
            SearchManager.getInstance().commitIndex();
        }
        catch (IOException e)
        {
            log.warn(String.format("Could not commit search index: %s", cast(Object[])[ e.getMessage() ]));
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.SearchIndexCommitter
* JD-Core Version:    0.7.0.1
*/