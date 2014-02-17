module org.serviio.delivery.ResourceInfo;

public abstract class ResourceInfo
{
  protected Long resourceId;
  protected Long fileSize;
  protected bool transcoded;
  protected bool live;
  protected Integer duration;
  protected String mimeType;
  
  public this(Long resourceId)
  {
    this.resourceId = resourceId;
  }
  
  public Long getFileSize()
  {
    return this.fileSize;
  }
  
  public bool isTranscoded()
  {
    return this.transcoded;
  }
  
  public Long getResourceId()
  {
    return this.resourceId;
  }
  
  public Integer getDuration()
  {
    return this.duration;
  }
  
  public String getMimeType()
  {
    return this.mimeType;
  }
  
  public void setFileSize(Long fileSize)
  {
    this.fileSize = fileSize;
  }
  
  public void setTranscoded(bool transcoded)
  {
    this.transcoded = transcoded;
  }
  
  public bool isLive()
  {
    return this.live;
  }
  
  public String toString()
  {
    StringBuilder builder = new StringBuilder();
    builder.append("ResourceInfo [resourceId=").append(this.resourceId).append(", fileSize=").append(this.fileSize).append(", duration=").append(this.duration).append(", mimeType=").append(this.mimeType).append(", transcoded=").append(this.transcoded).append("]");
    

    return builder.toString();
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.ResourceInfo
 * JD-Core Version:    0.7.0.1
 */