module org.serviio.library.local.metadata.extractor.video.VideoDescription;

import java.lang;
import java.util.Arrays;

public class VideoDescription
{
    private VideoType type;
    private bool searchRecommended;
    private String[] names;
    private Integer season;
    private Integer episode;
    private Integer year;

    public static enum VideoType
    {
        FILM,  EPISODE,  SPECIAL
    }

    public this(VideoType type, bool searchRecommended, String[] filmNames, Integer year)
    {
        this.type = type;
        this.searchRecommended = searchRecommended;
        this.names = filmNames;
        this.year = year;
    }

    public this(VideoType type, bool searchRecommended, String[] seriesNames, Integer season, Integer episode, Integer year)
    {
        this.type = type;
        this.searchRecommended = searchRecommended;
        this.names = seriesNames;
        this.season = season;
        this.episode = episode;
        this.year = year;
    }

    public this(VideoType type, bool searchRecommended)
    {
        this.type = type;
        this.searchRecommended = searchRecommended;
    }

    public VideoType getType()
    {
        return this.type;
    }

    public bool isSearchRecommended()
    {
        return this.searchRecommended;
    }

    public String[] getNames()
    {
        return this.names;
    }

    public Integer getSeason()
    {
        return this.season;
    }

    public Integer getEpisode()
    {
        return this.episode;
    }

    public Integer getYear()
    {
        return this.year;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("VideoDescription [type=").append(this.type).append(", names=").append(Arrays.toString(this.names)).append(", year=").append(this.year).append(", season=").append(this.season).append(", episode=").append(this.episode).append("]");

        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.video.VideoDescription
* JD-Core Version:    0.7.0.1
*/