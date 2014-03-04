module org.serviio.library.search.SearchResult;

import java.lang;
import org.apache.lucene.document.Document;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.command.ResourceValuesBuilder;
import org.serviio.util.ObjectValidator;

public class SearchResult
{
    private String title;
    private Long entityId;
    private String cdsObjectId;
    private String cdsParentId;
    private MediaFileType fileType;
    private ObjectType objectType;
    private Resource thumbnail;
    private String context;
    private Long onlineRepositoryId;

    public static SearchResult fromDoc(Document doc)
    {
        SearchResult sr = new SearchResult();
        sr.setEntityId(new Long(doc.get("entityId")));
        sr.setCdsObjectId(doc.get("cdsObjectId"));
        sr.setCdsParentId(doc.get("cdsParentId"));
        sr.setTitle(doc.get("value"));
        sr.setContext(doc.get("context"));
        sr.setFileType(MediaFileType.valueOf(doc.get("fileType")));
        sr.setObjectType(ObjectType.valueOf(doc.get("objectType")));

        String thumbnailId = doc.get("thumbnailId");
        if (ObjectValidator.isNotEmpty(thumbnailId)) {
            sr.setThumbnail(ResourceValuesBuilder.generateThumbnailResource(new Long(thumbnailId)));
        }
        String onlineRepositoryId = doc.get("onlineRepoId");
        if (ObjectValidator.isNotEmpty(onlineRepositoryId)) {
            sr.setOnlineRepositoryId(new Long(onlineRepositoryId));
        }
        return sr;
    }

    public String getTitle()
    {
        return this.title;
    }

    private void setTitle(String title)
    {
        this.title = title;
    }

    public Long getEntityId()
    {
        return this.entityId;
    }

    private void setEntityId(Long entityId)
    {
        this.entityId = entityId;
    }

    public String getCdsObjectId()
    {
        return this.cdsObjectId;
    }

    private void setCdsObjectId(String cdsObjectId)
    {
        this.cdsObjectId = cdsObjectId;
    }

    public String getCdsParentId()
    {
        return this.cdsParentId;
    }

    private void setCdsParentId(String cdsParentId)
    {
        this.cdsParentId = cdsParentId;
    }

    public MediaFileType getFileType()
    {
        return this.fileType;
    }

    private void setFileType(MediaFileType fileType)
    {
        this.fileType = fileType;
    }

    public ObjectType getObjectType()
    {
        return this.objectType;
    }

    private void setObjectType(ObjectType objectType)
    {
        this.objectType = objectType;
    }

    public Resource getThumbnail()
    {
        return this.thumbnail;
    }

    private void setThumbnail(Resource thumbnail)
    {
        this.thumbnail = thumbnail;
    }

    public String getContext()
    {
        return this.context;
    }

    private void setContext(String context)
    {
        this.context = context;
    }

    public Long getOnlineRepositoryId()
    {
        return this.onlineRepositoryId;
    }

    private void setOnlineRepositoryId(Long onlineRepositoryId)
    {
        this.onlineRepositoryId = onlineRepositoryId;
    }

    public override hash_t toHash()
    {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.cdsObjectId is null ? 0 : this.cdsObjectId.hashCode());
        return result;
    }

    public override equals_t opEquals(Object obj)
    {
        if (this == obj) {
            return true;
        }
        if (obj is null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        SearchResult other = cast(SearchResult)obj;
        if (this.cdsObjectId is null)
        {
            if (other.cdsObjectId !is null) {
                return false;
            }
        }
        else if (!this.cdsObjectId.equals(other.cdsObjectId)) {
            return false;
        }
        return true;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.SearchResult
* JD-Core Version:    0.7.0.1
*/