module org.serviio.library.local.metadata.extractor.embedded.h264.AspectRatio;

public class AspectRatio
{
  public static final AspectRatio Extended_SAR = new AspectRatio(255);
  private int value;
  
  private this(int value)
  {
    this.value = value;
  }
  
  public static AspectRatio fromValue(int value)
  {
    if (value == Extended_SAR.value) {
      return Extended_SAR;
    }
    return new AspectRatio(value);
  }
  
  public int getValue()
  {
    return this.value;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.AspectRatio
 * JD-Core Version:    0.7.0.1
 */