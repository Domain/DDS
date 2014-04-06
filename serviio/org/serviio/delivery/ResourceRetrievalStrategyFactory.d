module org.serviio.delivery.ResourceRetrievalStrategyFactory;

import java.lang.RuntimeException;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.delivery.ResourceRetrievalStrategy;
import org.serviio.delivery.MediaResourceRetrievalStrategy;
import org.serviio.delivery.CoverImageRetrievalStrategy;
import org.serviio.delivery.SubtitlesRetrievalStrategy;
import org.serviio.delivery.ManifestRetrievalStrategy;
import org.serviio.delivery.SegmentRetrievalStrategy;

public class ResourceRetrievalStrategyFactory
{
    public ResourceRetrievalStrategy instantiateResourceRetrievalStrategy(ResourceType resourceType)
    {
        if (resourceType == ResourceType.MEDIA_ITEM) {
            return new MediaResourceRetrievalStrategy();
        }
        if (resourceType == ResourceType.COVER_IMAGE) {
            return new CoverImageRetrievalStrategy();
        }
        if (resourceType == ResourceType.SUBTITLE) {
            return new SubtitlesRetrievalStrategy();
        }
        if (resourceType == ResourceType.MANIFEST) {
            return new ManifestRetrievalStrategy();
        }
        if (resourceType == ResourceType.SEGMENT) {
            return new SegmentRetrievalStrategy();
        }
        throw new RuntimeException("Unsupported resource type: " ~ resourceType.toString());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.ResourceRetrievalStrategyFactory
* JD-Core Version:    0.7.0.1
*/