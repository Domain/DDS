module org.serviio.library.local.metadata.extractor.embedded.EmbeddedMetadataExtractor;

import java.lang.Integer;
import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.jaudiotagger.audio.AudioFile;
import org.jaudiotagger.audio.AudioFileIO;
import org.jaudiotagger.audio.AudioHeader;
import org.jaudiotagger.audio.exceptions.CannotReadException;
import org.jaudiotagger.audio.exceptions.InvalidAudioFrameException;
import org.jaudiotagger.audio.exceptions.ReadOnlyFileException;
import org.jaudiotagger.audio.mp3.MP3File;
import org.jaudiotagger.audio.mp4.Mp4AudioHeader;
import org.jaudiotagger.tag.Tag;
import org.jaudiotagger.tag.TagException;
import org.jaudiotagger.tag.flac.FlacTag;
import org.jaudiotagger.tag.vorbiscomment.VorbisCommentTag;
import org.serviio.delivery.DeliveryContext;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.MetadataDescriptor;
import org.serviio.library.entities.Repository;
import org.serviio.library.local.ContentType;
import org.serviio.library.local.metadata.AudioMetadata;
import org.serviio.library.local.metadata.ImageMetadata;
import org.serviio.library.local.metadata.LocalItemMetadata;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.local.metadata.extractor.ExtractorType;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.serviio.library.local.metadata.extractor.MetadataExtractor;
import org.serviio.library.local.metadata.extractor.MetadataFile;
import org.serviio.library.local.metadata.extractor.MetadataSourceNotAccessibleException;
import org.serviio.library.metadata.FFmpegMetadataRetriever;
import org.serviio.library.metadata.ImageMetadataRetriever;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.FileUtils;
import org.serviio.util.ObjectValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmbeddedMetadataExtractor : MetadataExtractor
{
    private static Logger log;
    private static DateFormat DATE_FORMAT;

    static this()
    {
        log = LoggerFactory.getLogger!(EmbeddedMetadataExtractor);
        DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    }

    override public ExtractorType getExtractorType()
    {
        return ExtractorType.EMBEDDED;
    }

    override public bool isMetadataUpdated(File mediaFile, MediaItem mediaItem, MetadataDescriptor metadataDescriptor)
    {
        if ((mediaFile !is null) && (mediaFile.exists()) && (metadataDescriptor !is null))
        {
            Date mediaFileDate = FileUtils.getLastModifiedDate(mediaFile);
            if ((metadataDescriptor.getDateUpdated() is null) || (mediaFileDate.after(metadataDescriptor.getDateUpdated()))) {
                return true;
            }
            return false;
        }
        return false;
    }

    override protected MetadataFile getMetadataFile(File mediaFile, MediaFileType fileType, Repository repository)
    {
        if ((mediaFile.exists()) && (mediaFile.canRead())) {
            return new MetadataFile(getExtractorType(), FileUtils.getLastModifiedDate(mediaFile), null, mediaFile);
        }
        throw new IOException(java.lang.String.format("File %s cannot be read to extract metadata", cast(Object[])[ mediaFile.getAbsolutePath() ]));
    }

    override protected void retrieveMetadata(MetadataFile metadataDescriptor, LocalItemMetadata metadata)
    {
        File mediaFile = cast(File)metadataDescriptor.getExtractable();
        if (( cast(AudioMetadata)metadata !is null )) {
            retrieveAudioMetadata(mediaFile, metadata);
        } else if (( cast(ImageMetadata)metadata !is null )) {
            retrieveImageMetadata(mediaFile, metadata);
        } else {
            retrieveVideoMetadata(mediaFile, metadata);
        }
        if (ObjectValidator.isEmpty(metadata.getTitle())) {
            metadata.setTitle(FileUtils.getFileNameWithoutExtension(mediaFile));
        }
        if (metadata.getDate() is null) {
            metadata.setDate(FileUtils.getLastModifiedDate(mediaFile));
        }
        metadata.setFileSize(mediaFile.length());
        metadata.setFilePath(FileUtils.getProperFilePath(mediaFile));
    }

    protected void retrieveAudioMetadata(File mediaFile, LocalItemMetadata metadata)
    {
        AudioMetadata aMetadata = cast(AudioMetadata)metadata;
        try
        {
            AudioFile audioFile = AudioFileIO.read(mediaFile);
            Tag tag = audioFile.getTag();
            AudioHeader header = audioFile.getAudioHeader();

            AudioExtractionStrategy strategy = null;
            if (( cast(MP3File)audioFile !is null )) {
                strategy = new MP3ExtractionStrategy();
            } else if (header.getFormat().startsWith("ASF")) {
                strategy = new WMAExtractionStrategy();
            } else if (( cast(Mp4AudioHeader)header !is null )) {
                strategy = new MP4ExtractionStrategy();
            } else if (( cast(FlacTag)tag !is null )) {
                strategy = new FLACExtractionStrategy();
            } else if (( cast(VorbisCommentTag)tag !is null )) {
                strategy = new OGGExtractionStrategy();
            } else {
                throw new InvalidMediaFormatException(java.lang.String.format("File %s has unsupported audio format", cast(Object[])[ mediaFile.getName() ]));
            }
            strategy.extractMetadata(aMetadata, audioFile, header, tag);
        }
        catch (CannotReadException e)
        {
            FFmpegMetadataRetriever.retrieveAudioMetadata(aMetadata, FileUtils.getProperFilePath(mediaFile), DeliveryContext.local());
        }
        catch (InvalidAudioFrameException e)
        {
            throw new InvalidMediaFormatException(e);
        }
        catch (TagException e)
        {
            throw new InvalidMediaFormatException(e);
        }
        catch (ReadOnlyFileException e) {}
        if (aMetadata.getReleaseYear() !is null) {
            metadata.setDate(yearToDate(aMetadata.getReleaseYear()));
        }
    }

    protected void retrieveImageMetadata(File mediaFile, LocalItemMetadata metadata)
    {
        ImageMetadataRetriever.retrieveImageMetadata(cast(ImageMetadata)metadata, FileUtils.getProperFilePath(mediaFile), true);
    }

    protected void retrieveVideoMetadata(File mediaFile, LocalItemMetadata metadata)
    {
        VideoExtractionStrategy strategy = new VideoExtractionStrategy();

        strategy.extractMetadata(cast(VideoMetadata)metadata, mediaFile);

        (cast(VideoMetadata)metadata).setContentType(ContentType.UNKNOWN);
    }

    private Date yearToDate(Integer year)
    {
        String dateStr = "01/01/" ~ year.toString();
        try
        {
            return DATE_FORMAT.parse(dateStr);
        }
        catch (ParseException e)
        {
            log.debug_(java.lang.String.format("Could not parse year %s to date", cast(Object[])[ year ]));
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.EmbeddedMetadataExtractor
* JD-Core Version:    0.7.0.1
*/