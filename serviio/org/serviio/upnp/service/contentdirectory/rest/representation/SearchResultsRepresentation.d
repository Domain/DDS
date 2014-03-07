module org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultsRepresentation;

import java.lang.String;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import java.util.List;
import org.serviio.upnp.service.contentdirectory.rest.representation.CategorySearchResultsRepresentation;

public class SearchResultsRepresentation
{
    @XStreamAsAttribute
    private String term;
    private List!(CategorySearchResultsRepresentation) categoryResults;

    public List!(CategorySearchResultsRepresentation) getCategoryResults()
    {
        return this.categoryResults;
    }

    public void setCategoryResults(List!(CategorySearchResultsRepresentation) categoryResults)
    {
        this.categoryResults = categoryResults;
    }

    public String getTerm()
    {
        return this.term;
    }

    public void setTerm(String term)
    {
        this.term = term;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultsRepresentation
* JD-Core Version:    0.7.0.1
*/