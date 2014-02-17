module org.serviio.upnp.service.contentdirectory.command.NonRecursiveIdGenerator;

public class NonRecursiveIdGenerator
{
  public static String generateId(String parentId, String idPrefix, String objectIdentifier)
  {
    if (parentId !is null) {
      return parentId + "^" + idPrefix + "_" + objectIdentifier;
    }
    return objectIdentifier;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.command.NonRecursiveIdGenerator
 * JD-Core Version:    0.7.0.1
 */