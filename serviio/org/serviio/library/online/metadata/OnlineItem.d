module org.serviio.library.online.metadata.OnlineItem;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import org.serviio.delivery.DeliveryContext;
import org.serviio.library.entities.Image;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.entities.Video;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.local.metadata.MPAARating;
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.library.metadata.ItemMetadata;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.online.OnlineItemId;
import org.serviio.util.FileUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;

public abstract class OnlineItem
  : ItemMetadata
{
  private OnlineItemId id;
  private ImageDescriptor thumbnail;
  private String contentUrl;
  private MediaFileType type;
  private TechnicalMetadata technicalMD = new TechnicalMetadata();
  private String cacheKey;
  private bool validEssence = true;
  private bool live = false;
  private String userAgent;
  
  public void validateMetadata()
  {
    super.validateMetadata();
    if (this.contentUrl is null) {
      throw new InvalidMetadataException("Unknown feed entry URL.");
    }
    if (this.type is null) {
      throw new InvalidMetadataException("Unknown feed entry type.");
    }
  }
  
  public void fillInUnknownEntries()
  {
    if (ObjectValidator.isEmpty(this.author)) {
      setAuthor("Unknown");
    }
    if (ObjectValidator.isEmpty(this.title)) {
      setTitle("Unknown");
    }
    if (this.date is null) {
      setDate(new Date());
    }
    if (ObjectValidator.isEmpty(this.cacheKey)) {
      setCacheKey(this.contentUrl);
    }
  }
  
  public String getDisplayTitle(String repositoryName)
  {
    if (ObjectValidator.isNotEmpty(repositoryName)) {
      return repositoryName;
    }
    return getTitle();
  }
  
  public MediaItem toMediaItem()
  {
    DeliveryContext deliveryContext = new DeliveryContext(false, this.userAgent);
    if (this.type == MediaFileType.IMAGE)
    {
      Image image = new Image(this.title, this.technicalMD.getImageContainer(), this.contentUrl, this.contentUrl, this.technicalMD.getFileSize(), null, null, this.date);
      image.setHeight(this.technicalMD.getHeight());
      image.setWidth(this.technicalMD.getWidth());
      image.setId(getId());
      image.setLive(false);
      if (getThumbnail() !is null) {
        image.setThumbnailId(image.getId());
      }
      image.setChromaSubsampling(this.technicalMD.getChromaSubsampling());
      image.setDeliveryContext(deliveryContext);
      return image;
    }
    if (this.type == MediaFileType.AUDIO)
    {
      MusicTrack track = new MusicTrack(this.title, this.technicalMD.getAudioContainer(), this.contentUrl, this.contentUrl, this.technicalMD.getFileSize(), null, null, this.date);
      track.setId(getId());
      if (getThumbnail() !is null) {
        track.setThumbnailId(track.getId());
      }
      track.setBitrate(this.technicalMD.getBitrate());
      track.setDuration(this.technicalMD.getDuration() !is null ? Integer.valueOf(this.technicalMD.getDuration().intValue()) : null);
      track.setSampleFrequency(this.technicalMD.getSamplingRate() !is null ? Integer.valueOf(this.technicalMD.getSamplingRate().intValue()) : null);
      track.setChannels(this.technicalMD.getChannels());
      track.setLive(this.live);
      track.setDeliveryContext(deliveryContext);
      return track;
    }
    if (this.type == MediaFileType.VIDEO)
    {
      Video video = new Video(this.title, this.technicalMD.getVideoContainer(), this.contentUrl, this.contentUrl, this.technicalMD.getFileSize(), null, null, this.date);
      video.setId(getId());
      if (getThumbnail() !is null) {
        video.setThumbnailId(video.getId());
      }
      video.setAudioBitrate(this.technicalMD.getAudioBitrate());
      video.setAudioCodec(this.technicalMD.getAudioCodec());
      video.setAudioStreamIndex(this.technicalMD.getAudioStreamIndex());
      video.setBitrate(this.technicalMD.getBitrate());
      video.setChannels(this.technicalMD.getChannels());
      video.setDuration(this.technicalMD.getDuration() !is null ? Integer.valueOf(this.technicalMD.getDuration().intValue()) : null);
      video.setFps(this.technicalMD.getFps());
      video.setFrequency(this.technicalMD.getSamplingRate());
      video.setHeight(this.technicalMD.getHeight());
      video.setVideoCodec(this.technicalMD.getVideoCodec());
      video.setVideoStreamIndex(this.technicalMD.getVideoStreamIndex());
      video.setWidth(this.technicalMD.getWidth());
      video.setFtyp(this.technicalMD.getFtyp());
      video.setH264Levels(this.technicalMD.getH264Levels());
      video.setH264Profile(this.technicalMD.getH264Profile());
      video.setSar(this.technicalMD.getSar());
      video.setLive(this.live);
      video.setDeliveryContext(deliveryContext);
      video.setRating(MPAARating.UNKNOWN);
      return video;
    }
    return null;
  }
  
  public void setMediaType(String mimeType, String contentUrl)
  {
    String normalizedMimeType = StringUtils.localeSafeToLowercase(mimeType);
    String extension = null;
    try
    {
      extension = StringUtils.localeSafeToLowercase(FileUtils.getFileExtension(new URL(contentUrl)));
    }
    catch (MalformedURLException e) {}
    this.type = MediaFileType.findMediaFileTypeByMimeType(normalizedMimeType);
    if ((this.type is null) && (extension !is null)) {
      this.type = MediaFileType.findMediaFileTypeByExtension(extension);
    }
  }
  
  public bool isCompletelyLoaded()
  {
    if (this.type == MediaFileType.IMAGE) {
      return (this.technicalMD !is null) && (this.technicalMD.getFileSize() !is null) && (this.technicalMD.getImageContainer() !is null);
    }
    if (this.type == MediaFileType.AUDIO) {
      return (this.technicalMD !is null) && (this.technicalMD.getFileSize() !is null) && (this.technicalMD.getAudioContainer() !is null);
    }
    if (this.type == MediaFileType.VIDEO) {
      return (this.technicalMD !is null) && (this.technicalMD.getFileSize() !is null) && (this.technicalMD.getVideoContainer() !is null);
    }
    return false;
  }
  
  public DeliveryContext deliveryContext()
  {
    return new DeliveryContext(false, this.userAgent);
  }
  
  protected abstract OnlineItemId generateId();
  
  protected void resetId()
  {
    this.id = null;
  }
  
  public Long getId()
  {
    if (this.id is null) {
      this.id = generateId();
    }
    return Long.valueOf(this.id.value());
  }
  
  public ImageDescriptor getThumbnail()
  {
    return this.thumbnail;
  }
  
  public void setThumbnail(ImageDescriptor thumbnail)
  {
    this.thumbnail = thumbnail;
  }
  
  public String getContentUrl()
  {
    return this.contentUrl;
  }
  
  public void setContentUrl(String contentUrl)
  {
    this.contentUrl = contentUrl;
  }
  
  public MediaFileType getType()
  {
    return this.type;
  }
  
  public void setType(MediaFileType type)
  {
    this.type = type;
  }
  
  public TechnicalMetadata getTechnicalMD()
  {
    return this.technicalMD;
  }
  
  public void setTechnicalMD(TechnicalMetadata technicalMD)
  {
    this.technicalMD = technicalMD;
  }
  
  public String getCacheKey()
  {
    return this.cacheKey;
  }
  
  public void setCacheKey(String cacheKey)
  {
    this.cacheKey = cacheKey;
  }
  
  public bool isValidEssence()
  {
    return this.validEssence;
  }
  
  public void setValidEssence(bool validEssence)
  {
    this.validEssence = validEssence;
  }
  
  public bool isLive()
  {
    return this.live;
  }
  
  public void setLive(bool live)
  {
    this.live = live;
  }
  
  public String getUserAgent()
  {
    return this.userAgent;
  }
  
  public void setUserAgent(String userAgent)
  {
    this.userAgent = userAgent;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.metadata.OnlineItem
 * JD-Core Version:    0.7.0.1
 */