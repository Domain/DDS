module org.serviio.upnp.service.contentdirectory.rest.representation.CategorySearchResultsRepresentation;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import org.serviio.library.search.SearchIndexer.SearchCategory;

public class CategorySearchResultsRepresentation
  : ContentDirectoryRepresentation!(SearchResultRepresentation)
{
  @XStreamAsAttribute
  private SearchIndexer.SearchCategory category;
  
  public SearchIndexer.SearchCategory getCategory()
  {
    return this.category;
  }
  
  public void setCategory(SearchIndexer.SearchCategory category)
  {
    this.category = category;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.CategorySearchResultsRepresentation
 * JD-Core Version:    0.7.0.1
 */