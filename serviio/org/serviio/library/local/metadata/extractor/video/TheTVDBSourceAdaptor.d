module org.serviio.library.local.metadata.extractor.video.TheTVDBSourceAdaptor;

import java.lang;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.xml.xpath.XPathExpressionException;
import org.apache.commons.imaging.ImageInfo;
import org.apache.commons.imaging.Imaging;
import org.serviio.config.Configuration;
import org.serviio.library.local.OnlineDBIdentifier;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.local.metadata.extractor.MetadataSourceNotAccessibleException;
import org.serviio.util.HttpClient;
import org.serviio.util.NumberUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.serviio.util.XPathUtil;
import org.serviio.library.local.metadata.extractor.video.SearchSourceAdaptor;
import org.serviio.library.local.metadata.extractor.video.VideoDescription;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class TheTVDBSourceAdaptor : SearchSourceAdaptor
{
    private static immutable String APIKEY = "235C8CA4529142E9";
    private static immutable String API_BASE_CONTEXT = "/api/";
    private static immutable String MAIN_SERVER_URL = "http://thetvdb.com";
    private static List!(String) xmlMirrors;
    private static List!(String) bannerMirrors;
    private static Logger log;
    private static DateFormat firstAiredDateFormat;
    private String seriesId;
    private String episodeXML;

    static this()
    {
        xmlMirrors = new ArrayList!(String)();
        bannerMirrors = new ArrayList!(String)();
        log = LoggerFactory.getLogger!(TheTVDBSourceAdaptor);
        firstAiredDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    }

    public void retrieveMetadata(String episodeId, VideoMetadata videoMetadata)
    {
        String seriesXML = getSeriesDetails(this.seriesId);
        if ((ObjectValidator.isNotEmpty(seriesXML)) && (ObjectValidator.isNotEmpty(this.episodeXML))) {
            try
            {
                Node rootSeriesNode = XPathUtil.getRootNode(seriesXML);
                Node seriesNode = XPathUtil.getNode(rootSeriesNode, "Data/Series");
                String actors = XPathUtil.getNodeValue(seriesNode, "Actors");
                videoMetadata.setActors(splitMultiValue(actors));
                videoMetadata.setSeriesName(StringUtils.trim(XPathUtil.getNodeValue(seriesNode, "SeriesName")));


                Node rootEpisodeNode = XPathUtil.getRootNode(this.episodeXML);
                Node episodeNode = XPathUtil.getNode(rootEpisodeNode, "Data/Episode");
                videoMetadata.setTitle(StringUtils.trim(XPathUtil.getNodeValue(episodeNode, "EpisodeName")));
                videoMetadata.setDirectors(splitMultiValue(XPathUtil.getNodeValue(episodeNode, "Director")));
                videoMetadata.setDescription(StringUtils.trim(XPathUtil.getNodeValue(episodeNode, "Overview")));
                videoMetadata.setDate(getFirstAiredDate(XPathUtil.getNodeValue(episodeNode, "FirstAired")));
                String seasonNumber = StringUtils.trim(XPathUtil.getNodeValue(episodeNode, "SeasonNumber"));
                String episodeNumber = StringUtils.trim(XPathUtil.getNodeValue(episodeNode, "EpisodeNumber"));
                videoMetadata.setSeasonNumber(ObjectValidator.isNotEmpty(seasonNumber) ? Integer.valueOf(seasonNumber) : null);
                videoMetadata.setEpisodeNumber(ObjectValidator.isNotEmpty(episodeNumber) ? Integer.valueOf(episodeNumber) : null);

                videoMetadata.getOnlineIdentifiers().put(OnlineDBIdentifier.TVDB, episodeId);
                String imdbId = XPathUtil.getNodeValue(episodeNode, "IMDB_ID");
                if (ObjectValidator.isNotEmpty(imdbId)) {
                    videoMetadata.getOnlineIdentifiers().put(OnlineDBIdentifier.IMDB, imdbId.trim());
                }
                if (Configuration.isRetrieveArtFromOnlineSources())
                {
                    String episodeBannerFile = XPathUtil.getNodeValue(episodeNode, "filename");
                    videoMetadata.setCoverImage(loadImage(episodeBannerFile));
                    String seriesPoster = XPathUtil.getNodeValue(seriesNode, "poster");
                    if (ObjectValidator.isEmpty(seriesPoster)) {
                        seriesPoster = XPathUtil.getNodeValue(seriesNode, "fanart");
                    }
                    videoMetadata.setSeriesCoverImage(loadImage(seriesPoster));
                }
            }
            catch (XPathExpressionException e)
            {
                throw new IOException(String.format("Cannot retrieve metadata for episode %s from tvdb.com, the returned XML is corrupt", cast(Object[])[ episodeId ]));
            }
        } else {
            throw new IOException("Series metadata is missing");
        }
    }

    public String search(VideoDescription description)
    {
        setupMirrors();

        String episodeId = null;

        int i = 0;
        while ((this.seriesId is null) && (i < description.getNames().length)) {
            this.seriesId = searchForSeries(description.getNames()[(i++)], description.getYear());
        }
        if ((this.seriesId is null) && (description.getYear() !is null))
        {
            i = 0;
            while ((this.seriesId is null) && (i < description.getNames().length)) {
                this.seriesId = searchForSeries(description.getNames()[(i++)], null);
            }
        }
        if (this.seriesId !is null) {
            episodeId = getEpisodeDetails(this.seriesId, description.getSeason().intValue(), description.getEpisode().intValue());
        }
        return episodeId;
    }

    private static void setupMirrors()
    {
        if ((xmlMirrors.isEmpty()) || (bannerMirrors.isEmpty()))
        {
            String path = String.format("%s%s%s/mirrors.xml", cast(Object[])[ "http://thetvdb.com", "/api/", "235C8CA4529142E9" ]);
            try
            {
                String mirrorsXML = retrieveXMLFromUrl(path);
                if (ObjectValidator.isNotEmpty(mirrorsXML))
                {
                    Node rootNode = XPathUtil.getRootNode(mirrorsXML);
                    NodeList mirrorNodes = XPathUtil.getNodeSet(rootNode, "Mirrors/Mirror");

                    log.debug_(String.format("Found %s mirror(s)", cast(Object[])[ Integer.valueOf(mirrorNodes.getLength()) ]));
                    for (int i = 0; i < mirrorNodes.getLength(); i++)
                    {
                        Node mirrorNode = mirrorNodes.item(i);
                        Integer typeMask = Integer.valueOf(Integer.parseInt(XPathUtil.getNodeValue(mirrorNode, "typemask")));
                        String mirrorPath = XPathUtil.getNodeValue(mirrorNode, "mirrorpath");
                        if ((typeMask.intValue() == 1) || (typeMask.intValue() == 3) || (typeMask.intValue() == 7)) {
                            xmlMirrors.add(mirrorPath);
                        }
                        if ((typeMask.intValue() == 2) || (typeMask.intValue() == 3) || (typeMask.intValue() == 7)) {
                            bannerMirrors.add(mirrorPath);
                        }
                    }
                }
                else
                {
                    throw new IOException("Cannot retrieve list of mirrors for tvdb.com, returned document is empty");
                }
            }
            catch (FileNotFoundException fnfe)
            {
                throw new IOException("Cannot retrieve list of mirrors for tvdb.com, file not found");
            }
            catch (MetadataSourceNotAccessibleException e)
            {
                throw e;
            }
            catch (Exception e)
            {
                throw new IOException(String.format("Cannot retrieve list of mirrors for tvdb.com: %s", cast(Object[])[ e.getMessage() ]), e);
            }
        }
    }

    private String searchForSeries(String seriesName, Integer year)
    {
        if (ObjectValidator.isNotEmpty(seriesName))
        {
            String seriesNameSearchString = String.format("%s%s", cast(Object[])[ seriesName, year !is null ? " " + year.toString() : "" ]);
            log.debug_(String.format("Searching for series '%s'", cast(Object[])[ seriesNameSearchString ]));
            try
            {
                String seriesSearchPath = String.format("%s%sGetSeries.php?seriesname=%s&language=all", cast(Object[])[ "http://thetvdb.com", "/api/", URLEncoder.encode(seriesNameSearchString, "UTF-8") ]);
                String searchResultXML = retrieveXMLFromUrl(seriesSearchPath);
                if (ObjectValidator.isNotEmpty(searchResultXML)) {
                    try
                    {
                        Node rootNode = XPathUtil.getRootNode(searchResultXML);
                        Node errorNode = XPathUtil.getNode(rootNode, "Error");
                        if (errorNode is null)
                        {
                            NodeList seriesNodes = XPathUtil.getNodeSet(rootNode, "Data/Series");
                            if ((seriesNodes !is null) && (seriesNodes.getLength() > 0))
                            {
                                log.debug_(String.format("Found %s series (or translations), using the first one", cast(Object[])[ Integer.valueOf(seriesNodes.getLength()) ]));
                                Node seriesNode = seriesNodes.item(0);
                                return XPathUtil.getNodeValue(seriesNode, "seriesid");
                            }
                            log.debug_("No series with the name has been found");
                        }
                        else
                        {
                            throw new IOException("Cannot retrieve series search results for tvdb.com, an error was returned");
                        }
                    }
                    catch (XPathExpressionException e)
                    {
                        throw new IOException("Cannot retrieve series search results for tvdb.com, the returned XML is corrupt");
                    }
                } else {
                    throw new IOException("Cannot retrieve series search results for tvdb.com, returned document is empty");
                }
            }
            catch (FileNotFoundException fnfe)
            {
                throw new IOException("Cannot retrieve series search results for tvdb.com, file not found");
            }
            catch (Exception e)
            {
                throw new IOException(String.format("Cannot retrieve series search results for tvdb.com: %s", cast(Object[])[ e.getMessage() ]));
            }
        }
        return null;
    }

    private String getEpisodeDetails(String seriesId, int season, int episode)
    {
        String languageCode = Configuration.getMetadataPreferredLanguage();
        log.debug_(String.format("Retrieving details of episode (seriesId = %s, season = %s, episode = %s, language = %s)", cast(Object[])[ seriesId, Integer.valueOf(season), Integer.valueOf(episode), languageCode ]));
        try
        {
            String episodeDetailsPath = String.format("%s%s%s/series/%s/default/%s/%s/%s.xml", cast(Object[])[ getXMLMirror(), "/api/", "235C8CA4529142E9", seriesId, Integer.valueOf(season), Integer.valueOf(episode), languageCode ]);

            this.episodeXML = retrieveXMLFromUrl(episodeDetailsPath);
            if (ObjectValidator.isNotEmpty(this.episodeXML))
            {
                Node rootNode = XPathUtil.getRootNode(this.episodeXML);
                return XPathUtil.getNodeValue(rootNode, "Data/Episode/id");
            }
            throw new IOException("Cannot retrieve episode details, returned document is empty");
        }
        catch (FileNotFoundException fnfe)
        {
            throw new IOException(String.format("Cannot retrieve episode details (series = %s, season = %s, episode = %s), file not found", cast(Object[])[ seriesId, Integer.valueOf(season), Integer.valueOf(episode) ]));
        }
        catch (MetadataSourceNotAccessibleException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new IOException(String.format("Cannot retrieve episode details (series = %s, season = %s, episode = %s): %s", cast(Object[])[ seriesId, Integer.valueOf(season), Integer.valueOf(episode), e.getMessage() ]));
        }
    }

    private String getSeriesDetails(String seriesId)
    {
        String languageCode = Configuration.getMetadataPreferredLanguage();
        log.debug_(String.format("Retrieving details of series (seriesId = %s, language = %s)", cast(Object[])[ seriesId, languageCode ]));
        try
        {
            String seriesDetailsPath = String.format("%s%s%s/series/%s/%s.xml", cast(Object[])[ getXMLMirror(), "/api/", "235C8CA4529142E9", seriesId, languageCode ]);

            return retrieveXMLFromUrl(seriesDetailsPath);
        }
        catch (FileNotFoundException fnfe)
        {
            throw new IOException(String.format("Cannot retrieve series details (series = %s), file not found", cast(Object[])[ seriesId ]));
        }
        catch (MetadataSourceNotAccessibleException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new IOException(String.format("Cannot retrieve series details (series = %s): %s", cast(Object[])[ seriesId, e.getMessage() ]));
        }
    }

    private String getBannerMirror()
    {
        int index = NumberUtils.getRandomInInterval(0, bannerMirrors.size() - 1);
        return cast(String)bannerMirrors.get(index);
    }

    private String getXMLMirror()
    {
        int index = NumberUtils.getRandomInInterval(0, xmlMirrors.size() - 1);
        return cast(String)xmlMirrors.get(index);
    }

    private List!(String) splitMultiValue(String value)
    {
        if (ObjectValidator.isNotEmpty(value))
        {
            if (value.startsWith("|")) {
                value = value.substring(1);
            }
            if (value.endsWith("|")) {
                value = value.substring(0, value.length() - 1);
            }
            return Arrays.asList(value.split("\\|"));
        }
        return Collections.emptyList();
    }

    private Date getFirstAiredDate(String firstAiredDateString)
    {
        if (ObjectValidator.isNotEmpty(firstAiredDateString)) {
            try
            {
                return firstAiredDateFormat.parse(firstAiredDateString.trim());
            }
            catch (ParseException e)
            {
                return null;
            }
        }
        return null;
    }

    private static String retrieveXMLFromUrl(String url)
    {
        String xml = null;
        try
        {
            xml = HttpClient.retrieveTextFileFromURL(url, "UTF-8");
        }
        catch (IOException e)
        {
            throw new MetadataSourceNotAccessibleException("Error connecting to thetvdb.com: " + e.getMessage(), e);
        }
        try
        {
            XPathUtil.getRootNode(xml);
        }
        catch (Exception e)
        {
            log.debug_("Retrieved XML cannot be parsed, it might be a gzip file. Trying unzipping it.");
            xml = HttpClient.retrieveGZippedTextFileFromURL(url, "UTF-8");
            try
            {
                XPathUtil.getRootNode(xml);
            }
            catch (Exception e1)
            {
                throw new IOException("Failed to parse retrieved file (even unpacked version)");
            }
        }
        return xml;
    }

    private ImageDescriptor loadImage(String bannerFile)
    {
        if (ObjectValidator.isNotEmpty(bannerFile)) {
            try
            {
                String bannerPath = String.format("%s/banners/%s", cast(Object[])[ getBannerMirror(), bannerFile ]);
                byte[] bannerBytes = HttpClient.retrieveBinaryFileFromURL(bannerPath);
                ImageInfo imageInfo = Imaging.getImageInfo(bannerBytes);
                ImageDescriptor image = new ImageDescriptor(bannerBytes, imageInfo.getMimeType());
                log.debug_(String.format("Retrieved banner: %s", cast(Object[])[ bannerPath ]));
                return image;
            }
            catch (Exception e)
            {
                log.warn(String.format("Cannot retrieve banner: %s", cast(Object[])[ e.getMessage() ]));
            }
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.video.TheTVDBSourceAdaptor
* JD-Core Version:    0.7.0.1
*/