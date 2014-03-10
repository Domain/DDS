module org.serviio.delivery.subtitles.SubtitlesService;

import java.lang;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map:Entry;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOCase;
import org.apache.commons.io.filefilter.RegexFileFilter;
import org.serviio.config.Configuration;
import org.serviio.db.dao.PersistenceException;
import org.serviio.dlna.SubtitleCodec;
import org.serviio.dlna.VideoContainer;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.Video;
import org.serviio.library.local.EmbeddedSubtitles;
import org.serviio.library.local.service.MediaService;
import org.serviio.library.local.service.VideoService;
import org.serviio.library.service.Service;
import org.serviio.profile.Profile;
import org.serviio.util.CollectionUtils;
import org.serviio.util.FileUtils;
import org.serviio.util.StringUtils;
import org.serviio.delivery.subtitles.SubtitlesReader;
import org.serviio.upnp.service.contentdirectory.ProtocolAdditionalInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SubtitlesService : Service
{
    public static immutable String FONT_CONFIG_XML = "fonts.conf";
    public static immutable String FONT_CONFIG_DIR = FileUtils.getFilePathOfClasspathResource("/fonts", SubtitlesService.class_);
    private static Logger log = LoggerFactory.getLogger!(SubtitlesService);
    private static immutable String subtitleFileExtensionsRegEx = "(" + CollectionUtils.listToCSV(SubtitleCodec.getAllSupportedExtensions(), "|", false) + ")";

    public static bool isSoftSubsAvailable(I : ProtocolAdditionalInfo)(Video item, Profile!T rendererProfile)
    {
        if (rendererProfile.getSubtitlesConfiguration().isSoftSubsEnabled())
        {
            File extSubs = findExternalSubtitleFile(item);
            EmbeddedSubtitles embSubs = findEmbeddedSubtitles(item);
            if ((extSubs !is null) || (embSubs !is null))
            {
                if (extSubs !is null) {
                    log.debug_("Found external subtitles file: " + extSubs.getName());
                }
                if (embSubs !is null) {
                    log.debug_("Found embedded subtitles track: " + embSubs.getLanguageCode());
                }
                return true;
            }
            return false;
        }
        return false;
    }

    public static SubtitlesReader getSoftSubs(I : ProtocolAdditionalInfo)(Long itemId, Profile!I rendererProfile)
    {
        if (rendererProfile.getSubtitlesConfiguration().isSoftSubsEnabled())
        {
            MediaItem mediaItem = VideoService.getVideo(itemId);
            if (mediaItem !is null) {
                return findAvailableSubtitles(cast(Video)mediaItem);
            }
        }
        return null;
    }

    public static SubtitlesReader getHardSubs(I : ProtocolAdditionalInfo)(Video video, Profile!I rendererProfile)
    {
        List!(VideoContainer) requiredForContainers = rendererProfile.getSubtitlesConfiguration().getHardSubsRequiredFor();
        if ((Configuration.isHardSubsForced()) || (requiredForContainers.contains(VideoContainer.ANY)) || (requiredForContainers.contains(video.getContainer()))) {
            return findAvailableSubtitles(video);
        }
        return null;
    }

    private static SubtitlesReader findAvailableSubtitles(Video item)
    {
        File externalFile = findExternalSubtitleFile(item);
        if (externalFile !is null)
        {
            log.debug_(String.format("Found external subtitle file: %s", cast(Object[])[ externalFile.toString() ]));
            return new ExternalFileSubtitlesReader(externalFile);
        }
        EmbeddedSubtitles es = findEmbeddedSubtitles(item);
        if (es !is null)
        {
            log.debug_(String.format("Found embedded subtitle track: %s (%s)", cast(Object[])[ es.getStreamId(), es.getLanguageCode() ]));
            return new EmbeddedSubtitlesReader(item, es);
        }
        return null;
    }

    private static EmbeddedSubtitles findEmbeddedSubtitles(Video item)
    {
        List!(String) preferredLanguages = Configuration.getSubtitlesPreferredLanguages();
        TreeMap!(Integer, EmbeddedSubtitles) suitableSubs = new TreeMap();
        if ((Configuration.isEmbeddedSubtitlesExtracted()) && (preferredLanguages.size() > 0))
        {
            foreach (EmbeddedSubtitles es ; item.getEmbeddedSubtitles())
            {
                Integer foundSubLanguageIndex = Integer.valueOf(CollectionUtils.findIndexOf(preferredLanguages, es.getLanguageCode(), false));
                if (foundSubLanguageIndex.intValue() > -1) {
                    suitableSubs.put(foundSubLanguageIndex, es);
                }
            }
            if (suitableSubs.size() > 0) {
                return cast(EmbeddedSubtitles)suitableSubs.firstEntry().getValue();
            }
        }
        return null;
    }

    private static File findExternalSubtitleFile(Video mediaItem)
    {
        if (mediaItem.isLocalMedia()) {
            try
            {
                File mediaFile = MediaService.getFile(mediaItem.getId());
                if (mediaFile !is null) {
                    if (mediaFile.getParentFile().exists())
                    {
                        List!(String) preferredLanguages = Configuration.getSubtitlesPreferredLanguages();
                        File[] foundFiles = mediaFile.getParentFile().listFiles(new RegexFileFilter(generateSubtitleSearchRegEx(mediaFile, preferredLanguages), IOCase.INSENSITIVE));


                        File selectedSubtitleFile = selectBestSubtitleFile(mediaFile.getName(), foundFiles, preferredLanguages);
                        if (selectedSubtitleFile !is null) {
                            return selectedSubtitleFile;
                        }
                    }
                }
            }
            catch (PersistenceException e)
            {
                log.warn(e.getMessage());
            }
        }
        return null;
    }

    protected static String generateSubtitleSearchRegEx(File mediaFile, List!(String) preferredLanguages)
    {
        if (preferredLanguages.isEmpty()) {
            return "^" + Pattern.quote(FileUtils.getFileNameWithoutExtension(mediaFile)) + "\\." + subtitleFileExtensionsRegEx + "$";
        }
        return "^" + Pattern.quote(FileUtils.getFileNameWithoutExtension(mediaFile)) + "([-_(\\.](" + CollectionUtils.listToCSV(preferredLanguages, "|", true) + ")(\\))?)?\\." + subtitleFileExtensionsRegEx + "$";
    }

    protected static File selectBestSubtitleFile(String mediaFileName, File[] subtitleFiles, List!(String) preferredLanguages)
    {
        if (subtitleFiles.length == 0) {
            return null;
        }
        if (preferredLanguages.isEmpty())
        {
            List!(File) subtitleFilesWithmatchingName = new ArrayList();
            foreach (File subtitleFile ; subtitleFiles) {
                if (FileUtils.getFileNameWithoutExtension(subtitleFile).equals(FilenameUtils.getBaseName(mediaFileName))) {
                    subtitleFilesWithmatchingName.add(subtitleFile);
                }
            }
            if (subtitleFilesWithmatchingName.size() == 0) {
                return null;
            }
            Collections.sort(subtitleFilesWithmatchingName, new SubtitleFilesComparator(null));
            return cast(File)subtitleFilesWithmatchingName.get(0);
        }
        Arrays.sort(subtitleFiles, new SubtitleFilesComparator(preferredLanguages));
        return subtitleFiles[0];
    }

    private static class SubtitleFilesComparator : Comparator!(File)
    {
        private List!(String) preferredLanguages;

        public this(List!(String) preferredLanguages)
        {
            this.preferredLanguages = preferredLanguages;
        }

        public int compare(File o1, File o2)
        {
            if (o1.equals(o2)) {
                return 0;
            }
            String fileName1 = o1.getName();
            String fileName2 = o2.getName();

            String fileName1Language = null;
            String fileName2Language = null;
            if ((this.preferredLanguages !is null) && (this.preferredLanguages.size() > 0))
            {
                Pattern filenameWithLanguage = Pattern.compile(".*[-_(\\.](" + CollectionUtils.listToCSV(this.preferredLanguages, "|", true) + ")(\\))?\\." + SubtitlesService.subtitleFileExtensionsRegEx, 2);


                Matcher fileName1Matcher = filenameWithLanguage.matcher(fileName1);
                Matcher fileName2Matcher = filenameWithLanguage.matcher(fileName2);
                if (fileName1Matcher.find()) {
                    fileName1Language = fileName1Matcher.group(1);
                }
                if (fileName2Matcher.find()) {
                    fileName2Language = fileName2Matcher.group(1);
                }
            }
            if ((fileName1Language !is null) && (fileName2Language !is null))
            {
                int language1Order = CollectionUtils.findIndexOf(this.preferredLanguages, fileName1Language, false);
                int language2Order = CollectionUtils.findIndexOf(this.preferredLanguages, fileName2Language, false);
                if (language1Order == language2Order) {
                    return prioritizeSrt(fileName1);
                }
                return language1Order < language2Order ? -1 : 1;
            }
            if ((fileName1Language is null) && (fileName2Language is null)) {
                return prioritizeSrt(fileName1);
            }
            if (fileName1Language !is null) {
                return -1;
            }
            return 1;
        }

        private int prioritizeSrt(String filename)
        {
            return StringUtils.localeSafeToLowercase(filename).endsWith("." + cast(String)SubtitleCodec.SRT.getFileExtensions().get(0)) ? -1 : 1;
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.subtitles.SubtitlesService
* JD-Core Version:    0.7.0.1
*/