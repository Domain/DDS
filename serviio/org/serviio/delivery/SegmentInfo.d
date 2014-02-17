module org.serviio.delivery.SegmentInfo;

public class SegmentInfo
  : ResourceInfo
{
  public this(Long resourceId, Long fileSize, String mimeType)
  {
    super(resourceId);
    this.fileSize = fileSize;
    this.mimeType = mimeType;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.delivery.SegmentInfo
 * JD-Core Version:    0.7.0.1
 */