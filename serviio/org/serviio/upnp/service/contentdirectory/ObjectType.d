module org.serviio.upnp.service.contentdirectory.ObjectType;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public enum ObjectType
{
  CONTAINERS,  ITEMS,  ALL;
  
  private this() {}
  
  public bool supportsContainers()
  {
    return getContainerTypes().contains(this);
  }
  
  public bool supportsItems()
  {
    return getItemTypes().contains(this);
  }
  
  public static Set!(ObjectType) getItemTypes()
  {
    return new HashSet(Arrays.asList(cast(ObjectType[])[ ITEMS, ALL ]));
  }
  
  public static Set!(ObjectType) getContainerTypes()
  {
    return new HashSet(Arrays.asList(cast(ObjectType[])[ CONTAINERS, ALL ]));
  }
  
  public static Set!(ObjectType) getAllTypes()
  {
    return new HashSet(Arrays.asList(cast(ObjectType[])[ CONTAINERS, ITEMS, ALL ]));
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.ObjectType
 * JD-Core Version:    0.7.0.1
 */