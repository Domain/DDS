module org.serviio.library.local.metadata.extractor.embedded.MP4ExtractionStrategy;

import java.io.IOException;
import org.jaudiotagger.audio.AudioFile;
import org.jaudiotagger.audio.AudioHeader;
import org.jaudiotagger.tag.Tag;
import org.serviio.dlna.AudioContainer;
import org.serviio.library.local.metadata.AudioMetadata;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.serviio.library.local.metadata.extractor.embedded.AudioExtractionStrategy;

public class MP4ExtractionStrategy : AudioExtractionStrategy
{
    override public void extractMetadata(AudioMetadata metadata, AudioFile f, AudioHeader header, Tag tag)
    {
        if ((f.getAudioHeader() !is null) && 
            (!f.getAudioHeader().getEncodingType().equalsIgnoreCase("AAC"))) {
                throw new InvalidMediaFormatException(java.lang.String.format("MP4 file '%s' has unsupported codec (%s)", cast(Object[])[ f.getFile(), f.getAudioHeader().getEncodingType() ]));
            }
        super.extractMetadata(metadata, f, header, tag);
    }

    override protected AudioContainer getContainer()
    {
        return AudioContainer.MP4;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.MP4ExtractionStrategy
* JD-Core Version:    0.7.0.1
*/