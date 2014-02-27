module org.serviio.util.ServiioUri;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.metadata.MediaFileType;

public class ServiioUri
{
    public static immutable String SCHEMA = "serviio";
    private static final Pattern linkPattern = Pattern.compile("serviio://(\\w+):(\\w+)/?\\?(.+)", 2);
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
    private MediaFileType fileType;
    private OnlineRepository.OnlineRepositoryType repoType;
    private String thumbnailUrl;
    private String repositoryName;

    public this(MediaFileType fileType, OnlineRepository.OnlineRepositoryType repoType, String repositoryUrl, String thumbnailUrl, String repositoryName)
    {
        this.fileType = fileType;
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
                MediaFileType fileType = fileType(m.group(1));
                OnlineRepository.OnlineRepositoryType repoType = repositoryType(m.group(2));
                String query = m.group(3);
                if (ObjectValidator.isEmpty(query)) {
                    throw new IllegalArgumentException("Serviio URI path is missing: " + uri);
                }
                Map!(String, String) queryMap = HttpUtils.splitQuery(query);
                if (!queryMap.containsKey("url")) {
                    throw new IllegalArgumentException("Serviio URI is invalid, missing url parameter: " + uri);
                }
                return new ServiioUri(fileType, repoType, cast(String)queryMap.get("url"), cast(String)queryMap.get("thUrl"), cast(String)queryMap.get("name"));
            }
            throw new IllegalArgumentException("Serviio URI is invalid: " + uri);
        }
        return null;
    }

    public String toString()
    {
        return toURI();
    }

    public String toURI()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("serviio").append("://").append(fileType(this.fileType)).append(":").append(repositoryType(this.repoType));
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
        return this.fileType;
    }

    public OnlineRepository.OnlineRepositoryType getRepoType()
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

    private static OnlineRepository.OnlineRepositoryType repositoryType(String rt)
    {
        if (rt.equalsIgnoreCase("feed")) {
            return OnlineRepository.OnlineRepositoryType.FEED;
        }
        if (rt.equalsIgnoreCase("live")) {
            return OnlineRepository.OnlineRepositoryType.LIVE_STREAM;
        }
        if (rt.equalsIgnoreCase("web")) {
            return OnlineRepository.OnlineRepositoryType.WEB_RESOURCE;
        }
        throw new IllegalArgumentException("Invalid online repository type: " + rt);
    }

    private String repositoryType(OnlineRepository.OnlineRepositoryType rt)
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