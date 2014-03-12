module org.serviio.delivery.subtitles.EmbeddedSubtitlesReader;

import java.lang;
import java.io.File;
import java.io.IOException;
import org.serviio.delivery.resource.transcode.AbstractTranscodingDeliveryEngine;
import org.serviio.dlna.SubtitleCodec;
import org.serviio.external.FFMPEGWrapper;
import org.serviio.library.entities.Video;
import org.serviio.library.local.EmbeddedSubtitles;
import org.serviio.util.FileUtils;
import org.serviio.delivery.subtitles.SubtitlesReader;
import org.serviio.delivery.subtitles.HardSubs;

public class EmbeddedSubtitlesReader : SubtitlesReader
{
    private EmbeddedSubtitles embeddedSubtitles;
    private Video video;

    public this(Video video, EmbeddedSubtitles embeddedSubtitles)
    {
        this.embeddedSubtitles = embeddedSubtitles;
        this.video = video;
    }

    public Long getExpectedSubtitlesSize()
    {
        return null;
    }

    public SubtitleCodec getSubtitleCodec()
    {
        return this.embeddedSubtitles.getCodec();
    }

    public byte[] getSubtitlesAsSRT()
    {
        return FFMPEGWrapper.extractSubtitleFileAsSRT(this.video, this.embeddedSubtitles);
    }

    public HardSubs getSubtitlesInOriginalFormat()
    {
        return new HardSubs(FileUtils.getProperFilePath(FFMPEGWrapper.extractSubtitleFile(this.video, this.embeddedSubtitles, createTargetSubtitlesFilename())));
    }

    private String createTargetSubtitlesFilename()
    {
        return FileUtils.getProperFilePath(new File(AbstractTranscodingDeliveryEngine.getTranscodingFolder(), String.format("subtitles_%s_%s", cast(Object[])[ this.video.getId(), this.embeddedSubtitles.getStreamId() ])));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.subtitles.EmbeddedSubtitlesReader
* JD-Core Version:    0.7.0.1
*/