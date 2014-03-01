module org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;

import java.lang;
import java.util.ArrayList;
import java.util.List;
import org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;
import org.serviio.upnp.service.contentdirectory.classes.Resource;

public abstract class DirectoryObject
{
    protected String id;
    protected Long entityId;
    protected String parentID;
    protected String title;
    protected String creator;
    protected List!(Resource) resources = new ArrayList();
    protected bool restricted = true;
    protected String writeStatus = "NOT_WRITABLE";
    protected Resource icon;
    protected Resource albumArtURIResource;

    public this(String id, String title)
    {
        this.id = id;
        this.title = title;
    }

    public abstract ObjectClassType getObjectClass();

    public String getParentID()
    {
        return this.parentID;
    }

    public void setParentID(String parentID)
    {
        this.parentID = parentID;
    }

    public String getTitle()
    {
        return this.title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getCreator()
    {
        return this.creator;
    }

    public void setCreator(String creator)
    {
        this.creator = creator;
    }

    public List!(Resource) getResources()
    {
        return this.resources;
    }

    public void setResources(List!(Resource) res)
    {
        this.resources = res;
    }

    public String getId()
    {
        return this.id;
    }

    public bool isRestricted()
    {
        return this.restricted;
    }

    public String getWriteStatus()
    {
        return this.writeStatus;
    }

    public Long getEntityId()
    {
        return this.entityId;
    }

    public void setEntityId(Long entityId)
    {
        this.entityId = entityId;
    }

    public Resource getIcon()
    {
        return this.icon;
    }

    public void setIcon(Resource icon)
    {
        this.icon = icon;
    }

    public Resource getAlbumArtURIResource()
    {
        return this.albumArtURIResource;
    }

    public void setAlbumArtURIResource(Resource albumArtURI)
    {
        this.albumArtURIResource = albumArtURI;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("DirectoryObject [creator=").append(this.creator).append(", id=").append(this.id).append(", parentID=").append(this.parentID).append(", resources=").append(this.resources).append(", restricted=").append(this.restricted).append(", title=").append(this.title).append(", writeStatus=").append(this.writeStatus).append("]");

        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.DirectoryObject
* JD-Core Version:    0.7.0.1
*/