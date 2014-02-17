module org.serviio.ui.representation.OnlinePlugin;

public class OnlinePlugin
  : Comparable!(OnlinePlugin)
{
  private String name;
  private int version;
  
  public this() {}
  
  public this(String name, int version)
  {
    this.name = name;
    this.version = version;
  }
  
  public String getName()
  {
    return this.name;
  }
  
  public int getVersion()
  {
    return this.version;
  }
  
  public int compareTo(OnlinePlugin o)
  {
    return getName().compareTo(o.getName());
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.OnlinePlugin
 * JD-Core Version:    0.7.0.1
 */