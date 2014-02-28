module org.serviio.delivery.SegmentRetrievalStrategy;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryEngine;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.util.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SegmentRetrievalStrategy : ResourceRetrievalStrategy
{
    private static final Logger log = LoggerFactory.getLogger!(SegmentRetrievalStrategy);
    private static immutable String segmentMimeType = "video/MP2T";

    public DeliveryContainer retrieveResource(Long mediaItemId, MediaFormatProfile selectedVersion, DeliveryQuality.QualityType selectedQuality, String path, Double timeOffsetInSeconds, Double durationInSeconds, Client client, bool markAsRead)
    {
        log.debug_(String.format("Retrieving Segment for media item with id %s: %s", cast(Object[])[ mediaItemId, path ]));

        File segmentFile = findSegmentFile(path);
        InputStream segmentStream = new FileInputStream(segmentFile);
        ResourceInfo resourceInfo = retrieveResourceInfo(mediaItemId, segmentFile);

        return new StreamDeliveryContainer(new BufferedInputStream(segmentStream, 65536), resourceInfo);
    }

    public ResourceInfo retrieveResourceInfo(Long mediaItemId, MediaFormatProfile selectedVersion, DeliveryQuality.QualityType selectedQuality, String path, Client client)
    {
        log.debug_(String.format("Retrieving info of Segment for media item with id %s: %s", cast(Object[])[ mediaItemId, path ]));
        File segmentFile = findSegmentFile(path);
        return retrieveResourceInfo(mediaItemId, segmentFile);
    }

    private ResourceInfo retrieveResourceInfo(Long mediaItemId, File segmentFile)
    {
        return new SegmentInfo(mediaItemId, Long.valueOf(segmentFile.length()), "video/MP2T");
    }

    private File findSegmentFile(String path)
    {
        File segmentFile = new File(AbstractTranscodingDeliveryEngine.getTranscodingFolder(), getFilePathFromUrl(path));
        if ((segmentFile.exists()) && (segmentFile.isFile()) && (segmentFile.canRead())) {
            return segmentFile;
        }
        throw new FileNotFoundException(String.format("Could not find segment file: %s", cast(Object[])[ FileUtils.getProperFilePath(segmentFile) ]));
    }

    protected String getFilePathFromUrl(String path)
    {
        int filePathEnd = path.indexOf('?');
        return path.substring(path.indexOf(Resource.ResourceType.SEGMENT.toString()) + Resource.ResourceType.SEGMENT.toString().length() + 1, filePathEnd > -1 ? filePathEnd : path.length());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.SegmentRetrievalStrategy
* JD-Core Version:    0.7.0.1
*/