module org.serviio.library.entities.CoverImage;

import java.io.Serializable;
import org.serviio.db.entities.PersistedEntity;

public class CoverImage
  : PersistedEntity
  , Serializable
{
  private static final long serialVersionUID = 4659420820184102835L;
  private byte[] imageBytes;
  private String mimeType;
  private int width;
  private int height;
  private byte[] imageBytesHD;
  private int widthHD;
  private int heightHD;
  
  public this(byte[] imageBytes, String mimeType, int width, int height, byte[] imageBytesHD, int widthHD, int heightHD)
  {
    this.imageBytes = imageBytes;
    this.mimeType = mimeType;
    this.width = width;
    this.height = height;
    this.imageBytesHD = imageBytesHD;
    this.widthHD = widthHD;
    this.heightHD = heightHD;
  }
  
  public byte[] getImageBytes()
  {
    return this.imageBytes;
  }
  
  public String getMimeType()
  {
    return this.mimeType;
  }
  
  public int getWidth()
  {
    return this.width;
  }
  
  public int getHeight()
  {
    return this.height;
  }
  
  public byte[] getImageBytesHD()
  {
    return this.imageBytesHD;
  }
  
  public int getWidthHD()
  {
    return this.widthHD;
  }
  
  public int getHeightHD()
  {
    return this.heightHD;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.entities.CoverImage
 * JD-Core Version:    0.7.0.1
 */