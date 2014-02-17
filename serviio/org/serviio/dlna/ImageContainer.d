module org.serviio.dlna.ImageContainer;

public enum ImageContainer
{
  JPEG,  PNG,  GIF,  RAW;
  
  private this() {}
  
  public static ImageContainer getByName(String name)
  {
    if (name !is null)
    {
      if (name.equals("jpeg")) {
        return JPEG;
      }
      if (name.equals("gif")) {
        return GIF;
      }
      if (name.equals("png")) {
        return PNG;
      }
      if (name.equals("raw")) {
        return RAW;
      }
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.dlna.ImageContainer
 * JD-Core Version:    0.7.0.1
 */