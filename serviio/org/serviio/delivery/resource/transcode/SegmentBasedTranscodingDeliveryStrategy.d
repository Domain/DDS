module org.serviio.delivery.resource.transcode.SegmentBasedTranscodingDeliveryStrategy;

import java.lang;
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
import org.serviio.delivery.resource.transcode.FileBasedTranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.TranscodeInputStream;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.resource.transcode.ManifestTranscodeInputStream;

public class SegmentBasedTranscodingDeliveryStrategy : FileBasedTranscodingDeliveryStrategy
{
    protected ResourceURLGenerator urlGenerator = new DefaultResourceURLGenerator();

    override protected bool isSegmentedOutput()
    {
        return true;
    }

    override protected TranscodeInputStream createStreamForTranscodedFile(File transcodedFile, TranscodingJobListener jobListener, Long resourceId, Client client, DeliveryListener deliveryListener, bool forceClosing)
    {
        return new ManifestTranscodeInputStream(transcodedFile, client, this.urlGenerator, resourceId);
    }

    override protected InputStream createStreamForFinishedFile(File transcodedFile, TranscodingJobListener jobListener, Long resourceId, Client client, DeliveryListener deliveryListener, bool forceClosing)
    {
        return new ManifestTranscodeInputStream(transcodedFile, client, this.urlGenerator, resourceId);
    }

    override protected void markTranscodedFileForDeletion(File transcodedFile)
    {
        FileUtils.deleteDirOnExit(transcodedFile.getParentFile());
    }

    override protected File prepareTranscodedOutput(String transcodingIdentifier)
    {
        File transcodingFolder = super.prepareTranscodedOutput(transcodingIdentifier);
        return new File(createFolder(transcodingFolder), FFMPEGWrapper.SEGMENT_PLAYLIST_FILE_NAME);
    }

    override protected Long getFileSizeForFinishedFile(File transcodedFile)
    {
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.SegmentBasedTranscodingDeliveryStrategy
* JD-Core Version:    0.7.0.1
*/