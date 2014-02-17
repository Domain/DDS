module org.serviio.ui.resources.server.DeliveryServerResource;

import java.io.File;
import java.util.List;
import org.serviio.config.Configuration;
import org.serviio.delivery.resource.VideoDeliveryEngine;
import org.serviio.restlet.AbstractServerResource;
import org.serviio.restlet.ResultRepresentation;
import org.serviio.restlet.ValidationException;
import org.serviio.ui.representation.DeliveryRepresentation;
import org.serviio.ui.representation.SubtitlesRepresentation;
import org.serviio.ui.representation.TranscodingRepresentation;
import org.serviio.ui.resources.DeliveryResource;
import org.serviio.upnp.service.contentdirectory.ContentDirectory;
import org.serviio.util.CollectionUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.ServiioThreadFactory;

public class DeliveryServerResource
  : AbstractServerResource
  , DeliveryResource
{
  public ResultRepresentation save(DeliveryRepresentation representation)
  {
    bool cacheCleanRequired = saveTranscoding(representation.getTranscoding());
    cacheCleanRequired = (cacheCleanRequired) || (saveSubtitles(representation.getSubtitles()));
    if (cacheCleanRequired) {
      getCDS().incrementUpdateID();
    }
    return responseOk();
  }
  
  public DeliveryRepresentation load()
  {
    TranscodingRepresentation tr = new TranscodingRepresentation();
    tr.setAudioDownmixing(Configuration.isTranscodingDownmixToStereo());
    tr.setThreadsNumber(Configuration.getTranscodingThreads().equals("auto") ? null : new Integer(Configuration.getTranscodingThreads()));
    tr.setTranscodingEnabled(Configuration.isTranscodingEnabled());
    tr.setTranscodingFolderLocation(Configuration.getTranscodingFolder());
    tr.setBestVideoQuality(Configuration.isTranscodingBestQuality());
    
    SubtitlesRepresentation srep = new SubtitlesRepresentation();
    srep.setSubtitlesEnabled(Configuration.isSubtitlesEnabled());
    srep.setEmbeddedSubtitlesExtractionEnabled(Configuration.isEmbeddedSubtitlesExtracted());
    srep.setHardSubsEnabled(Configuration.isHardSubsEnabled());
    srep.setHardSubsForced(Configuration.isHardSubsForced());
    String prefLang = CollectionUtils.listToCSV(Configuration.getSubtitlesPreferredLanguages(), ",", true);
    srep.setPreferredLanguage(ObjectValidator.isEmpty(prefLang) ? null : prefLang);
    srep.setHardSubsCharacterEncoding(Configuration.getSubsCharacterEncoding());
    
    DeliveryRepresentation rep = new DeliveryRepresentation();
    rep.setTranscoding(tr);
    rep.setSubtitles(srep);
    return rep;
  }
  
  private bool saveSubtitles(SubtitlesRepresentation rep)
  {
    bool cacheCleanRequired = false;
    if (rep.isSubtitlesEnabled() != Configuration.isSubtitlesEnabled())
    {
      cacheCleanRequired = true;
      Configuration.setSubtitlesEnabled(rep.isSubtitlesEnabled());
    }
    if (rep.isEmbeddedSubtitlesExtractionEnabled() != Configuration.isEmbeddedSubtitlesExtracted())
    {
      cacheCleanRequired = true;
      Configuration.setEmbeddedSubtitlesExtracted(rep.isEmbeddedSubtitlesExtractionEnabled());
    }
    if (rep.isHardSubsEnabled() != Configuration.isHardSubsEnabled())
    {
      cacheCleanRequired = true;
      Configuration.setHardSubsEnabled(rep.isHardSubsEnabled());
    }
    if (rep.isHardSubsForced() != Configuration.isHardSubsForced())
    {
      cacheCleanRequired = true;
      Configuration.setHardSubsForced(rep.isHardSubsForced());
    }
    Configuration.setSubsCharacterEncoding(rep.getHardSubsCharacterEncoding());
    
    List!(String) languages = CollectionUtils.csvToList(rep.getPreferredLanguage(), ",", true);
    List!(String) currentLanguages = Configuration.getSubtitlesPreferredLanguages();
    if (!CollectionUtils.haveSameElements(languages, currentLanguages))
    {
      cacheCleanRequired = true;
      Configuration.setSubtitlesPreferredLanguages(languages);
    }
    return cacheCleanRequired;
  }
  
  private bool saveTranscoding(TranscodingRepresentation representation)
  {
    bool cacheCleanRequired = false;
    bool transcodingLocationChanged = false;
    bool disabledTranscoding = (!representation.isTranscodingEnabled()) && (Configuration.isTranscodingEnabled());
    if (Configuration.isTranscodingEnabled() != representation.isTranscodingEnabled())
    {
      cacheCleanRequired = true;
      Configuration.setTranscodingEnabled(representation.isTranscodingEnabled());
    }
    if (representation.isTranscodingEnabled())
    {
      if (!validateFolderLocation(representation.getTranscodingFolderLocation())) {
        throw new ValidationException(501);
      }
      transcodingLocationChanged = !representation.getTranscodingFolderLocation().equals(Configuration.getTranscodingFolder());
      
      Configuration.setTranscodingDownmixToStereo(representation.isAudioDownmixing());
      Configuration.setTranscodingThreads(representation.getThreadsNumber());
      Configuration.setTranscodingFolder(representation.getTranscodingFolderLocation());
      Configuration.setTranscodingBestQuality(representation.isBestVideoQuality());
    }
    if ((disabledTranscoding) || (transcodingLocationChanged)) {
      ServiioThreadFactory.getInstance().newThread(new class() Runnable {
        public void run() {}
      }).start();
    }
    return cacheCleanRequired;
  }
  
  private bool validateFolderLocation(String folder)
  {
    File f = new File(folder);
    if ((f.exists()) && (f.isDirectory()) && (f.canWrite())) {
      return true;
    }
    return false;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.server.DeliveryServerResource
 * JD-Core Version:    0.7.0.1
 */