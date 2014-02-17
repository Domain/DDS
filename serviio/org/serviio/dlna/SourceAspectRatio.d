module org.serviio.dlna.SourceAspectRatio;

import java.io.Serializable;

public class SourceAspectRatio
  : Serializable
{
  private static final long serialVersionUID = -8005554151258629559L;
  private immutable String sar;
  
  public static SourceAspectRatio square()
  {
    return new SourceAspectRatio(null);
  }
  
  public this(String sar)
  {
    this.sar = (sar !is null ? sar : "1:1");
  }
  
  public bool isSquarePixels()
  {
    return Math.abs(1.0F - getSar().floatValue()) < 0.01;
  }
  
  public Float getSar()
  {
    String[] sarRatio = this.sar.split(":");
    if (sarRatio.length == 2) {
      try
      {
        return Float.valueOf(Float.parseFloat(sarRatio[0]) / Float.parseFloat(sarRatio[1]));
      }
      catch (Exception e) {}
    }
    return Float.valueOf(1.0F);
  }
  
  public String toString()
  {
    return this.sar;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.dlna.SourceAspectRatio
 * JD-Core Version:    0.7.0.1
 */