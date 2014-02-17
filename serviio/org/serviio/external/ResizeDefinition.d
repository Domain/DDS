module org.serviio.external.ResizeDefinition;

public class ResizeDefinition
{
  public int width;
  public int height;
  public int contentWidth;
  public int contentHeight;
  bool darChanged;
  bool sarChangedToSquarePixels;
  bool heightChanged;
  
  public this(int width, int height)
  {
    this.width = width;
    this.height = height;
    this.contentWidth = width;
    this.contentHeight = height;
  }
  
  public this(int width, int height, int contentWidth, int contentHeight, bool darChanged, bool sarChanged, bool heightChanged)
  {
    this.width = makeWidthMultiplyOf2(width);
    this.height = height;
    this.contentWidth = makeWidthMultiplyOf2(contentWidth);
    this.contentHeight = contentHeight;
    this.darChanged = darChanged;
    this.sarChangedToSquarePixels = sarChanged;
    this.heightChanged = heightChanged;
  }
  
  public bool changed()
  {
    return (this.darChanged) || (this.sarChangedToSquarePixels) || (this.heightChanged);
  }
  
  public bool physicalDimensionsChanged()
  {
    return (this.heightChanged) || (this.sarChangedToSquarePixels);
  }
  
  private int makeWidthMultiplyOf2(int width)
  {
    return (width + 1) / 2 * 2;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.external.ResizeDefinition
 * JD-Core Version:    0.7.0.1
 */