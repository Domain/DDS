module org.serviio.delivery.ResourceRetrievalStrategyFactory;

import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;

public class ResourceRetrievalStrategyFactory
{
    public ResourceRetrievalStrategy instantiateResourceRetrievalStrategy(Resource.ResourceType resourceType)
    {
        if (resourceType == Resource.ResourceType.MEDIA_ITEM) {
            return new MediaResourceRetrievalStrategy();
        }
        if (resourceType == Resource.ResourceType.COVER_IMAGE) {
            return new CoverImageRetrievalStrategy();
        }
        if (resourceType == Resource.ResourceType.SUBTITLE) {
            return new SubtitlesRetrievalStrategy();
        }
        if (resourceType == Resource.ResourceType.MANIFEST) {
            return new ManifestRetrievalStrategy();
        }
        if (resourceType == Resource.ResourceType.SEGMENT) {
            return new SegmentRetrievalStrategy();
        }
        throw new RuntimeException("Unsupported resource type: " + resourceType);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.ResourceRetrievalStrategyFactory
* JD-Core Version:    0.7.0.1
*/