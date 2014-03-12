module org.serviio.library.local.metadata.extractor.MyMoviesExtractor;

import java.lang.String;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import javax.xml.xpath.XPathExpressionException;
import org.serviio.config.Configuration;
import org.serviio.library.entities.Repository;
import org.serviio.library.local.ContentType;
import org.serviio.library.local.OnlineDBIdentifier;
import org.serviio.library.local.metadata.LocalItemMetadata;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.FileUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.serviio.util.XPathUtil;
import org.serviio.library.local.metadata.extractor.AbstractLocalFileExtractor;
import org.serviio.library.local.metadata.extractor.ExtractorType;
import org.serviio.library.local.metadata.extractor.MetadataFile;
import org.slf4j.Logger;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class MyMoviesExtractor : AbstractLocalFileExtractor
{
    override public ExtractorType getExtractorType()
    {
        return ExtractorType.MYMOVIES;
    }

    override protected MetadataFile getMetadataFile(File mediaFile, MediaFileType fileType, Repository repository)
    {
        if (fileType == MediaFileType.VIDEO)
        {
            File folder = mediaFile.getParentFile();
            if ((folder !is null) && (folder.exists()) && (folder.isDirectory()))
            {
                File xmlFile = findFileInFolder(folder, "mymovies.xml", true);
                if (xmlFile !is null)
                {
                    bool validFile = validateMyMoviesFile(xmlFile);
                    if (validFile)
                    {
                        this.log.debug_("Found MyMovies file. Will try to extract metadata from it.");
                        MetadataFile metadataFile = new MetadataFile(getExtractorType(), FileUtils.getLastModifiedDate(xmlFile), xmlFile.getName(), mediaFile);

                        return metadataFile;
                    }
                    return null;
                }
                return null;
            }
            return null;
        }
        return null;
    }

    override protected void retrieveMetadata(LocalItemMetadata metadata, File xmlFile, File mediaFile)
    {
        InputStream xmlStream = null;
        try
        {
            xmlStream = new FileInputStream(xmlFile);
            Node rootNode = XPathUtil.getRootNode(xmlStream);
            if (rootNode !is null)
            {
                VideoMetadata vd = cast(VideoMetadata)metadata;
                Node titleNode = XPathUtil.getNode(rootNode, "Title");
                if (Configuration.isMetadataUseOriginalTitle()) {
                    vd.setTitle(StringUtils.trim(XPathUtil.getNodeValue(titleNode, "OriginalTitle")));
                } else {
                    vd.setTitle(StringUtils.trim(XPathUtil.getNodeValue(titleNode, "LocalTitle")));
                }
                vd.setDirectors(Collections.singletonList(StringUtils.trim(XPathUtil.getNodeValue(titleNode, "Persons/Person[@Type='2'][1]/Name"))));
                vd.setActors(getActors(titleNode));
                vd.setDescription(StringUtils.trim(XPathUtil.getNodeValue(titleNode, "Description")));
                vd.setGenre(StringUtils.trim(XPathUtil.getNodeValue(titleNode, "Genres/Genre[1]")));
                vd.setContentType(ContentType.MOVIE);

                String imdbId = XPathUtil.getNodeValue(titleNode, "IMDB");
                if (ObjectValidator.isNotEmpty(imdbId)) {
                    vd.getOnlineIdentifiers().put(OnlineDBIdentifier.IMDB, imdbId.trim());
                }
            }
        }
        catch (XPathExpressionException e)
        {
            throw new InvalidMediaFormatException(String.format("File '%s' couldn't be parsed: %s", cast(Object[])[ xmlFile.getPath(), e.getMessage() ]));
        }
        finally
        {
            FileUtils.closeQuietly(xmlStream);
        }
    }

    private bool validateMyMoviesFile(File xmlFile)
    {
        this.log.debug_(String.format("Checking if file '%s' is a MyMovies XML file", cast(Object[])[ xmlFile.getName() ]));
        InputStream xmlStream = null;
        try
        {
            xmlStream = new FileInputStream(xmlFile);
            Node rootNode = XPathUtil.getRootNode(xmlStream);
            if (rootNode !is null)
            {
                titleNode = XPathUtil.getNode(rootNode, "Title");
                if (titleNode !is null)
                {
                    this.log.debug_(String.format("File '%s' is a valid MyMovies XML file", cast(Object[])[ xmlFile.getName() ]));
                    return true;
                }
            }
            this.log.debug_(String.format("File '%s' is not a MyMovies XML file", cast(Object[])[ xmlFile.getName() ]));
            return 0;
        }
        catch (XPathExpressionException e)
        {
            Node titleNode;
            this.log.error(String.format("File '%s' couldn't be parsed: %s", cast(Object[])[ xmlFile.getPath(), e.getMessage() ]));
            return 0;
        }
        finally
        {
            FileUtils.closeQuietly(xmlStream);
        }
    }

    private List!(String) getActors(Node titleNode)
    {
        List!(String) result = new ArrayList();
        NodeList actorsNodeList = XPathUtil.getNodeSet(titleNode, "Persons/Person[@Type='1']");
        if ((actorsNodeList !is null) && (actorsNodeList.getLength() > 0)) {
            for (int i = 0; i < actorsNodeList.getLength(); i++)
            {
                Node personNode = actorsNodeList.item(i);
                result.add(StringUtils.trim(XPathUtil.getNodeValue(personNode, "Name")));
            }
        }
        return result;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.MyMoviesExtractor
* JD-Core Version:    0.7.0.1
*/