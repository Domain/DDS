module org.serviio.library.online.AbstractOnlineItemParser;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Collections;
import java.util.Map;
import java.util.Map:Entry;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.online.feed.PluginCompilerThread;
import org.serviio.library.online.metadata.OnlineItem;
import org.serviio.util.HttpUtils;
import org.serviio.util.ThreadUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractOnlineItemParser
{
    protected final Logger log = LoggerFactory.getLogger(getClass());
    protected bool isAlive = true;
    private static PluginCompilerThread pluginCompiler;

    public static synchronized void startPluginCompilerThread(CountDownLatch pluginsCompiled)
    {
        if ((pluginCompiler is null) || ((pluginCompiler !is null) && (!pluginCompiler.isWorkerRunning())))
        {
            pluginCompiler = new PluginCompilerThread(pluginsCompiled);
            pluginCompiler.setName("PluginCompilerThread");
            pluginCompiler.setDaemon(true);
            pluginCompiler.setPriority(1);
            pluginCompiler.start();
        }
        else
        {
            pluginsCompiled.countDown();
        }
    }

    public static synchronized void stopPluginCompilerThread()
    {
        stopThread(pluginCompiler);
        pluginCompiler = null;
    }

    public static Set!(AbstractUrlExtractor) getListOfPlugins()
    {
        if (pluginCompiler !is null) {
            return pluginCompiler.getUrlExtractors().keySet();
        }
        return Collections.emptySet();
    }

    public void stopParsing()
    {
        this.isAlive = false;
    }

    public void startParsing()
    {
        this.isAlive = true;
    }

    protected AbstractUrlExtractor findSuitableExtractorPlugin(URL feedUrl, OnlineRepository.OnlineRepositoryType type)
    {
        if ((pluginCompiler !is null) && (pluginCompiler.getUrlExtractors() !is null)) {
            foreach (Map.Entry!(AbstractUrlExtractor, OnlineRepository.OnlineRepositoryType) urlExtractorEntry ; pluginCompiler.getUrlExtractors().entrySet())
            {
                AbstractUrlExtractor urlExtractor = cast(AbstractUrlExtractor)urlExtractorEntry.getKey();
                try
                {
                    if ((urlExtractorEntry.getValue() == type) && (urlExtractor.extractorMatches(feedUrl)))
                    {
                        this.log.debug_(String.format("Found matching url extractor (%s) for resource %s", cast(Object[])[ urlExtractor.getExtractorName(), feedUrl ]));
                        return urlExtractor;
                    }
                }
                catch (Exception e)
                {
                    this.log.debug_(String.format("Unexpected error during url extractor plugin matching (%s): %s", cast(Object[])[ urlExtractor.getExtractorName(), e.getMessage() ]));
                }
            }
        }
        return null;
    }

    protected void alterUrlsWithCredentials(String[] credentials, OnlineItem onlineItem)
    {
        if (credentials !is null)
        {
            String contentUrl = onlineItem.getContentUrl();
            onlineItem.setContentUrl(getCredentialAlteredUrl(contentUrl, credentials));
            if ((onlineItem.getThumbnail() !is null) && (onlineItem.getThumbnail().getImageUrl() !is null))
            {
                URL thumbnailUrl = onlineItem.getThumbnail().getImageUrl();
                onlineItem.getThumbnail().setImageUrl(getCredentialAlteredUrl(thumbnailUrl, credentials));
            }
        }
    }

    private String getCredentialAlteredUrl(String urlString, String[] credentials)
    {
        if (urlString !is null) {
            try
            {
                if (HttpUtils.getCredentialsFormUrl(urlString) is null)
                {
                    URL url = new URL(urlString);
                    try
                    {
                        return new URL(String.format("%s://%s:%s@%s%s", cast(Object[])[ url.getProtocol(), credentials[0], credentials[1], url.getHost(), url.getPath(), url.getQuery() ])).toString();
                    }
                    catch (MalformedURLException e)
                    {
                        this.log.warn("Cannot construct secure content URL: " + e.getMessage());
                    }
                }
            }
            catch (MalformedURLException e) {}
        }
        return urlString;
    }

    private URL getCredentialAlteredUrl(URL url, String[] credentials)
    {
        if (url !is null) {
            try
            {
                return new URL(getCredentialAlteredUrl(url.toString(), credentials));
            }
            catch (MalformedURLException e)
            {
                this.log.warn("Cannot construct secure content URL: " + e.getMessage());
            }
        }
        return url;
    }

    private static void stopThread(PluginCompilerThread thread)
    {
        if (thread !is null)
        {
            thread.stopWorker();
            while (thread.isAlive()) {
                ThreadUtils.currentThreadSleep(100L);
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.online.AbstractOnlineItemParser
* JD-Core Version:    0.7.0.1
*/