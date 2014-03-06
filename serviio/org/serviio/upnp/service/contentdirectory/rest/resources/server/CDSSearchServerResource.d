module org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSSearchServerResource;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.restlet.data.Status;
import org.restlet.resource.ResourceException;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.search.SearchManager;
import org.serviio.library.search.SearchResult;
import org.serviio.library.search.SearchResultsHolder;
import org.serviio.library.search.Searcher;
import org.serviio.restlet.HttpCodeException;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.rest.representation.AbstractCDSObjectRepresentation:DirectoryObjectType;
import org.serviio.upnp.service.contentdirectory.rest.representation.CategorySearchResultsRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultsRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.resources.CDSSearchResource;
import org.serviio.util.HttpUtils;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public class CDSSearchServerResource : AbstractRestrictedCDSServerResource, CDSSearchResource
{
    private int startIndex;
    private int count;
    private MediaFileType fileType;
    private String term;
    private String profileId;

    public SearchResultsRepresentation search()
    {
        try
        {
            List!(CategorySearchResultsRepresentation) categoryResults = new ArrayList();
            List!(SearchResultsHolder) results = SearchManager.getInstance().searcher().search(this.term, this.fileType, this.startIndex, this.count);
            foreach (SearchResultsHolder holder ; results)
            {
                List!(SearchResultRepresentation) items = new ArrayList();
                foreach (SearchResult sr ; holder.getItems())
                {
                    DirectoryObjectType objectType = sr.getObjectType() == ObjectType.ITEMS ? DirectoryObjectType.ITEM : DirectoryObjectType.CONTAINER;
                    SearchResultRepresentation rr = new SearchResultRepresentation(objectType, sr.getTitle(), sr.getCdsObjectId());
                    rr.setParentId(sr.getCdsParentId());
                    rr.setFileType(sr.getFileType());
                    rr.setThumbnailUrl(getResourceUrl(sr.getThumbnail(), this.profileId));
                    rr.setContext(sr.getContext());
                    items.add(rr);
                }
                CategorySearchResultsRepresentation srr = new CategorySearchResultsRepresentation();
                srr.setCategory(holder.getCategory());
                srr.setReturnedSize(Integer.valueOf(holder.getReturnedSize()));
                srr.setTotalMatched(Integer.valueOf(holder.getTotalMatched()));
                srr.setObjects(items);

                categoryResults.add(srr);
            }
            SearchResultsRepresentation result = new SearchResultsRepresentation();
            result.setCategoryResults(categoryResults);
            result.setTerm(this.term);
            return result;
        }
        catch (Exception e)
        {
            this.log.warn(String.format("Search for term '%s' failed with exception: %s", cast(Object[])[ this.term, e.getMessage() ]), e);
            throw new RuntimeException(e);
        }
    }

    protected void doInit()
    {
        super.doInit();
        this.term = HttpUtils.urlDecode(cast(String)getRequestAttributes().get("term"));
        this.profileId = (cast(String)getRequestAttributes().get("profile"));
        this.startIndex = Integer.parseInt(cast(String)getRequestAttributes().get("start"));
        this.count = Integer.parseInt(cast(String)getRequestAttributes().get("count"));
        this.fileType = getFileType(cast(String)getRequestAttributes().get("fileType"));
        if (this.count == 0) {
            this.count = 100;
        }
    }

    private MediaFileType getFileType(String identifier)
    {
        String id = StringUtils.localeSafeToLowercase(identifier.trim());
        if (id.equals("i")) {
            return MediaFileType.IMAGE;
        }
        if (id.equals("v")) {
            return MediaFileType.VIDEO;
        }
        if (id.equals("a")) {
            return MediaFileType.AUDIO;
        }
        throw new HttpCodeException(Status.CLIENT_ERROR_BAD_REQUEST.getCode(), "Invalid file type: " + identifier);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSSearchServerResource
* JD-Core Version:    0.7.0.1
*/