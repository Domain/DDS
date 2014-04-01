module org.serviio.util.ServiioUri;

import java.lang;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.metadata.MediaFileType;

public class ServiioUri
{
    public static immutable String SCHEMA = "serviio";
    private static Pattern linkPattern;
    private static immutable String PARAM_URL = "url";
    private static immutable String PARAM_THURL = "thUrl";
    private static immutable String PARAM_NAME = "name";
    private static immutable String REPO_TYPE_WEB = "web";
    private static immutable String REPO_TYPE_LIVE = "live";
    private static immutable String REPO_TYPE_FEED = "feed";
    private static immutable String FILE_TYPE_IMAGE = "image";
    private static immutable String FILE_TYPE_AUDIO = "audio";
    private static immutable String FILE_TYPE_VIDEO = "video";
    private String repositoryUrl;
    private MediaFileType _fileType;
    private OnlineRepositoryType repoType;
    private String thumbnailUrl;
    private String repositoryName;

    static this()
    {
        linkPattern = Pattern.compile("serviio://(\\w+):(\\w+)/?\\?(.+)", 2);
    }

    public this(MediaFileType _fileType, OnlineRepositoryType repoType, String repositoryUrl, String thumbnailUrl, String repositoryName)
    {
        this._fileType = _fileType;
        this.repoType = repoType;
        this.repositoryUrl = repositoryUrl;
        this.thumbnailUrl = thumbnailUrl;
        this.repositoryName = repositoryName;
    }

    public static ServiioUri get(String uri)
    {
        if (ObjectValidator.isNotEmpty(uri))
        {
            Matcher m = linkPattern.matcher(uri);
            if ((m.find()) && (m.groupCount() == 3))
            {
                MediaFileType _fileType = _fileType(m.group(1));
                OnlineRepositoryType repoType = repositoryType(m.group(2));
                String query = m.group(3);
                if (ObjectValidator.isEmpty(query)) {
                    throw new IllegalArgumentException("Serviio URI path is missing: " + uri);
                }
                Map!(String, String) queryMap = HttpUtils.splitQuery(query);
                if (!queryMap.containsKey("url")) {
                    throw new IllegalArgumentException("Serviio URI is invalid, missing url parameter: " + uri);
                }
                return new ServiioUri(_fileType, repoType, cast(String)queryMap.get("url"), cast(String)queryMap.get("thUrl"), cast(String)queryMap.get("name"));
            }
            throw new IllegalArgumentException("Serviio URI is invalid: " + uri);
        }
        return null;
    }

    override public String toString()
    {
        return toURI();
    }

    public String toURI()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("serviio").append("://").append(_fileType(this._fileType)).append(":").append(repositoryType(this.repoType));
        builder.append("?").append("url").append("=").append(HttpUtils.urlEncode(this.repositoryUrl));
        if (ObjectValidator.isNotEmpty(this.thumbnailUrl)) {
            builder.append("&").append("thUrl").append("=").append(HttpUtils.urlEncode(this.thumbnailUrl));
        }
        if (ObjectValidator.isNotEmpty(this.repositoryName)) {
            builder.append("&").append("name").append("=").append(HttpUtils.urlEncode(this.repositoryName));
        }
        return builder.toString();
    }

    public String getRepositoryUrl()
    {
        return this.repositoryUrl;
    }

    public MediaFileType getFileType()
    {
        return this._fileType;
    }

    public OnlineRepositoryType getRepoType()
    {
        return this.repoType;
    }

    public String getThumbnailUrl()
    {
        return this.thumbnailUrl;
    }

    public String getRepositoryName()
    {
        return this.repositoryName;
    }

    private String fileType(MediaFileType ft)
    {
        switch (ft)
        {
            case VIDEO: 
                return "video";
            case AUDIO: 
                return "audio";
            case IMAGE: 
                return "image";
        }
        throw new IllegalArgumentException("Unexpected FileType");
    }

    private static MediaFileType fileType(String ft)
    {
        if (ft.equalsIgnoreCase("video")) {
            return MediaFileType.VIDEO;
        }
        if (ft.equalsIgnoreCase("audio")) {
            return MediaFileType.AUDIO;
        }
        if (ft.equalsIgnoreCase("image")) {
            return MediaFileType.IMAGE;
        }
        throw new IllegalArgumentException("Invalid media file type: " + ft);
    }

    private static OnlineRepositoryType repositoryType(String rt)
    {
        if (rt.equalsIgnoreCase("feed")) {
            return OnlineRepositoryType.FEED;
        }
        if (rt.equalsIgnoreCase("live")) {
            return OnlineRepositoryType.LIVE_STREAM;
        }
        if (rt.equalsIgnoreCase("web")) {
            return OnlineRepositoryType.WEB_RESOURCE;
        }
        throw new IllegalArgumentException("Invalid online repository type: " + rt);
    }

    private String repositoryType(OnlineRepositoryType rt)
    {
        switch (rt)
        {
            case FEED: 
                return "feed";
            case LIVE_STREAM2: 
                return "live";
            case WEB_RESOURCE3: 
                return "web";
        }
        throw new IllegalArgumentException("Unexpected OnlineRepositoryType");
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.ServiioUri
* JD-Core Version:    0.7.0.1
*/