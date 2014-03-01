module org.serviio.delivery.SubtitlesRetrievalStrategy;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import org.serviio.delivery.subtitles.SubtitlesConfiguration;
import org.serviio.delivery.subtitles.SubtitlesInfo;
import org.serviio.delivery.subtitles.SubtitlesReader;
import org.serviio.delivery.subtitles.SubtitlesService;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.SubtitleCodec;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.Profile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SubtitlesRetrievalStrategy
  : ResourceRetrievalStrategy
{
  private static final Logger log = LoggerFactory.getLogger!(SubtitlesRetrievalStrategy);
  
  public DeliveryContainer retrieveResource(Long mediaItemId, MediaFormatProfile selectedVersion, QualityType selectedQuality, String path, Double timeOffsetInSeconds, Double durationInSeconds, Client client, bool markAsRead)
  {
    SubtitlesReader subtitleReader = findSoftSubs(mediaItemId, client);
    
    log.debug_(String.format("Retrieving Subtitles for media item with id %s", cast(Object[])[ mediaItemId ]));
    
    ResourceInfo resourceInfo = retrieveResourceInfo(mediaItemId, subtitleReader, client);
    byte[] subtitlesBytes = subtitleReader.getSubtitlesAsSRT();
    resourceInfo.setFileSize(new Long(subtitlesBytes.length));
    return new StreamDeliveryContainer(new ByteArrayInputStream(subtitlesBytes), resourceInfo);
  }
  
  public ResourceInfo retrieveResourceInfo(Long mediaItemId, MediaFormatProfile selectedVersion, QualityType selectedQuality, String path, Client client)
  {
    SubtitlesReader subtitleReader = findSoftSubs(mediaItemId, client);
    
    log.debug_(String.format("Retrieving info of Subtitles for media item with id %s", cast(Object[])[ mediaItemId ]));
    return retrieveResourceInfo(mediaItemId, subtitleReader, client);
  }
  
  private ResourceInfo retrieveResourceInfo(Long mediaItemId, SubtitlesReader subtitleReader, Client client)
  {
    SubtitleCodec codec = subtitleReader.getSubtitleCodec();
    if (codec is null) {
      throw new FileNotFoundException("Unknown subtitles format");
    }
    bool transcoded = (subtitleReader.getSubtitleCodec() != SubtitleCodec.SRT) || (subtitleReader.getExpectedSubtitlesSize() is null);
    return new SubtitlesInfo(mediaItemId, subtitleReader.getExpectedSubtitlesSize(), transcoded, client.getRendererProfile().getSubtitlesConfiguration().getSoftSubsMimeType());
  }
  
  private SubtitlesReader findSoftSubs(Long mediaItemId, Client client)
  {
    SubtitlesReader subtitleReader = SubtitlesService.getSoftSubs(mediaItemId, client.getRendererProfile());
    if (subtitleReader is null) {
      throw new FileNotFoundException(String.format("Subtitle file for media item %s cannot be found", cast(Object[])[ mediaItemId ]));
    }
    return subtitleReader;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.SubtitlesRetrievalStrategy
 * JD-Core Version:    0.7.0.1
 */