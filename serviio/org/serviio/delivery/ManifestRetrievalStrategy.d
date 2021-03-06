module org.serviio.delivery.ManifestRetrievalStrategy;

import java.lang;
import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.Video;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.upnp.service.contentdirectory.command.ResourceValuesBuilder;
import org.serviio.delivery.ResourceRetrievalStrategy;
import org.serviio.delivery.DeliveryContainer;
import org.serviio.delivery.Client;
import org.serviio.delivery.ResourceInfo;
import org.serviio.delivery.StreamDeliveryContainer;
import org.serviio.delivery.ManifestInfo;
import org.serviio.delivery.MediaResourceRetrievalStrategy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ManifestRetrievalStrategy : ResourceRetrievalStrategy
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(ManifestRetrievalStrategy);
    }

    public DeliveryContainer retrieveResource(Long mediaItemId, MediaFormatProfile selectedVersion, QualityType selectedQuality, String path, Double timeOffsetInSeconds, Double durationInSeconds, Client client, bool markAsRead)
    {
        log.debug_(String_format("Retrieving Manifest for media item with id %s", cast(Object[])[ mediaItemId ]));

        String manifest = generateManifest(mediaItemId, client, selectedQuality);
        ResourceInfo resourceInfo = retrieveResourceInfo(mediaItemId, selectedVersion, client, manifest.length());
        return new StreamDeliveryContainer(new ByteArrayInputStream(manifest.getBytes("UTF-8")), resourceInfo);
    }

    public ResourceInfo retrieveResourceInfo(Long mediaItemId, MediaFormatProfile selectedVersion, QualityType selectedQuality, String path, Client client)
    {
        log.debug_(String_format("Retrieving info of Manifest for media item with id %s", cast(Object[])[ mediaItemId ]));
        String manifest = generateManifest(mediaItemId, client, selectedQuality);
        return retrieveResourceInfo(mediaItemId, selectedVersion, client, manifest.length());
    }

    private ResourceInfo retrieveResourceInfo(Long mediaItemId, MediaFormatProfile selectedVersion, Client client, int manifestFileSize)
    {
        return new ManifestInfo(mediaItemId, new Long(manifestFileSize), client.getRendererProfile().getMimeType(selectedVersion));
    }

    private String generateManifest(Long mediaItemId, Client client, QualityType selectedQuality)
    {
        MediaItem mediaItem = MediaResourceRetrievalStrategy.loadMediaItem(mediaItemId);
        if (mediaItem !is null)
        {
            if (mediaItem.getFileType() == MediaFileType.VIDEO)
            {
                List!(Resource) resources = ResourceValuesBuilder.buildResources(cast(Video)mediaItem, client.getRendererProfile());
                foreach (Resource resource ; resources) {
                    if (resource.getResourceType() == ResourceType.MANIFEST)
                    {
                        StringBuffer sb = new StringBuffer();
                        try
                        {
                            return "#EXTM3U" ~ "\n" ~ "#EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=1600000" ~ "\n" ~ resource.clone(ResourceType.MEDIA_ITEM, selectedQuality).getGeneratedURL(client.getHostInfo());
                        }
                        catch (InvalidResourceException e)
                        {
                            throw new FileNotFoundException(e.getMessage());
                        }
                    }
                }
                throw new FileNotFoundException("No suitable manifest resource found for item " ~ mediaItemId.toString());
            }
            throw new RuntimeException("Only video files are supported for manifest files.");
        }
        throw new FileNotFoundException(String_format("Video with id %s not found", cast(Object[])[ mediaItemId ]));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.ManifestRetrievalStrategy
* JD-Core Version:    0.7.0.1
*/