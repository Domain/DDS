module org.serviio.upnp.service.contentdirectory.command.OnlineRecursiveIdGenerator;

import java.lang;

public class OnlineRecursiveIdGenerator
{
    public static immutable String FOLDER_PREFIX = "FD";
    public static immutable String ITEM_PREFIX = "OI";

    public static String generateFolderObjectId(Number entityId, String parentObjectId, String idPrefix)
    {
        return NonRecursiveIdGenerator.generateId(parentObjectId, idPrefix, "FD" + entityId.toString());
    }

    public static String generateItemObjectId(Number entityId, String parentObjectId, String idPrefix)
    {
        return parentObjectId ~ "$" ~ "OI" ~ entityId.toString();
    }

    public static String getRecursiveParentId(String objectId)
    {
        int itemSeparator = objectId.lastIndexOf("$");
        int folderPrefixSeparator = objectId.lastIndexOf("FD");
        if ((itemSeparator != -1) && (folderPrefixSeparator != -1)) {
            return objectId.substring(0, itemSeparator);
        }
        return objectId.substring(0, objectId.lastIndexOf("^"));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.OnlineRecursiveIdGenerator
* JD-Core Version:    0.7.0.1
*/