module org.serviio.upnp.service.contentdirectory.NoCacheDecorator;

import java.lang.String;
import org.serviio.library.entities.AccessGroup;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.CDSCacheDecorator;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.BrowseItemsHolder;

public class NoCacheDecorator : CDSCacheDecorator
{
    public void evictAll() {}

    public BrowseItemsHolder!(DirectoryObject) retrieve(String objectID, ObjectType objectType, String browseFlag, String filter, int startingIndex, int requestedCount, String sortCriteria, Profile rendererProfile, AccessGroup accessGroup, bool disablePresentationSettings)
    {
        return null;
    }

    public void store(BrowseItemsHolder!(DirectoryObject) object, String objectID, ObjectType objectType, String browseFlag, String filter, int startingIndex, int requestedCount, String sortCriteria, Profile rendererProfile, AccessGroup accessGroup, bool disablePresentationSettings) {}

    public void shutdown() {}
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.NoCacheDecorator
* JD-Core Version:    0.7.0.1
*/