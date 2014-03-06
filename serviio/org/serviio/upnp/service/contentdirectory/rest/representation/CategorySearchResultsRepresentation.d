module org.serviio.upnp.service.contentdirectory.rest.representation.CategorySearchResultsRepresentation;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import org.serviio.library.search.SearchIndexer:SearchCategory;
import org.serviio.upnp.service.contentdirectory.rest.representation.ContentDirectoryRepresentation;

public class CategorySearchResultsRepresentation : ContentDirectoryRepresentation!(SearchResultRepresentation)
{
    @XStreamAsAttribute private SearchCategory category;

    public SearchCategory getCategory()
    {
        return this.category;
    }

    public void setCategory(SearchCategory category)
    {
        this.category = category;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.CategorySearchResultsRepresentation
* JD-Core Version:    0.7.0.1
*/