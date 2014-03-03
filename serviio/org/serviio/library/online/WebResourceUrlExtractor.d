module org.serviio.library.online.WebResourceUrlExtractor;

import java.net.URL;
import org.serviio.config.Configuration;
import org.serviio.library.online.AbstractUrlExtractor;
import org.serviio.library.online.WebResourceContainer;
import org.serviio.library.online.ContentURLContainer;
import org.serviio.library.online.WebResourceItem;
import org.serviio.library.online.PreferredQuality;

public abstract class WebResourceUrlExtractor : AbstractUrlExtractor
{
    public final WebResourceContainer parseWebResource(immutable URL resourceUrl, immutable int maxItemsToRetrieve)
    {
        log("Starting parsing resource: " + resourceUrl);
        cast(WebResourceContainer)new class() PluginExecutionProcessor {
            protected WebResourceContainer executePluginMethod()
            {
                return this.outer.extractItems(resourceUrl, maxItemsToRetrieve);
            }
        }.execute(getExtractItemsTimeout() * 1000);
    }

    public final ContentURLContainer extractItemUrl(immutable WebResourceItem item)
    {
        log("Starting extraction of url for item: " + item.getTitle());

        ContentURLContainer result = cast(ContentURLContainer)new class() PluginExecutionProcessor {
            protected ContentURLContainer executePluginMethod()
            {
                return this.outer.extractUrl(item, Configuration.getOnlineFeedPreferredQuality());
            }
        }.execute(30000);

        bool valid = validate(result);
        if ((result !is null) && (valid))
        {
            log("Finished extraction of url: " + result.toString());
            return result;
        }
        log("Finished extraction of url: no result");
        return null;
    }

    protected int getExtractItemsTimeout()
    {
        return 30;
    }

    protected abstract WebResourceContainer extractItems(URL paramURL, int paramInt);

    protected abstract ContentURLContainer extractUrl(WebResourceItem paramWebResourceItem, PreferredQuality paramPreferredQuality);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.WebResourceUrlExtractor
* JD-Core Version:    0.7.0.1
*/