module org.serviio.library.local.OnlineDBIdentifier;

import java.util.Map;

public enum OnlineDBIdentifier
{
  IMDB,  TVDB,  TMDB;
  
  private static EnumMapConverter!(OnlineDBIdentifier) converter = new class() EnumMapConverter {
    protected OnlineDBIdentifier enumValue(String name)
    {
      return OnlineDBIdentifier.valueOf(name);
    }
  };
  
  private this() {}
  
  public static Map!(OnlineDBIdentifier, String) parseFromString(String identifiersCSV)
  {
    return converter.convert(identifiersCSV);
  }
  
  public static String parseToString(Map!(OnlineDBIdentifier, String) identifiers)
  {
    return converter.parseToString(identifiers);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.OnlineDBIdentifier
 * JD-Core Version:    0.7.0.1
 */