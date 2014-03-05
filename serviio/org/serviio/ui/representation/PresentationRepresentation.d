module org.serviio.ui.representation.PresentationRepresentation;

import java.lang;
import java.util.ArrayList;
import java.util.List;
import org.serviio.ui.representation.BrowsingCategory;

public class PresentationRepresentation
{
    private List!(BrowsingCategory) categories = new ArrayList();
    private String language;
    private bool showParentCategoryTitle;
    private Integer numberOfFilesForDynamicCategories;
    private bool filterOutSeries;

    public List!(BrowsingCategory) getCategories()
    {
        return this.categories;
    }

    public void setCategories(List!(BrowsingCategory) categories)
    {
        this.categories = categories;
    }

    public String getLanguage()
    {
        return this.language;
    }

    public void setLanguage(String language)
    {
        this.language = language;
    }

    public bool isShowParentCategoryTitle()
    {
        return this.showParentCategoryTitle;
    }

    public void setShowParentCategoryTitle(bool showParentCategoryTitle)
    {
        this.showParentCategoryTitle = showParentCategoryTitle;
    }

    public Integer getNumberOfFilesForDynamicCategories()
    {
        return this.numberOfFilesForDynamicCategories;
    }

    public void setNumberOfFilesForDynamicCategories(Integer numberOfFilesForDynamicCategories)
    {
        this.numberOfFilesForDynamicCategories = numberOfFilesForDynamicCategories;
    }

    public bool isFilterOutSeries()
    {
        return this.filterOutSeries;
    }

    public void setFilterOutSeries(bool filterOutSeries)
    {
        this.filterOutSeries = filterOutSeries;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.PresentationRepresentation
* JD-Core Version:    0.7.0.1
*/