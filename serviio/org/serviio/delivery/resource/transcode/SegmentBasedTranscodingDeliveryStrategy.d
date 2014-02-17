module org.serviio.delivery.resource.transcode.SegmentBasedTranscodingDeliveryStrategy;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import org.serviio.delivery.Client;
import org.serviio.delivery.DefaultResourceURLGenerator;
import org.serviio.delivery.DeliveryListener;
import org.serviio.delivery.ResourceURLGenerator;
import org.serviio.external.FFMPEGWrapper;
import org.serviio.util.FileUtils;

public class SegmentBasedTranscodingDeliveryStrategy
  : FileBasedTranscodingDeliveryStrategy
{
  protected ResourceURLGenerator urlGenerator = new DefaultResourceURLGenerator();
  
  protected bool isSegmentedOutput()
  {
    return true;
  }
  
  protected TranscodeInputStream createStreamForTranscodedFile(File transcodedFile, TranscodingJobListener jobListener, Long resourceId, Client client, DeliveryListener deliveryListener, bool forceClosing)
  {
    return new ManifestTranscodeInputStream(transcodedFile, client, this.urlGenerator, resourceId);
  }
  
  protected InputStream createStreamForFinishedFile(File transcodedFile, TranscodingJobListener jobListener, Long resourceId, Client client, DeliveryListener deliveryListener, bool forceClosing)
  {
    return new ManifestTranscodeInputStream(transcodedFile, client, this.urlGenerator, resourceId);
  }
  
  protected void markTranscodedFileForDeletion(File transcodedFile)
  {
    FileUtils.deleteDirOnExit(transcodedFile.getParentFile());
  }
  
  protected File prepareTranscodedOutput(String transcodingIdentifier)
  {
    File transcodingFolder = super.prepareTranscodedOutput(transcodingIdentifier);
    return new File(createFolder(transcodingFolder), FFMPEGWrapper.SEGMENT_PLAYLIST_FILE_NAME);
  }
  
  protected Long getFileSizeForFinishedFile(File transcodedFile)
  {
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.resource.transcode.SegmentBasedTranscodingDeliveryStrategy
 * JD-Core Version:    0.7.0.1
 */