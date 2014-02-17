module org.serviio.ui.representation.MetadataRepresentation;

public class MetadataRepresentation
{
  private bool audioLocalArtExtractorEnabled;
  private bool videoLocalArtExtractorEnabled;
  private bool videoOnlineArtExtractorEnabled;
  private bool videoGenerateLocalThumbnailEnabled;
  private bool imageGenerateLocalThumbnailEnabled;
  private String metadataLanguage;
  private String descriptiveMetadataExtractor;
  private bool retrieveOriginalTitle;
  
  public bool isAudioLocalArtExtractorEnabled()
  {
    return this.audioLocalArtExtractorEnabled;
  }
  
  public void setAudioLocalArtExtractorEnabled(bool audioLocalArtExtractorEnabled)
  {
    this.audioLocalArtExtractorEnabled = audioLocalArtExtractorEnabled;
  }
  
  public bool isVideoLocalArtExtractorEnabled()
  {
    return this.videoLocalArtExtractorEnabled;
  }
  
  public void setVideoLocalArtExtractorEnabled(bool videoLocalArtExtractorEnabled)
  {
    this.videoLocalArtExtractorEnabled = videoLocalArtExtractorEnabled;
  }
  
  public bool isVideoOnlineArtExtractorEnabled()
  {
    return this.videoOnlineArtExtractorEnabled;
  }
  
  public void setVideoOnlineArtExtractorEnabled(bool videoOnlineArtExtractorEnabled)
  {
    this.videoOnlineArtExtractorEnabled = videoOnlineArtExtractorEnabled;
  }
  
  public bool isVideoGenerateLocalThumbnailEnabled()
  {
    return this.videoGenerateLocalThumbnailEnabled;
  }
  
  public void setVideoGenerateLocalThumbnailEnabled(bool videoGenerateLocalThumbnailEnabled)
  {
    this.videoGenerateLocalThumbnailEnabled = videoGenerateLocalThumbnailEnabled;
  }
  
  public String getMetadataLanguage()
  {
    return this.metadataLanguage;
  }
  
  public void setMetadataLanguage(String metadataLanguage)
  {
    this.metadataLanguage = metadataLanguage;
  }
  
  public String getDescriptiveMetadataExtractor()
  {
    return this.descriptiveMetadataExtractor;
  }
  
  public void setDescriptiveMetadataExtractor(String descriptionMetadataExtractor)
  {
    this.descriptiveMetadataExtractor = descriptionMetadataExtractor;
  }
  
  public bool isRetrieveOriginalTitle()
  {
    return this.retrieveOriginalTitle;
  }
  
  public void setRetrieveOriginalTitle(bool retrieveOriginalTitle)
  {
    this.retrieveOriginalTitle = retrieveOriginalTitle;
  }
  
  public bool isImageGenerateLocalThumbnailEnabled()
  {
    return this.imageGenerateLocalThumbnailEnabled;
  }
  
  public void setImageGenerateLocalThumbnailEnabled(bool imageGenerateLocalThumbnailEnabled)
  {
    this.imageGenerateLocalThumbnailEnabled = imageGenerateLocalThumbnailEnabled;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.MetadataRepresentation
 * JD-Core Version:    0.7.0.1
 */