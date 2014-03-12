module org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand;

import java.lang;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.db.entities.PersistedEntity;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.Profile;
import org.serviio.upnp.service.contentdirectory.ObjectNotFoundException;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.SearchCriteria;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.upnp.service.contentdirectory.classes.Container;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObjectBuilder;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.upnp.service.contentdirectory.command.AbstractCommand;

public abstract class AbstractEntityContainerCommand(E : PersistedEntity) : AbstractCommand!(Container)
{
    public this(String objectId, ObjectType objectType, SearchCriteria searchCriteria, ObjectClassType containerClassType, ObjectClassType itemClassType, Profile rendererProfile, AccessGroup accessGroup, MediaFileType fileType, String idPrefix, int startIndex, int count, bool disablePresentationSettings)
    {
        super(objectId, objectType, searchCriteria, containerClassType, itemClassType, rendererProfile, accessGroup, fileType, idPrefix, startIndex, count, disablePresentationSettings);
    }

    override protected List!(Container) retrieveList()
    {
        List!(Container) items = new ArrayList();

        List!(E) entities = retrieveEntityList();
        foreach (E entity ; entities)
        {
            String runtimeId = generateRuntimeObjectId(entity.getId());
            Map!(ClassProperties, Object) values = generateValuesForEntity(entity, runtimeId, getDisplayedContainerId(this.objectId), getContainerTitle(entity));
            items.add(cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, getContainerResources(values, entity.getId(), this.rendererProfile), entity.getId(), this.disablePresentationSettings));
        }
        return items;
    }

    public int retrieveItemCount()
    {
        return 0;
    }

    override protected Set!(ObjectType) getSupportedObjectTypes()
    {
        return ObjectType.getContainerTypes();
    }

    override protected Container retrieveSingleItem()
    {
        E entity = retrieveSingleEntity(new Long(getInternalObjectId()));
        if (entity !is null)
        {
            Map!(ClassProperties, Object) values = generateValuesForEntity(entity, this.objectId, Definition.instance().getParentNodeId(this.objectId, this.disablePresentationSettings), getContainerTitle(entity));
            return cast(Container)DirectoryObjectBuilder.createInstance(this.containerClassType, values, getContainerResources(values, entity.getId(), this.rendererProfile), entity.getId(), this.disablePresentationSettings);
        }
        throw new ObjectNotFoundException(String.format("Object with id %s not found in CDS", cast(Object[])[ this.objectId ]));
    }

    protected abstract List!(E) retrieveEntityList();

    protected abstract E retrieveSingleEntity(Long paramLong);

    protected abstract String getContainerTitle(E paramE);

    protected Map!(ClassProperties, Object) generateValuesForEntity(E entity, String objectId, String parentId, String title)
    {
        return ObjectValuesBuilder.buildObjectValues(entity, objectId, parentId, this.objectType, this.searchCriteria, title, this.rendererProfile, this.accessGroup, this.fileType, this.disablePresentationSettings);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.command.AbstractEntityContainerCommand
* JD-Core Version:    0.7.0.1
*/