module org.serviio.upnp.service.contentdirectory.CDSCacheDecorator;

import org.serviio.cache.CacheDecorator;
import org.serviio.library.entities.AccessGroup;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;

public abstract interface CDSCacheDecorator
  : CacheDecorator
{
  public abstract void store(BrowseItemsHolder!(DirectoryObject) paramBrowseItemsHolder, String paramString1, ObjectType paramObjectType, String paramString2, String paramString3, int paramInt1, int paramInt2, String paramString4, Profile paramProfile, AccessGroup paramAccessGroup, bool paramBoolean);
  
  public abstract BrowseItemsHolder!(DirectoryObject) retrieve(String paramString1, ObjectType paramObjectType, String paramString2, String paramString3, int paramInt1, int paramInt2, String paramString4, Profile paramProfile, AccessGroup paramAccessGroup, bool paramBoolean);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.CDSCacheDecorator
 * JD-Core Version:    0.7.0.1
 */