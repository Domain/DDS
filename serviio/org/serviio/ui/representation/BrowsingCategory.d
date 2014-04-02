module org.serviio.ui.representation.BrowsingCategory;

import java.lang;
import java.util.ArrayList;
import java.util.List;
import org.serviio.upnp.service.contentdirectory.definition.ContainerVisibilityType;

public class BrowsingCategory
{
    private String id;
    private String title;
    private ContainerVisibilityType visibility;
    private List!(BrowsingCategory) subCategories = new ArrayList!(BrowsingCategory)();

    public this() {}

    public this(String id, String title, ContainerVisibilityType visibility)
    {
        this.id = id;
        this.title = title;
        this.visibility = visibility;
    }

    public List!(BrowsingCategory) getSubCategories()
    {
        return this.subCategories;
    }

    public void setSubCategories(List!(BrowsingCategory) subCategories)
    {
        this.subCategories = subCategories;
    }

    public String getTitle()
    {
        return this.title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public ContainerVisibilityType getVisibility()
    {
        return this.visibility;
    }

    public void setVisibility(ContainerVisibilityType visibility)
    {
        this.visibility = visibility;
    }

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.BrowsingCategory
* JD-Core Version:    0.7.0.1
*/