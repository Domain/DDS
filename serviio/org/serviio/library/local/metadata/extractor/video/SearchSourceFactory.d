module org.serviio.library.local.metadata.extractor.video.SearchSourceFactory;

public class SearchSourceFactory
{
  public static SearchSourceAdaptor getSearchSourceAdaptor(VideoDescription.VideoType videoType)
  {
    if (videoType == VideoDescription.VideoType.EPISODE) {
      return new TheTVDBSourceAdaptor();
    }
    if (videoType == VideoDescription.VideoType.FILM) {
      return new TheMovieDBSourceAdaptor();
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.video.SearchSourceFactory
 * JD-Core Version:    0.7.0.1
 */