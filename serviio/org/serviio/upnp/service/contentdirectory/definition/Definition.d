module org.serviio.upnp.service.contentdirectory.definition.Definition;

import java.lang.String;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.serviio.config.Configuration;
import org.serviio.library.search.SearchIndexer:SearchCategory;
import org.serviio.util.CollectionUtils;
import org.serviio.upnp.service.contentdirectory.definition.ContainerNode;
import org.serviio.upnp.service.contentdirectory.definition.ContainerVisibilityType;
import org.serviio.upnp.service.contentdirectory.definition.ActionNode;

public class Definition
{
    public static immutable String ROOT_NODE_ID = "0";
    public static immutable String ROOT_NODE_PARENT_ID = "-1";
    public static immutable String NODE_ID_VIDEO = "V";
    public static immutable String NODE_ID_IMAGE = "I";
    public static immutable String NODE_ID_AUDIO = "A";
    public static immutable String SEGMENT_SEPARATOR = "^";
    private static immutable String SEGMENT_SEPARATOR_REGEX = "\\^";
    private static Definition _instance;
    private ContainerNode rootNode;

    public this(ContainerNode rootNode)
    {
        this.rootNode = rootNode;
    }

    public static Definition instance()
    {
        if (_instance is null)
        {
            InputStream definitionStream = Definition.class_.getResourceAsStream("contentDirectoryDef.xml");
            try
            {
                _instance = ContentDirectoryDefinitionParser.parseDefinition(definitionStream);
            }
            catch (ContentDirectoryDefinitionException e)
            {
                throw new RuntimeException(String.format("Cannot initialize ContentDirectory service: %s", cast(Object[])[ e.getMessage() ]), e);
            }
        }
        return _instance;
    }

    public static void setInstance(Definition instance)
    {
        instance = instance;
    }

    public static void reload()
    {
        setInstance(null);
    }

    public ContainerNode getContainer(String nodeId)
    {
        String[] idSegments = nodeId.split("\\^");
        ContainerNode staticNode = findStaticContainer(idSegments[0], this.rootNode);
        if (idSegments.length == 1) {
            return staticNode;
        }
        if (idSegments.length > 1)
        {
            ContainerNode contextNode = staticNode;
            for (int i = 1; (i < idSegments.length) && (contextNode !is null); i++)
            {
                if ((contextNode !is null) && (( cast(ActionNode)contextNode !is null )) && ((cast(ActionNode)contextNode).isRecursive())) {
                    break;
                }
                contextNode = findActionContainer(idSegments[i], contextNode);
            }
            return contextNode;
        }
        return null;
    }

    public String getParentNodeId(String objectId, bool disablePresentationSettings)
    {
        String[] idSegments = objectId.split("\\^");
        if (idSegments.length == 1)
        {
            ContainerNode staticNode = findStaticContainer(idSegments[0], this.rootNode);
            if ((staticNode is null) || (staticNode.getParent() is null)) {
                return "-1";
            }
            StaticContainerNode parent = cast(StaticContainerNode)staticNode.getParent();
            if (isEnabledContainer(parent.getId(), disablePresentationSettings)) {
                return parent.getId();
            }
            return getParentNodeId(parent.getId(), disablePresentationSettings);
        }
        String parentId = objectId.substring(0, objectId.indexOf(idSegments[(idSegments.length - 1)]) - 1);
        if (!parentId.contains("^"))
        {
            if (isEnabledContainer(parentId, disablePresentationSettings)) {
                return parentId;
            }
            return getParentNodeId(parentId, disablePresentationSettings);
        }
        return parentId;
    }

    public bool isEnabledContainer(String objectId, bool disablePresentationSettings)
    {
        return getContainerVisibility(objectId, disablePresentationSettings) == ContainerVisibilityType.DISPLAYED;
    }

    public bool isOnlyShowContentsOfContainer(String objectId, bool disablePresentationSettings)
    {
        return getContainerVisibility(objectId, disablePresentationSettings) == ContainerVisibilityType.CONTENT_DISPLAYED;
    }

    public bool isDisabledContainer(String objectId, bool disablePresentationSettings)
    {
        return getContainerVisibility(objectId, disablePresentationSettings) == ContainerVisibilityType.DISABLED;
    }

    public ContainerVisibilityType getContainerVisibility(String objectId, bool disablePresentationSettings)
    {
        if (disablePresentationSettings) {
            return ContainerVisibilityType.DISPLAYED;
        }
        Map!(String, String) itemDef = Configuration.getBrowseMenuItemOptions();
        if (!itemDef.containsKey(objectId)) {
            return ContainerVisibilityType.DISPLAYED;
        }
        return ContainerVisibilityType.valueOf(cast(String)itemDef.get(objectId));
    }

    public String getContentOnlyParentTitles(String objectId, bool disablePresentationSettings)
    {
        if (Configuration.isBrowseMenuShowNameOfParentCategory())
        {
            if (objectId.contains("$")) {
                return null;
            }
            List!(String) parentTitles = new ArrayList();
            Definition def = instance();
            DefinitionNode object = getContainer(objectId);
            if (object !is null)
            {
                DefinitionNode parentNode = object.getParent();
                while ((parentNode !is null) && (( cast(StaticContainerNode)parentNode !is null )) && (def.isOnlyShowContentsOfContainer((cast(StaticContainerNode)parentNode).getId(), disablePresentationSettings)))
                {
                    parentTitles.add((cast(StaticContainerNode)parentNode).getTitle());
                    parentNode = parentNode.getParent();
                }
                if (parentTitles.size() > 0)
                {
                    Collections.reverse(parentTitles);
                    String parentsTitle = String.format("[%s]", cast(Object[])[ CollectionUtils.listToCSV(parentTitles, "/", true) ]);
                    return parentsTitle;
                }
            }
        }
        return null;
    }

    public List!(ActionNode) findNodesForSearchCategory(SearchCategory category)
    {
        List!(ActionNode) actionNodes = collectCommandsForSearchCategory(this.rootNode, category);
        return actionNodes;
    }

    private ContainerNode findStaticContainer(String nodeId, ContainerNode node)
    {
        if (( cast(StaticContainerNode)node !is null ))
        {
            if ((cast(StaticDefinitionNode)node).getId().equals(nodeId)) {
                return node;
            }
            foreach (DefinitionNode childNode ; node.getChildNodes()) {
                if (( cast(ContainerNode)childNode !is null ))
                {
                    ContainerNode foundNode = findStaticContainer(nodeId, cast(ContainerNode)childNode);
                    if (foundNode !is null) {
                        return foundNode;
                    }
                }
            }
        }
        return null;
    }

    private ActionNode findActionContainer(String nodeIdElement, ContainerNode node)
    {
        foreach (DefinitionNode childNode ; node.getChildNodes()) {
            if (( cast(ActionNode)childNode !is null ))
            {
                ActionNode actionNode = cast(ActionNode)childNode;
                if (nodeIdElement.startsWith(actionNode.getIdPrefix())) {
                    return actionNode;
                }
            }
        }
        return null;
    }

    private List!(ActionNode) collectCommandsForSearchCategory(ContainerNode root, SearchCategory category)
    {
        List!(ActionNode) results = new ArrayList();
        foreach (DefinitionNode node ; root.getChildNodes())
        {
            if (( cast(ActionNode)node !is null ))
            {
                ActionNode an = cast(ActionNode)node;
                if ((an.getSearchCategories() !is null) && (an.getSearchCategories().contains(category))) {
                    results.add(an);
                }
            }
            if (( cast(ContainerNode)node !is null )) {
                results.addAll(collectCommandsForSearchCategory(cast(ContainerNode)node, category));
            }
        }
        return results;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.Definition
* JD-Core Version:    0.7.0.1
*/