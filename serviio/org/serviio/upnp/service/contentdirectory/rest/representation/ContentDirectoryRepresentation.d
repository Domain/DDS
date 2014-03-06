module org.serviio.upnp.service.contentdirectory.rest.representation.ContentDirectoryRepresentation;

import java.lang.Integer;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import java.util.List;

public abstract class ContentDirectoryRepresentation(T)
{
    private List!(T) objects;
    @XStreamAsAttribute
    private Integer returnedSize;
    @XStreamAsAttribute
    private Integer totalMatched;

    public List!(T) getObjects()
    {
        return this.objects;
    }

    public void setObjects(List!(T) objects)
    {
        this.objects = objects;
    }

    public Integer getReturnedSize()
    {
        return this.returnedSize;
    }

    public void setReturnedSize(Integer returnedSize)
    {
        this.returnedSize = returnedSize;
    }

    public Integer getTotalMatched()
    {
        return this.totalMatched;
    }

    public void setTotalMatched(Integer totalMatched)
    {
        this.totalMatched = totalMatched;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.ContentDirectoryRepresentation
* JD-Core Version:    0.7.0.1
*/