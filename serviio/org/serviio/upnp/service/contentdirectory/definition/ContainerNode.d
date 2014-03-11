module org.serviio.upnp.service.contentdirectory.definition.ContainerNode;

import java.lang;
import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.List;
import org.serviio.library.entities.AccessGroup;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.BrowseItemsHolder;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.command.Command;
import org.serviio.upnp.service.contentdirectory.command.CommandExecutionException;
import org.serviio.upnp.service.contentdirectory.definition.DefinitionNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class ContainerNode : DefinitionNode
{
    private static Logger log = LoggerFactory.getLogger!(ContainerNode);
    protected List!(DefinitionNode) childNodes = new ArrayList!DefinitionNode();

    public this(ObjectClassType objectClass, DefinitionNode parent, String cacheRegion)
    {
        super(objectClass, parent, cacheRegion);
    }

    public BrowseItemsHolder!(DirectoryObject) retrieveContainerItems(String containerId, ObjectType objectType, SearchCriteria searchCriteria, int startIndex, int count, Profile rendererProfile, AccessGroup userProfile, bool disablePresentationSettings)
    {
        BrowseItemsHolder!(DirectoryObject) resultHolder = new BrowseItemsHolder();
        new ArrayList();
        int[] totalFound = new int[1];
        int[] returned = new int[1];
        if (count == 0) {
            count = 2147483647;
        }
        List!(DirectoryObject) items = findContainerItems(containerId, objectType, searchCriteria, Integer.valueOf(startIndex), Integer.valueOf(count), returned, totalFound, rendererProfile, userProfile, disablePresentationSettings);
        resultHolder.setItems(items.size() < count ? items : items.subList(0, count));
        resultHolder.setTotalMatched(totalFound[0]);
        return resultHolder;
    }

    public int retrieveContainerItemsCount(String containerId, ObjectType objectType, SearchCriteria searchCriteria, AccessGroup userProfile, bool disablePresentationSettings)
    {
        int totalFound = 0;
        Definition def = Definition.instance();
        foreach (DefinitionNode childNode ; this.childNodes) {
            if (( cast(StaticDefinitionNode)childNode !is null ))
            {
                String childNodeId = (cast(StaticDefinitionNode)childNode).getId();
                if ((!def.isDisabledContainer(childNodeId, disablePresentationSettings)) && (objectType.supportsContainers())) {
                    if (def.isOnlyShowContentsOfContainer(childNodeId, disablePresentationSettings))
                    {
                        if (( cast(StaticContainerNode)childNode !is null ))
                        {
                            StaticContainerNode disabledContainerNode = cast(StaticContainerNode)childNode;

                            totalFound += disabledContainerNode.retrieveContainerItemsCount(disabledContainerNode.getId(), objectType, searchCriteria, userProfile, disablePresentationSettings);
                        }
                    }
                    else {
                        totalFound++;
                    }
                }
            }
            else
            {
                int count = executeCountAction(containerId, objectType, searchCriteria, (cast(ActionNode)childNode).getCommandClass(), userProfile, (cast(ActionNode)childNode).getIdPrefix(), disablePresentationSettings);
                totalFound += count;
            }
        }
        return totalFound;
    }

    override public void validate()
    {
        super.validate();
        if (this.containerClass is null) {
            throw new ContentDirectoryDefinitionException("Container class not provided in definition.");
        }
    }

    protected List!(DirectoryObject) findContainerItems(String containerId, ObjectType objectType, SearchCriteria searchCriteria, Integer startIndex, Integer requestedCount, int[] returned, int[] totalFound, Profile rendererProfile, AccessGroup userProfile, bool disablePresentationSettings)
    {
        List!(DirectoryObject) items = new ArrayList();
        Definition def = Definition.instance();
        foreach (DefinitionNode node ; this.childNodes) {
            if (( cast(StaticContainerNode)node !is null ))
            {
                StaticContainerNode staticContainer = cast(StaticContainerNode)node;
                if ((staticContainer.isBrowsable()) && 
                    (!def.isDisabledContainer(staticContainer.getId(), disablePresentationSettings)) && (objectType.supportsContainers())) {
                        if (returned[0] < requestedCount.intValue())
                        {
                            if (def.isEnabledContainer(staticContainer.getId(), disablePresentationSettings))
                            {
                                if (startIndex.intValue() <= totalFound[0])
                                {
                                    items.add(staticContainer.retrieveDirectoryObject(staticContainer.getId(), objectType, rendererProfile, userProfile, disablePresentationSettings));
                                    returned[0] += 1;
                                }
                                totalFound[0] += 1;
                            }
                            else
                            {
                                items.addAll(staticContainer.findContainerItems(staticContainer.getId(), objectType, searchCriteria, startIndex, requestedCount, returned, totalFound, rendererProfile, userProfile, disablePresentationSettings));
                            }
                        }
                        else if (def.isEnabledContainer(staticContainer.getId(), disablePresentationSettings)) {
                            totalFound[0] += 1;
                        } else {
                            totalFound[0] += staticContainer.retrieveContainerItemsCount(staticContainer.getId(), objectType, searchCriteria, userProfile, disablePresentationSettings);
                        }
                    }
            }
            else
            {
                int from = startIndex.intValue() <= returned[0] ? 0 : startIndex.intValue() - totalFound[0];
                BrowseItemsHolder!(DirectoryObject) holder = executeListAction(containerId, objectType, searchCriteria, (cast(ActionNode)node).getCommandClass(), node.getContainerClass(), node.getItemClass(), rendererProfile, userProfile, (cast(ActionNode)node).getIdPrefix(), from, requestedCount.intValue() - returned[0], disablePresentationSettings);
                if (holder !is null)
                {
                    totalFound[0] += holder.getTotalMatched();
                    returned[0] += holder.getReturnedSize();
                    items.addAll(holder.getItems());
                }
            }
        }
        return items;
    }

    protected /*!(T : DirectoryObject)*/ Command!(T) instantiateCommand(T)(String containerId, ObjectType objectType, SearchCriteria searchCriteria, String commandClass, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup userProfile, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        try
        {
            Class!(T) clazz = Class.forName(commandClass);
            if (Command.class_.isAssignableFrom(clazz))
            {
                Constructor!(T) c = clazz.getConstructor(cast(Class[])[ String.class_, ObjectType.class_, SearchCriteria.class_, ObjectClassType.class_, ObjectClassType.class_, Profile.class_, AccessGroup.class_, String.class_, Integer.TYPE, Integer.TYPE, Boolean.TYPE ]);
                return cast(Command)c.newInstance(cast(Object[])[ containerId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, userProfile, idPrefix, Integer.valueOf(startIndex), Integer.valueOf(count), Boolean.valueOf(disablePresentationSettings) ]);
            }
            log.error(String.format("Cannot instantiate Command %s because it doesn't implement Command interface", cast(Object[])[ commandClass ]));
        }
        catch (Exception e)
        {
            log.error(String.format("Cannot instantiate Command %s: %s", cast(Object[])[ commandClass, e.getMessage() ]));
        }
        return null;
    }

    protected /*!(T : DirectoryObject)*/ int executeCountAction(T)(String containerId, ObjectType objectType, SearchCriteria searchCriteria, String commandClass, AccessGroup userProfile, String idPrefix, bool disablePresentationSettings)
    {
        Command!(T) command = instantiateCommand(containerId, objectType, searchCriteria, commandClass, null, null, null, userProfile, idPrefix, 0, 0, disablePresentationSettings);
        try
        {
            return command.retrieveItemCount();
        }
        catch (CommandExecutionException e)
        {
            log.error(String.format("Cannot retrieve results of action count command: %s", cast(Object[])[ e.getMessage() ]), e);
        }
        return 0;
    }

    protected /*!(T : DirectoryObject)*/ BrowseItemsHolder!(T) executeListAction(T)(String containerId, ObjectType objectType, SearchCriteria searchCriteria, String commandClass, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup userProfile, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        ObjectClassType filteredContainerClassType = containerClassType;
        if (rendererProfile.getContentDirectoryDefinitionFilter() !is null) {
            filteredContainerClassType = rendererProfile.getContentDirectoryDefinitionFilter().filterContainerClassType(containerClassType, containerId);
        }
        Command!(T) command = instantiateCommand(containerId, objectType, searchCriteria, commandClass, filteredContainerClassType, itemClassType, rendererProfile, userProfile, idPrefix, startIndex, count, disablePresentationSettings);
        try
        {
            return command.retrieveItemList();
        }
        catch (CommandExecutionException e)
        {
            log.error(String.format("Cannot retrieve results of action command: %s", cast(Object[])[ e.getMessage() ]), e);
            throw new RuntimeException(e);
        }
    }

    public List!(DefinitionNode) getChildNodes()
    {
        return this.childNodes;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.ContainerNode
* JD-Core Version:    0.7.0.1
*/