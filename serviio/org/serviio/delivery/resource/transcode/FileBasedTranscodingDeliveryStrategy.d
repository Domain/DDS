module org.serviio.delivery.resource.transcode.FileBasedTranscodingDeliveryStrategy;

import java.lang;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import org.serviio.delivery.Client;
import org.serviio.delivery.DeliveryListener;
import org.serviio.library.entities.MediaItem;
import org.serviio.util.ThreadUtils;
import org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.TranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.StreamDescriptor;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.serviio.delivery.resource.transcode.TranscodeInputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FileBasedTranscodingDeliveryStrategy : AbstractTranscodingDeliveryStrategy, TranscodingDeliveryStrategy//!(File)
{
    private static Logger log = LoggerFactory.getLogger!(FileBasedTranscodingDeliveryStrategy);

    public StreamDescriptor createInputStream(TranscodingJobListener jobListener, Long resourceId, TranscodingDefinition trDef, Client client, DeliveryListener deliveryListener)
    {
        File transcodedFile = jobListener.getTranscodedFile();
        if (!transcodedFile.exists()) {
            throw new IOException(String.format("Transcoded file '%s' cannot be found, FFmpeg execution probably failed", cast(Object[])[ transcodedFile.getPath() ]));
        }
        if ((jobListener.isFinished()) && (!jobListener.isSuccessful())) {
            throw new IOException("FFmpeg execution failed");
        }
        markTranscodedFileForDeletion(transcodedFile);
        StreamDescriptor stream = null;
        if (!jobListener.isFinished())
        {
            log.debug_("Sending transcoding stream");

            TranscodeInputStream fis = createStreamForTranscodedFile(transcodedFile, jobListener, resourceId, client, deliveryListener, !trDef.getTranscodingConfiguration().isKeepStreamOpen());
            jobListener.addStream(fis);
            stream = new StreamDescriptor(cast(InputStream)fis, null);
        }
        else
        {
            log.debug_(String.format("Transcoded file '%s' is complete, sending simple stream", cast(Object[])[ transcodedFile ]));
            InputStream fis = createStreamForFinishedFile(transcodedFile, jobListener, resourceId, client, deliveryListener, !trDef.getTranscodingConfiguration().isKeepStreamOpen());
            stream = new StreamDescriptor(fis, getFileSizeForFinishedFile(transcodedFile));
        }
        return stream;
    }

    public TranscodingJobListener invokeTranscoder(String transcodingIdentifier, MediaItem mediaItem, Double timeOffsetInSeconds, Double durationInSeconds, TranscodingDefinition trDef, Client client, DeliveryListener deliveryListener)
    {
        File transcodedFile = prepareTranscodedOutput(transcodingIdentifier);

        TranscodingJobListener jobListener = new TranscodingJobListener(transcodingIdentifier, isSegmentedOutput());
        jobListener.setTranscodedFile(transcodedFile);

        invokeTranscoder(mediaItem, timeOffsetInSeconds, durationInSeconds, jobListener.getTranscodedFile(), trDef, jobListener);

        int retries = 0;
        int maxRetries = mediaItem.isLocalMedia() ? 20 : 50;
        while (((!transcodedFile.exists()) || (transcodedFile.length() == 0L)) && (retries++ < maxRetries)) {
            ThreadUtils.currentThreadSleep(500L);
        }
        return jobListener;
    }

    protected Long getFileSizeForFinishedFile(File transcodedFile)
    {
        return Long.valueOf(transcodedFile.length());
    }

    protected TranscodeInputStream createStreamForTranscodedFile(File transcodedFile, TranscodingJobListener jobListener, Long resourceId, Client client, DeliveryListener deliveryListener, bool forceClosing)
    {
        return new TranscodedMediaInputStream(transcodedFile, client);
    }

    protected InputStream createStreamForFinishedFile(File transcodedFile, TranscodingJobListener jobListener, Long resourceId, Client client, DeliveryListener deliveryListener, bool forceClosing)
    {
        return new FileInputStream(transcodedFile);
    }

    protected bool isSegmentedOutput()
    {
        return false;
    }

    protected File prepareTranscodedOutput(String transcodingIdentifier)
    {
        File transcodingFolder = prepareTranscodingFolder();
        return new File(transcodingFolder, transcodingIdentifier);
    }

    protected void markTranscodedFileForDeletion(File transcodedFile)
    {
        transcodedFile.deleteOnExit();
    }

    protected File createFolder(File folder)
    {
        if (!folder.exists())
        {
            bool created = folder.mkdirs();
            if (!created) {
                throw new IOException(String.format("Cannot create transcoding folder: %s", cast(Object[])[ folder.getAbsolutePath() ]));
            }
        }
        return folder;
    }

    private File prepareTranscodingFolder()
    {
        File transcodingFolder = AbstractTranscodingDeliveryEngine.getTranscodingFolder();
        return createFolder(transcodingFolder);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.FileBasedTranscodingDeliveryStrategy
* JD-Core Version:    0.7.0.1
*/