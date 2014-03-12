module org.serviio.upnp.service.contentdirectory.command.RecursiveIdGenerator;

import java.lang;

public class RecursiveIdGenerator
{
    public static immutable String REPOSITORY_PREFIX = "R";
    public static immutable String FOLDER_PREFIX = "F";
    public static immutable String ITEM_PREFIX = "MI";
    public static immutable String HIERARCHY_SEPARATOR = "$";

    public static String generateRepositoryObjectId(Number entityId, String parentId, String idPrefix)
    {
        return NonRecursiveIdGenerator.generateId(parentId, idPrefix, "R" + entityId.toString());
    }

    public static String generateFolderObjectId(Number entityId, String parentObjectId)
    {
        return parentObjectId ~ "$" ~ "F" ~ entityId.toString();
    }

    public static String generateItemObjectId(Number entityId, String parentObjectId)
    {
        return parentObjectId ~ "$" ~ "MI" ~ entityId.toString();
    }

    public static String getRecursiveParentId(String objectId)
    {
        if (objectId.contains("$")) {
            return objectId.substring(0, objectId.lastIndexOf("$"));
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.RecursiveIdGenerator
* JD-Core Version:    0.7.0.1
*/