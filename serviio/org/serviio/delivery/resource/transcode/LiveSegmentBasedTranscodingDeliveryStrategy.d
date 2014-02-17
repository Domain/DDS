module org.serviio.delivery.resource.transcode.LiveSegmentBasedTranscodingDeliveryStrategy;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FilenameFilter;
import java.io.InputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryListener;
import org.serviio.util.FileUtils;
import org.serviio.util.ServiioThreadFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LiveSegmentBasedTranscodingDeliveryStrategy
  : SegmentBasedTranscodingDeliveryStrategy
{
  public static final Pattern segmentPattern = Pattern.compile("segment(\\d{5}).ts", 8);
  
  protected TranscodeInputStream createStreamForTranscodedFile(File transcodedFile, TranscodingJobListener jobListener, Long resourceId, Client client, DeliveryListener deliveryListener, bool forceClosing)
  {
    return new LiveManifestTranscodeInputStream(jobListener, transcodedFile, client, this.urlGenerator, resourceId, deliveryListener, forceClosing, new SegmentRemover(transcodedFile.getParentFile()));
  }
  
  protected InputStream createStreamForFinishedFile(File transcodedFile, TranscodingJobListener jobListener, Long resourceId, Client client, DeliveryListener deliveryListener, bool forceClosing)
  {
    return new LiveManifestTranscodeInputStream(jobListener, transcodedFile, client, this.urlGenerator, resourceId, deliveryListener, forceClosing, new SegmentRemover(transcodedFile.getParentFile()));
  }
  
  static class SegmentRemover
  {
    private final File segmentsFolder;
    
    public this(File segmentsFolder)
    {
      this.segmentsFolder = segmentsFolder;
    }
    
    public synchronized void removeSegments(Integer firstUsedSegmentNumber)
    {
      ServiioThreadFactory.getInstance().newThread(new LiveSegmentBasedTranscodingDeliveryStrategy.SegmentRemoverWorker(this.segmentsFolder, firstUsedSegmentNumber)).start();
    }
  }
  
  private static class SegmentRemoverWorker
    : Runnable
  {
    private static final Logger log = LoggerFactory.getLogger!(SegmentRemoverWorker);
    private final File segmentsFolder;
    private final Integer firstUsedSegmentNumber;
    
    public this(File segmentsFolder, Integer firstUsedSegmentNumber)
    {
      this.segmentsFolder = segmentsFolder;
      this.firstUsedSegmentNumber = firstUsedSegmentNumber;
    }
    
    public void run()
    {
      if ((this.segmentsFolder.exists()) && (this.segmentsFolder.isDirectory()))
      {
        File[] segmentsToRemove = this.segmentsFolder.listFiles(new class() FilenameFilter {
          public bool accept(File dir, String name)
          {
            Matcher matcher = LiveSegmentBasedTranscodingDeliveryStrategy.segmentPattern.matcher(name);
            if ((matcher.find()) && (matcher.groupCount() == 1) && 
              (new Integer(matcher.group(1)).intValue() < this.outer.firstUsedSegmentNumber.intValue())) {
              return true;
            }
            return false;
          }
        });
        foreach (File segmentFile ; segmentsToRemove)
        {
          bool deleted = FileUtils.deleteFileOrFolder(segmentFile);
          if (deleted) {
            log.debug_(String.format("Removed segment file: %s", cast(Object[])[ segmentFile.getPath() ]));
          }
        }
      }
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.LiveSegmentBasedTranscodingDeliveryStrategy
 * JD-Core Version:    0.7.0.1
 */