module org.serviio.library.local.metadata.extractor.video.SearchSourceFactory;

import org.serviio.library.local.metadata.extractor.video.SearchSourceAdaptor;
import org.serviio.library.local.metadata.extractor.video.VideoDescription;

public class SearchSourceFactory
{
    public static SearchSourceAdaptor getSearchSourceAdaptor(VideoType videoType)
    {
        if (videoType == VideoType.EPISODE) {
            return new TheTVDBSourceAdaptor();
        }
        if (videoType == VideoType.FILM) {
            return new TheMovieDBSourceAdaptor();
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.video.SearchSourceFactory
* JD-Core Version:    0.7.0.1
*/