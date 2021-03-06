module org.serviio.library.dao.FolderDAO;

import java.lang.Long;
import java.lang.String;
import java.io.File;
import java.util.List;
import org.serviio.db.dao.GenericDAO;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Folder;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.util.Tupple;

public abstract interface FolderDAO : GenericDAO!(Folder)
{
    public static immutable String VIRTUAL_FOLDER_NAME = "!(virtual)";

    public abstract Tupple!(Long, List!(Tupple!(Long, String))) getOrCreateFolder(File paramFile, Long paramLong);

    public abstract int getNumberOfMediaItems(Long paramLong);

    public abstract int getNumberOfSubFolders(Long paramLong1, Long paramLong2, AccessGroup paramAccessGroup);

    public abstract int getNumberOfFoldersAndMediaItems(MediaFileType paramMediaFileType, ObjectType paramObjectType, AccessGroup paramAccessGroup, Long paramLong1, Long paramLong2);

    public abstract List!(Folder) retrieveFoldersWithMedia(MediaFileType paramMediaFileType, AccessGroup paramAccessGroup, int paramInt1, int paramInt2);

    public abstract int getFoldersWithMediaCount(MediaFileType paramMediaFileType, AccessGroup paramAccessGroup);

    public abstract List!(Folder) retrieveSubFolders(Long paramLong1, Long paramLong2, AccessGroup paramAccessGroup, int paramInt1, int paramInt2);

    public abstract Long retrieveVirtualFolderId(Long paramLong);

    public abstract Tupple!(Long, List!(Tupple!(Long, String))) getFolderHierarchy(Long paramLong);

    public abstract List!(Folder) getFoldersInRepository(Long paramLong);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.FolderDAO
* JD-Core Version:    0.7.0.1
*/