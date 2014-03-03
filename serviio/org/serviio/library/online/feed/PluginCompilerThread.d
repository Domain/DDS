module org.serviio.library.online.feed.PluginCompilerThread;

import groovy.lang.GroovyClassLoader;
import groovy.lang.GroovyCodeSource;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import org.codehaus.groovy.control.CompilationFailedException;
import org.serviio.ApplicationSettings;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.online.AbstractUrlExtractor;
import org.serviio.library.online.FeedItemUrlExtractor;
import org.serviio.library.online.OnlineLibraryManager;
import org.serviio.library.online.WebResourceUrlExtractor;
import org.serviio.util.FileUtils;
import org.serviio.util.ObjectValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PluginCompilerThread
  : Thread
{
  private static final Logger log = LoggerFactory.getLogger!(PluginCompilerThread);
  private static final int PLUGIN_COMPILER_CHECK_INTERVAL = 10;
  private File pluginsFolder;
  protected final Map!(AbstractUrlExtractor, OnlineRepositoryType) urlExtractors = new HashMap();
  private Map!(File, Date) seenFilesCache = new HashMap();
  private GroovyClassLoader gcl = new GroovyClassLoader();
  private bool workerRunning;
  private bool isSleeping = false;
  private bool checkPeriodically = checkForPluginsPeriodically();
  private final CountDownLatch pluginsCompiled;
  
  public this(CountDownLatch pluginsCompiled)
  {
    this.pluginsFolder = getPluginsDirectoryPath();
    this.pluginsCompiled = pluginsCompiled;
  }
  
  public void run()
  {
    if ((this.pluginsFolder !is null) && (this.pluginsFolder.isDirectory()))
    {
      log.info("Started looking for plugins");
      this.workerRunning = true;
      while (this.workerRunning)
      {
        searchForPlugins();
        if (!this.checkPeriodically) {
          this.workerRunning = false;
        }
        try
        {
          if (this.workerRunning)
          {
            this.isSleeping = true;
            Thread.sleep(10000L);
            this.isSleeping = false;
          }
        }
        catch (InterruptedException e)
        {
          this.isSleeping = false;
        }
        this.pluginsCompiled.countDown();
      }
      log.info("Finished looking for plugins");
    }
    else
    {
      log.warn(String.format("Plugins folder '%s' does not exist. No plugins will be compiled.", cast(Object[])[ this.pluginsFolder ]));
    }
  }
  
  public void stopWorker()
  {
    this.workerRunning = false;
    if (this.isSleeping) {
      interrupt();
    }
  }
  
  public bool isWorkerRunning()
  {
    return this.workerRunning;
  }
  
  private bool checkForPluginsPeriodically()
  {
    if (ObjectValidator.isEmpty(System.getProperty("plugins.check"))) {
      return true;
    }
    return Boolean.parseBoolean(System.getProperty("plugins.check"));
  }
  
  private File getPluginsDirectoryPath()
  {
    String pluginFolderName = ApplicationSettings.getStringProperty("plugins_directory");
    File pluginFolder = new File(System.getProperty("serviio.home"), pluginFolderName);
    if (!ObjectValidator.isEmpty(System.getProperty("plugins.location"))) {
      pluginFolder = new File(System.getProperty("plugins.location"), pluginFolderName);
    }
    log.info(String.format("Looking for plugins at %s", cast(Object[])[ pluginFolder.getPath() ]));
    return pluginFolder;
  }
  
  private void searchForPlugins()
  {
    File[] foundPlugins = this.pluginsFolder.listFiles(new class() FilenameFilter {
      public bool accept(File dir, String name)
      {
        if (name.endsWith(".groovy")) {
          return true;
        }
        return false;
      }
    });
    foreach (File pluginFile ; foundPlugins) {
      if ((!this.seenFilesCache.containsKey(pluginFile)) || (FileUtils.getLastModifiedDate(pluginFile).after(cast(Date)this.seenFilesCache.get(pluginFile)))) {
        compilePluginFile(pluginFile);
      }
    }
  }
  
  protected void compilePluginFile(File pluginFile)
  {
    try
    {
      log.debug_(String.format("Starting plugin %s compilation", cast(Object[])[ pluginFile.getName() ]));
      Class/*!(?)*/ pluginClass = this.gcl.parseClass(new GroovyCodeSource(pluginFile), false);
      if (AbstractUrlExtractor.class_.isAssignableFrom(pluginClass))
      {
        bool feedPlugin = true;
        AbstractUrlExtractor pluginInstance = cast(AbstractUrlExtractor)pluginClass.newInstance();
        if (FeedItemUrlExtractor.class_.isAssignableFrom(pluginClass))
        {
          storePluginInCache(pluginInstance, OnlineRepositoryType.FEED);
        }
        else if (WebResourceUrlExtractor.class_.isAssignableFrom(pluginClass))
        {
          storePluginInCache(pluginInstance, OnlineRepositoryType.WEB_RESOURCE);
          feedPlugin = false;
        }
        else
        {
          log.warn("Unsupported plugin class");
          return;
        }
        this.seenFilesCache.put(pluginFile, FileUtils.getLastModifiedDate(pluginFile));
        OnlineLibraryManager.getInstance().removeFeedFromCache(pluginInstance);
        log.info(String.format("Added %s plugin %s (%s), version: %d", cast(Object[])[ feedPlugin ? "Feed" : "Web Resouce", pluginInstance.getExtractorName(), pluginFile.getName(), Integer.valueOf(pluginInstance.getVersion()) ]));
      }
      else
      {
        log.warn(String.format("Groovy class %s (%s) doesn't extend %s, it will not be used", cast(Object[])[ pluginClass.getName(), pluginFile.getName(), FeedItemUrlExtractor.class_.getName() ]));
      }
    }
    catch (CompilationFailedException e)
    {
      log.warn(String.format("Plugin %s failed to compile: %s", cast(Object[])[ pluginFile.getName(), e.getMessage() ]));
    }
    catch (IOException e)
    {
      log.warn(String.format("Plugin %s failed to load: %s", cast(Object[])[ pluginFile.getName(), e.getMessage() ]));
    }
    catch (Exception e)
    {
      log.warn(String.format("Unexpected error during adding plugin %s: %s", cast(Object[])[ pluginFile.getName(), e.getMessage() ]), e);
    }
  }
  
  private synchronized void storePluginInCache(AbstractUrlExtractor plugin, OnlineRepositoryType type)
  {
    if (this.urlExtractors.containsKey(plugin)) {
      this.urlExtractors.remove(plugin);
    }
    this.urlExtractors.put(plugin, type);
  }
  
  public Map!(AbstractUrlExtractor, OnlineRepositoryType) getUrlExtractors()
  {
    return Collections.unmodifiableMap(this.urlExtractors);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.feed.PluginCompilerThread
 * JD-Core Version:    0.7.0.1
 */