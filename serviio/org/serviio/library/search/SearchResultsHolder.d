module org.serviio.library.search.SearchResultsHolder;

import java.util.ArrayList;
import java.util.List;

public class SearchResultsHolder
{
  private SearchIndexer.SearchCategory category;
  private List!(SearchResult) items = new ArrayList();
  private int totalMatched = 0;
  
  public List!(SearchResult) getItems()
  {
    return this.items;
  }
  
  public void setItems(List!(SearchResult) items)
  {
    this.items = items;
  }
  
  public int getTotalMatched()
  {
    return this.totalMatched;
  }
  
  public void setTotalMatched(int totalMatched)
  {
    this.totalMatched = totalMatched;
  }
  
  public int getReturnedSize()
  {
    return this.items.size();
  }
  
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
 * Qualified Name:     org.serviio.library.search.SearchResultsHolder
 * JD-Core Version:    0.7.0.1
 */