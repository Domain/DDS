module org.serviio.upnp.service.contentdirectory.definition.ActionNode;

import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.search.SearchIndexer:SearchCategory;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.BrowseItemsHolder;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.Command;
import org.serviio.upnp.service.contentdirectory.command.CommandExecutionException;
import org.serviio.util.ObjectValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ActionNode : ContainerNode
{
    private static final Logger log = LoggerFactory.getLogger!(ActionNode);
    private String commandClass;
    private String idPrefix;
    private bool recursive;
    private List!(SearchIndexer.SearchCategory) searchCategories;

    public this(String commandClassName, String idPrefix, ObjectClassType containerClass, ObjectClassType itemClass, DefinitionNode parent, String cacheRegion, bool recursive, List!(SearchIndexer.SearchCategory) searchCategories)
    {
        super(containerClass, parent, cacheRegion);
        this.itemClass = itemClass;
        this.commandClass = commandClassName;
        this.idPrefix = idPrefix;
        this.recursive = recursive;
        this.searchCategories = searchCategories;
    }

    public DirectoryObject retrieveDirectoryObject(String objectId, ObjectType objectType, Profile rendererProfile, AccessGroup userProfile, bool disablePresentationSettings)
    {
        return executeRetrieveItemAction(objectId, objectType, rendererProfile, userProfile, disablePresentationSettings);
    }

    public void validate()
    {
        if ((this.containerClass is null) && (this.itemClass is null)) {
            throw new ContentDirectoryDefinitionException("Container class or Item class must be provided in definition.");
        }
        if (ObjectValidator.isEmpty(this.commandClass)) {
            throw new ContentDirectoryDefinitionException("Action Command not provided.");
        }
        if (ObjectValidator.isEmpty(this.idPrefix)) {
            throw new ContentDirectoryDefinitionException("Action idPrefix not provided.");
        }
        if ((this.recursive) && (!this.childNodes.isEmpty())) {
            throw new ContentDirectoryDefinitionException("Recursive Actions cannot include any children nodes.");
        }
    }

    public BrowseItemsHolder!(DirectoryObject) retrieveContainerItems(String containerId, ObjectType objectType, SearchCriteria searchCriteria, int startIndex, int count, Profile rendererProfile, AccessGroup userProfile, bool disablePresentationSettings)
    {
        if (count == 0) {
            count = 2147483647;
        }
        if (this.recursive)
        {
            BrowseItemsHolder!(DirectoryObject) holder = executeListAction(containerId, objectType, searchCriteria, getCommandClass(), getContainerClass(), getItemClass(), rendererProfile, userProfile, getIdPrefix(), startIndex, count, disablePresentationSettings);

            return holder;
        }
        return super.retrieveContainerItems(containerId, objectType, searchCriteria, startIndex, count, rendererProfile, userProfile, disablePresentationSettings);
    }

    public int retrieveContainerItemsCount(String containerId, ObjectType objectType, SearchCriteria searchCriteria, AccessGroup userProfile, bool disablePresentationSettings)
    {
        if (this.recursive)
        {
            int count = executeCountAction(containerId, objectType, searchCriteria, getCommandClass(), userProfile, "", disablePresentationSettings);
            return count;
        }
        return super.retrieveContainerItemsCount(containerId, objectType, searchCriteria, userProfile, disablePresentationSettings);
    }

    protected /*!(T : DirectoryObject)*/ T executeRetrieveItemAction(T)(String containerId, ObjectType objectType, Profile rendererProfile, AccessGroup userProfile, bool disablePresentationSettings)
    {
        ObjectClassType containerClassType = this.containerClass;
        if (rendererProfile.getContentDirectoryDefinitionFilter() !is null) {
            containerClassType = rendererProfile.getContentDirectoryDefinitionFilter().filterContainerClassType(containerClassType, containerId);
        }
        Command!(T) command = instantiateCommand(containerId, objectType, null, this.commandClass, containerClassType, this.itemClass, rendererProfile, userProfile, this.idPrefix, 0, 1, disablePresentationSettings);
        try
        {
            return command.retrieveItem();
        }
        catch (CommandExecutionException e)
        {
            log.error(String.format("Cannot retrieve results of action command: %s", cast(Object[])[ e.getMessage() ]), e);
        }
        return null;
    }

    public String getCommandClass()
    {
        return this.commandClass;
    }

    public String getIdPrefix()
    {
        return this.idPrefix;
    }

    public bool isRecursive()
    {
        return this.recursive;
    }

    public List!(SearchIndexer.SearchCategory) getSearchCategories()
    {
        return this.searchCategories;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.ActionNode
* JD-Core Version:    0.7.0.1
*/