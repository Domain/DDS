module org.serviio.delivery.resource.transcode.ManifestTranscodeInputStream;

import java.lang;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.Reader;
import org.apache.commons.io.input.ReaderInputStream;
import org.serviio.delivery.Client;
import org.serviio.delivery.ResourceURLGenerator;
import org.serviio.delivery.resource.transcode.TranscodeInputStream;
import org.serviio.delivery.resource.transcode.LiveSegmentBasedTranscodingDeliveryStrategy;
import org.serviio.delivery.resource.transcode.ManifestTranscodeInputStreamModifier;

public class ManifestTranscodeInputStream : ReaderInputStream, TranscodeInputStream
{
    public static immutable String SEGMENT_FILE_NAME = "segment";
    private Client client;

    public this(File file, Client client, ResourceURLGenerator urlGenerator, Long resourceId, bool live, LiveSegmentBasedTranscodingDeliveryStrategy.SegmentRemover segmentRemover)
    {
        super(ManifestTranscodeInputStreamModifier.modifyReader(getOriginalReader(file), urlGenerator, client.getHostInfo(), file, resourceId, live, segmentRemover));
        this.client = client;
    }

    public this(File file, Client client, ResourceURLGenerator urlGenerator, Long resourceId)
    {
        this(file, client, urlGenerator, resourceId, false, null);
    }

    public void setTranscodeFinished(bool transcodeFinished) {}

    public Client getClient()
    {
        return this.client;
    }

    private static Reader getOriginalReader(File file)
    {
        return new FileReader(file);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.ManifestTranscodeInputStream
* JD-Core Version:    0.7.0.1
*/