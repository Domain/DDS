module org.serviio.upnp.service.contentdirectory.command.AbstractListObjectsByFSHierarchyCommand;

import java.lang;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.Folder;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.Repository;
import org.serviio.library.local.service.AudioService;
import org.serviio.library.local.service.FolderService;
import org.serviio.library.local.service.ImageService;
import org.serviio.library.local.service.RepositoryService;
import org.serviio.library.local.service.VideoService;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectNotFoundException;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObjectBuilder;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.upnp.service.contentdirectory.command.AbstractCommand;

public abstract class AbstractListObjectsByFSHierarchyCommand : AbstractCommand!(DirectoryObject)
{
    public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected Set!(ObjectClassType) getSupportedClasses()
    {
        return new HashSet(Arrays.asList(ObjectClassType.values()));
    }

    override protected Set!(ObjectType) getSupportedObjectTypes()
    {
        return ObjectType.getAllTypes();
    }

    override protected List!(DirectoryObject) retrieveList()
    {
        List!(DirectoryObject) objects = new ArrayList();
        Long repositoryId = getRepositoryId();
        if (repositoryId is null)
        {
            if (this.objectType.supportsContainers())
            {
                List!(Repository) repositories = RepositoryService.getListOfRepositories(this.fileType, this.accessGroup, this.startIndex, this.count);
                foreach (Repository repository ; repositories)
                {
                    String runtimeId = generateRepositoryObjectId(repository.getId());
                    Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(repository, runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, repository.getRepositoryName(), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);

                    objects.add(DirectoryObjectBuilder.createInstance(this.containerClassType, values, getContainerResources(values, repository.getId(), this.rendererProfile), repository.getId(), this.disablePresentationSettings));
                }
            }
        }
        else
        {
            Long folderId = getFolderId();
            int returnedFoldersCount = 0;
            int existingFoldersCount = 0;
            if (this.objectType.supportsContainers())
            {
                existingFoldersCount = FolderService.getNumberOfSubfolders(folderId, repositoryId, this.accessGroup);
                if (this.startIndex < existingFoldersCount)
                {
                    List!(Folder) folders = FolderService.getListOfSubFolders(folderId, repositoryId, this.accessGroup, this.startIndex, this.count);
                    foreach (Folder folder ; folders)
                    {
                        String runtimeId = generateFolderObjectId(folder.getId());
                        Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(folder, runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, folder.getName(), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);

                        objects.add(DirectoryObjectBuilder.createInstance(this.containerClassType, values, getContainerResources(values, folder.getId(), this.rendererProfile), folder.getId(), this.disablePresentationSettings));
                    }
                    returnedFoldersCount = folders.size();
                }
            }
            if ((this.count > returnedFoldersCount) && (this.objectType.supportsItems()))
            {
                if (folderId is null) {
                    folderId = FolderService.retrieveVirtualFolderId(repositoryId);
                }
                if (folderId !is null)
                {
                    int itemStartIndex = this.startIndex - existingFoldersCount + returnedFoldersCount;
                    List/*!(? : MediaItem)*/ items = getItemsForMediaType(folderId, itemStartIndex, this.count - returnedFoldersCount);
                    foreach (MediaItem item ; items)
                    {
                        String runtimeId = generateItemObjectId(item.getId());
                        Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(item, runtimeId, getDisplayedContainerId(this.objectId), this.objectType, this.searchCriteria, getItemTitle(item), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);

                        List!(Resource) res = ResourceValuesBuilder.buildResources(item, this.rendererProfile);
                        objects.add(DirectoryObjectBuilder.createInstance(this.itemClassType, values, res, item.getId(), this.disablePresentationSettings));
                    }
                }
            }
        }
        return objects;
    }

    override protected DirectoryObject retrieveSingleItem()
    {
        Long itemId = getMediaItemId();
        if (itemId !is null)
        {
            MediaItem item = getItem(itemId);
            if (item !is null)
            {
                Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(item, this.objectId, RecursiveIdGenerator.getRecursiveParentId(this.objectId), this.objectType, this.searchCriteria, getItemTitle(item), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);

                List!(Resource) res = ResourceValuesBuilder.buildResources(item, this.rendererProfile);
                return DirectoryObjectBuilder.createInstance(this.itemClassType, values, res, itemId, this.disablePresentationSettings);
            }
            throw new ObjectNotFoundException(java.lang.String.format("MediaItem with id %s not found in CDS", cast(Object[])[ itemId ]));
        }
        Long folderId = getFolderId();
        if (folderId !is null)
        {
            Folder folder = FolderService.getFolder(folderId);
            if (folder !is null)
            {
                Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(folder, this.objectId, RecursiveIdGenerator.getRecursiveParentId(this.objectId), this.objectType, this.searchCriteria, folder.getName(), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);

                return DirectoryObjectBuilder.createInstance(this.containerClassType, values, getContainerResources(values, folderId, this.rendererProfile), folderId, this.disablePresentationSettings);
            }
            throw new ObjectNotFoundException(java.lang.String.format("Folder with id %s not found in CDS", cast(Object[])[ folderId ]));
        }
        Long repositoryId = getRepositoryId();
        Repository repository = RepositoryService.getRepository(repositoryId);
        if (repository !is null)
        {
            Map!(ClassProperties, Object) values = ObjectValuesBuilder.buildObjectValues(repository, this.objectId, Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings), this.objectType, this.searchCriteria, repository.getRepositoryName(), this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);

            return DirectoryObjectBuilder.createInstance(this.containerClassType, values, getContainerResources(values, repositoryId, this.rendererProfile), repositoryId, this.disablePresentationSettings);
        }
        throw new ObjectNotFoundException(java.lang.String.format("Repository with id %s not found in CDS", cast(Object[])[ this.objectId ]));
    }

    public int retrieveItemCount()
    {
        Long repositoryId = getRepositoryId();
        if (repositoryId is null) {
            return this.objectType.supportsContainers() ? RepositoryService.getNumberOfRepositories(this.fileType, this.accessGroup) : 0;
        }
        return FolderService.getNumberOfFoldersAndMediaItems(this.fileType, this.objectType, this.accessGroup, getFolderId(), repositoryId);
    }

    private String generateRepositoryObjectId(Number entityId)
    {
        return RecursiveIdGenerator.generateRepositoryObjectId(entityId, this.objectId, this.idPrefix);
    }

    private String generateFolderObjectId(Number entityId)
    {
        return RecursiveIdGenerator.generateFolderObjectId(entityId, this.objectId);
    }

    private String generateItemObjectId(Number entityId)
    {
        return RecursiveIdGenerator.generateItemObjectId(entityId, this.objectId);
    }

    private Long getFolderId()
    {
        String folderPrefix = "$F";
        if (this.objectId.indexOf(folderPrefix) > -1)
        {
            String strippedId = this.objectId.substring(this.objectId.lastIndexOf(folderPrefix));
            return Long.valueOf(Long.parseLong(strippedId.substring(folderPrefix.length())));
        }
        return null;
    }

    private Long getMediaItemId()
    {
        String itemPrefix = "$MI";
        if (this.objectId.indexOf(itemPrefix) > -1)
        {
            String strippedId = this.objectId.substring(this.objectId.lastIndexOf(itemPrefix));
            return Long.valueOf(Long.parseLong(strippedId.substring(itemPrefix.length())));
        }
        return null;
    }

    private Long getRepositoryId()
    {
        if (this.objectId.indexOf("R") > -1)
        {
            String strippedId = this.objectId.substring(this.objectId.indexOf("R"));
            if (strippedId.indexOf("$") > -1) {
                strippedId = strippedId.substring(0, strippedId.indexOf("$"));
            }
            return Long.valueOf(Long.parseLong(strippedId.substring("R".length())));
        }
        return null;
    }

    private List!(Object/*? : MediaItem*/) getItemsForMediaType(Long folderId, int startIndex, int count)
    {
        if (this.fileType == MediaFileType.AUDIO) {
            return AudioService.getListOfSongsForFolder(folderId, this.accessGroup, startIndex, count);
        }
        if (this.fileType == MediaFileType.IMAGE) {
            return ImageService.getListOfImagesForFolder(folderId, this.accessGroup, startIndex, count);
        }
        if (this.fileType == MediaFileType.VIDEO) {
            return VideoService.getListOfVideosForFolder(folderId, this.accessGroup, startIndex, count);
        }
        return Collections.emptyList();
    }

    private MediaItem getItem(Long itemId)
    {
        if (this.fileType == MediaFileType.AUDIO) {
            return AudioService.getSong(itemId);
        }
        if (this.fileType == MediaFileType.IMAGE) {
            return ImageService.getImage(itemId);
        }
        if (this.fileType == MediaFileType.VIDEO) {
            return VideoService.getVideo(itemId);
        }
        return null;
    }

    private String getItemTitle(MediaItem item)
    {
        return item.getFileName();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractListObjectsByFSHierarchyCommand
* JD-Core Version:    0.7.0.1
*/