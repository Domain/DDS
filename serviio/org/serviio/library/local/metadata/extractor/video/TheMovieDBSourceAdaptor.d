module org.serviio.library.local.metadata.extractor.video.TheMovieDBSourceAdaptor;

import java.lang;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.commons.imaging.ImageInfo;
import org.apache.commons.imaging.Imaging;
import org.serviio.config.Configuration;
import org.serviio.library.local.OnlineDBIdentifier;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.local.metadata.MPAARating;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.local.metadata.extractor.MetadataSourceNotAccessibleException;
import org.serviio.util.HttpClient;
import org.serviio.util.JsonUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.serviio.library.local.metadata.extractor.video.VideoDescription;
import org.serviio.library.local.metadata.extractor.video.SearchSourceAdaptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TheMovieDBSourceAdaptor : SearchSourceAdaptor
{
    private static immutable String APIKEY = "33a37a299fe4bef416e347c2fca2494c";
    private static immutable String API_BASE_CONTEXT = "http://api.themoviedb.org/3/";
    private static String IMAGE_URL_BASE;
    private static Logger log;
    private static DateFormat releaseDateFormat;

    static this()
    {
        log = LoggerFactory.getLogger!(TheMovieDBSourceAdaptor);
        releaseDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        setupImageUrl();
    }

    public void retrieveMetadata(String movieId, VideoMetadata videoMetadata)
    {
        String movieJSON = getMovieDetails(movieId);
        if (ObjectValidator.isNotEmpty(movieJSON)) {
            try
            {
                Map!(String, Object) json = JsonUtils.parseJson(movieJSON);
                videoMetadata.setTitle(getMovieTitle(json));
                videoMetadata.setDescription(getJsonFieldValue("overview", json));
                videoMetadata.setGenre(getGenre(json));
                videoMetadata.setDate(getReleaseDate(json));
                videoMetadata.setActors(getCast(json));
                videoMetadata.setDirectors(getCrew(json, "Director"));
                videoMetadata.setProducers(getCrew(json, "Producer"));
                videoMetadata.setMPAARating(getMPAARating(json));

                videoMetadata.getOnlineIdentifiers().put(OnlineDBIdentifier.TMDB, movieId);
                String imdbId = getJsonFieldValue("imdb_id", json);
                if (ObjectValidator.isNotEmpty(imdbId)) {
                    videoMetadata.getOnlineIdentifiers().put(OnlineDBIdentifier.IMDB, imdbId.trim());
                }
                if (Configuration.isRetrieveArtFromOnlineSources())
                {
                    String posterPath = getJsonFieldValue("poster_path", json);
                    if (ObjectValidator.isNotEmpty(posterPath))
                    {
                        String posterURL = String.format("%sw500%s", cast(Object[])[ IMAGE_URL_BASE, posterPath ]);
                        try
                        {
                            byte[] bannerBytes = HttpClient.retrieveBinaryFileFromURL(posterURL);
                            ImageInfo imageInfo = Imaging.getImageInfo(bannerBytes);
                            ImageDescriptor image = new ImageDescriptor(bannerBytes, imageInfo.getMimeType());
                            videoMetadata.setCoverImage(image);
                            log.debug_(String.format("Retrieved poster: %s", cast(Object[])[ posterURL ]));
                        }
                        catch (FileNotFoundException e)
                        {
                            log.warn(String.format("Poster '%s' doesn't exist, will try another one", cast(Object[])[ posterURL ]));
                        }
                        catch (Exception e)
                        {
                            log.warn(String.format("Cannot retrieve movie poster: %s", cast(Object[])[ e.getMessage() ]));
                        }
                    }
                }
            }
            catch (Exception e)
            {
                throw new IOException(String.format("Metadata XML for movie id %s is corrupt. ", cast(Object[])[ movieId ]));
            }
        } else {
            throw new IOException("Metadata XML file is missing");
        }
    }

    public String search(VideoDescription description)
    {
        String movieId = searchForMovie(description.getNames(), description.getYear());
        return movieId;
    }

    private String searchForMovie(String[] movieNames, Integer releaseYear)
    {
        List!(Map!(String, Object)) returnedMovieNodes = findAllSearchMatches(movieNames, releaseYear);
        if (returnedMovieNodes.size() > 0) {
            try
            {
                List!(Map!(String, Object)) moviesWithMatchingName = filterMovieNodesForNameMatch(returnedMovieNodes, movieNames);
                Map!(String, Object) matchingMovieNode = null;
                if (moviesWithMatchingName.size() > 0) {
                    matchingMovieNode = cast(Map)moviesWithMatchingName.get(0);
                } else {
                    matchingMovieNode = cast(Map)returnedMovieNodes.get(0);
                }
                if (matchingMovieNode !is null)
                {
                    String movieId = matchingMovieNode.get("id").toString();
                    log.debug_(String.format("Found a suitable movie match, id = %s", cast(Object[])[ movieId ]));
                    return movieId;
                }
            }
            catch (Exception e)
            {
                throw new IOException(String.format("Cannot retrieve movie search results: %s", cast(Object[])[ e.getMessage() ]));
            }
        } else {
            log.debug_("No movie with the name has been found");
        }
        return null;
    }

    private List!(Map!(String, Object)) findAllSearchMatches(String[] movieNames, Integer year)
    {
        List!(Map!(String, Object)) allReturnedNodes = new ArrayList();
        String languageCode = Configuration.getMetadataPreferredLanguage();
        foreach (String movieName ; movieNames) {
            if (ObjectValidator.isNotEmpty(movieName))
            {
                log.debug_(String.format("Searching for movie '%s' %s (language: %s)", cast(Object[])[ movieName, year !is null ? year : "", languageCode ]));
                try
                {
                    String moviesSearchPath = String.format("%ssearch/movie?query=%s&api_key=%s&language=%s&search_type=phrase&include_adult=true", cast(Object[])[ "http://api.themoviedb.org/3/", URLEncoder.encode(movieName, "UTF-8"), "33a37a299fe4bef416e347c2fca2494c", languageCode ]);
                    if (year !is null) {
                        moviesSearchPath = moviesSearchPath + "&year=" + year;
                    }
                    String searchResultJSON = getContentFromUrl(moviesSearchPath);
                    if (ObjectValidator.isNotEmpty(searchResultJSON))
                    {
                        Map!(String, Object) json = JsonUtils.parseJson(searchResultJSON);

                        Integer numberReturned = Integer.valueOf(Integer.parseInt(json.get("total_results").toString()));
                        log.debug_(String.format("Found %s matches", cast(Object[])[ numberReturned ]));
                        if (numberReturned.intValue() > 0) {
                            allReturnedNodes.addAll(cast(List)json.get("results"));
                        }
                    }
                    else
                    {
                        log.warn("Cannot retrieve movie search results, unrecognizable file returned (possibly error)");
                    }
                }
                catch (MetadataSourceNotAccessibleException e)
                {
                    throw e;
                }
                catch (Exception e)
                {
                    throw new IOException(String.format("Cannot retrieve movie search results: %s", cast(Object[])[ e.getMessage() ]));
                }
            }
        }
        return allReturnedNodes;
    }

    private static String getContentFromUrl(String url)
    {
        try
        {
            return HttpClient.retrieveTextFileFromURL(url, "UTF-8");
        }
        catch (IOException e)
        {
            throw new MetadataSourceNotAccessibleException("Error connecting to themoviedb.com: " + e.getMessage(), e);
        }
    }

    private String getMovieDetails(String movieId)
    {
        String languageCode = Configuration.getMetadataPreferredLanguage();
        log.debug_(String.format("Retrieving details of movie (movieId = %s, language = %s)", cast(Object[])[ movieId, languageCode ]));
        try
        {
            String movieDetailsPath = String.format("%smovie/%s?api_key=%s&language=%s&append_to_response=casts,releases", cast(Object[])[ "http://api.themoviedb.org/3/", movieId, "33a37a299fe4bef416e347c2fca2494c", languageCode ]);
            String movieJson = getContentFromUrl(movieDetailsPath);
            if (ObjectValidator.isNotEmpty(movieJson)) {
                return movieJson;
            }
            throw new IOException("Cannot retrieve movie details, returned document is empty (possible error)");
        }
        catch (FileNotFoundException fnfe)
        {
            throw new IOException(String.format("Cannot retrieve movie details (movieId = %s), file not found", cast(Object[])[ movieId ]));
        }
        catch (MetadataSourceNotAccessibleException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new IOException(String.format("Cannot retrieve movie details (movieId = %s): %s", cast(Object[])[ movieId, e.getMessage() ]));
        }
    }

    private List!(Map!(String, Object)) filterMovieNodesForNameMatch(List!(Map!(String, Object)) movieNodes, String[] movieNames)
    {
        List!(Map!(String, Object)) result = new ArrayList();
        if ((movieNodes !is null) && (movieNodes.size() > 0)) {
            for (int i = 0; i < movieNodes.size(); i++)
            {
                Map!(String, Object) movieNode = cast(Map)movieNodes.get(i);
                String name = getJsonFieldValue("title", movieNode);
                String originalName = getJsonFieldValue("original_title", movieNode);
                foreach (String movieName ; movieNames) {
                    if (movieName !is null)
                    {
                        String trimmedMovieName = StringUtils.localeSafeToLowercase(movieName).trim();
                        if (((name !is null) && (trimmedMovieName.equalsIgnoreCase(name.trim()))) || ((originalName !is null) && (trimmedMovieName.equalsIgnoreCase(originalName.trim()))))
                        {
                            result.add(movieNode);
                            break;
                        }
                    }
                }
            }
        }
        return result;
    }

    private List!(String) getCast(Map!(String, Object) json)
    {
        List!(String) result = new ArrayList();
        Map!(String, Object) casts = cast(Map)json.get("casts");
        if (casts !is null)
        {
            List!(Map!(String, Object)) crew = cast(List)casts.get("cast");
            if (crew !is null) {
                for (int i = 0; i < crew.size(); i++) {
                    result.add(getJsonFieldValue("name", cast(Map)crew.get(i)));
                }
            }
        }
        return result;
    }

    private List!(String) getCrew(Map!(String, Object) json, String job)
    {
        List!(String) result = new ArrayList();
        Map!(String, Object) casts = cast(Map)json.get("casts");
        if (casts !is null)
        {
            List!(Map!(String, Object)) crew = cast(List)casts.get("crew");
            if (crew !is null) {
                for (int i = 0; i < crew.size(); i++)
                {
                    Map!(String, Object) crewEntry = cast(Map)crew.get(i);
                    String crewEntryJob = getJsonFieldValue("job", crewEntry);
                    if (job.opEquals(crewEntryJob)) {
                        result.add(getJsonFieldValue("name", cast(Map)crew.get(i)));
                    }
                }
            }
        }
        return result;
    }

    private Date getReleaseDate(Map!(String, Object) json)
    {
        String releaseDateString = getJsonFieldValue("release_date", json);
        if (ObjectValidator.isNotEmpty(releaseDateString)) {
            try
            {
                return releaseDateFormat.parse(releaseDateString.trim());
            }
            catch (ParseException e)
            {
                return null;
            }
        }
        return null;
    }

    private String getMovieTitle(Map!(String, Object) json)
    {
        String title = getJsonFieldValue("title", json);
        if (Configuration.isMetadataUseOriginalTitle())
        {
            String originalTitle = getJsonFieldValue("original_title", json);
            if (ObjectValidator.isNotEmpty(originalTitle)) {
                title = originalTitle;
            }
        }
        return title;
    }

    private String getGenre(Map!(String, Object) json)
    {
        List!(Map!(String, Object)) genres = cast(List)json.get("genres");
        if (genres.size() > 0) {
            return getJsonFieldValue("name", cast(Map)genres.get(0));
        }
        return null;
    }

    private static String getJsonFieldValue(String field, Map!(String, Object) json)
    {
        return StringUtils.trim(StringUtils.toString(json.get(field)));
    }

    private static void setupImageUrl()
    {
        String configurationPath = String.format("%sconfiguration?api_key=%s", cast(Object[])[ "http://api.themoviedb.org/3/", "33a37a299fe4bef416e347c2fca2494c" ]);
        try
        {
            String configJson = getContentFromUrl(configurationPath);
            Map!(String, Object) json = JsonUtils.parseJson(configJson);
            Map!(String, Object) images = cast(Map)json.get("images");
            IMAGE_URL_BASE = getJsonFieldValue("base_url", images);
        }
        catch (MetadataSourceNotAccessibleException e)
        {
            log.error("Cannot load themoviedb.org configuration data", e);
        }
    }

    private MPAARating getMPAARating(Map!(String, Object) json)
    {
        Map!(String, Object) releases = cast(Map)json.get("releases");
        if ((releases !is null) && (releases.size() > 0))
        {
            List!(Map!(String, Object)) countries = cast(List)releases.get("countries");
            if (countries !is null) {
                foreach (Map!(String, Object) country ; countries) {
                    if (country.get("iso_3166_1").toString().equalsIgnoreCase("US"))
                    {
                        String normalizedRating = StringUtils.localeSafeToLowercase(country.get("certification").toString());
                        if (normalizedRating.equals("pg-13")) {
                            return MPAARating.PG13;
                        }
                        if (normalizedRating.equals("pg")) {
                            return MPAARating.PG;
                        }
                        if (normalizedRating.equals("g")) {
                            return MPAARating.G;
                        }
                        if (normalizedRating.equals("r")) {
                            return MPAARating.R;
                        }
                        if (normalizedRating.equals("nc-17")) {
                            return MPAARating.NC17;
                        }
                    }
                }
            }
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.video.TheMovieDBSourceAdaptor
* JD-Core Version:    0.7.0.1
*/