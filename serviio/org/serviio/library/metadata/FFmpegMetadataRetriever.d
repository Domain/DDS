module org.serviio.library.metadata.FFmpegMetadataRetriever;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.delivery.DeliveryContext;
import org.serviio.dlna.AudioCodec;
import org.serviio.dlna.AudioContainer;
import org.serviio.dlna.SourceAspectRatio;
import org.serviio.dlna.SubtitleCodec;
import org.serviio.dlna.VideoCodec;
import org.serviio.dlna.VideoContainer;
import org.serviio.external.FFMPEGWrapper;
import org.serviio.library.local.EmbeddedSubtitles;
import org.serviio.library.local.H264LevelType;
import org.serviio.library.local.metadata.AudioMetadata;
import org.serviio.library.local.metadata.VideoMetadata;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.serviio.library.local.metadata.extractor.embedded.AVCHeader;
import org.serviio.util.DateUtils;
import org.serviio.util.MediaUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.serviio.util.Tupple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FFmpegMetadataRetriever
{
    private static final Logger log = LoggerFactory.getLogger!(FFmpegMetadataRetriever);
    private static final Pattern streamIndexPattern = Pattern.compile("#[\\d][\\.:]([\\d]{1,2})(\\((\\w+)\\))?");
    private static immutable String CONTAINER = "container";
    private static immutable String DURATION = "duration";
    private static immutable String BITRATE = "bitrate";
    private static immutable String VIDEO_CODEC = "video_codec";
    private static immutable String VIDEO_FOURCC = "video_fourcc";
    private static immutable String VIDEO_STREAM_INDEX = "video_stream_index";
    private static immutable String WIDTH = "width";
    private static immutable String HEIGHT = "height";
    private static immutable String VIDEO_BITRATE = "video_bitrate";
    private static immutable String FPS = "fps";
    private static immutable String AUDIO_CODEC = "audio_codec";
    private static immutable String AUDIO_STREAM_INDEX = "audio_stream_index";
    private static immutable String CHANNELS = "channels";
    private static immutable String FREQUENCY = "frequency";
    private static immutable String AUDIO_BITRATE = "audio_bitrate";
    private static immutable String FTYP = "ftyp";
    private static immutable String SAR = "sar";
    private static immutable String EMBEDDED_SUBTITLES = "embedded_subtitles";
    private static immutable String TOKEN_STREAM = "Stream";
    private static final Map!(String, Integer) maxDpbMbs = new LinkedHashMap();

    static this()
    {
        prepareMaxDpbMbs();
    }

    public static void retrieveMetadata(VideoMetadata metadata, String filePath, DeliveryContext context)
    {
        List!(String) mediaDescription = FFMPEGWrapper.readMediaFileInformation(filePath, context);
        updateMetadata(metadata, mediaDescription, filePath);


        validateMandatoryMetadata(metadata);


        getProfileForH264(metadata, filePath, context);
    }

    public static void retrieveAudioMetadata(AudioMetadata metadata, String filePath, DeliveryContext context)
    {
        List!(String) mediaDescription = FFMPEGWrapper.readMediaFileInformation(filePath, context);
        updateMetadata(metadata, mediaDescription);


        validateCodecsFound(metadata);
    }

    public static void retrieveOnlineMetadata(ItemMetadata md, String contentUrl, DeliveryContext context)
    {
        if (( cast(VideoMetadata)md !is null )) {
            retrieveMetadata(cast(VideoMetadata)md, contentUrl, context);
        } else {
            retrieveAudioMetadata(cast(AudioMetadata)md, contentUrl, context);
        }
    }

    private static Map!(String, Object) getParametersMap(List!(String) ffmpegMediaDescription)
    {
        Map!(String, Object) parameters = new HashMap();

        String container = null;

        List!(EmbeddedSubtitles) subtitlesList = new ArrayList();
        foreach (String line ; ffmpegMediaDescription)
        {
            line = line.trim();
            int inputPos = line.indexOf("Input #0");
            if (inputPos > -1) {
                container = line.substring(inputPos + 10, line.indexOf(",", inputPos + 11)).trim();
            }
            if (container !is null)
            {
                parameters.put("container", container);
                if (line.indexOf("major_brand") > -1)
                {
                    String[] tokens = line.split(":");
                    parameters.put("ftyp", tokens[1].trim());
                }
                else if (line.indexOf("Duration") > -1)
                {
                    String[] tokens = line.split(",");
                    foreach (String token ; tokens)
                    {
                        token = token.trim();
                        if (token.startsWith("Duration: "))
                        {
                            String duration = token.substring(10);
                            if (duration.indexOf("N/A") == -1) {
                                parameters.put("duration", DateUtils.timeToSeconds(duration));
                            }
                        }
                        else if (token.startsWith("bitrate: "))
                        {
                            String bitrateStr = token.substring(9);
                            int spacepos = bitrateStr.indexOf(" ");
                            if (spacepos > -1)
                            {
                                String value = bitrateStr.substring(0, spacepos);
                                String unit = bitrateStr.substring(spacepos + 1);
                                Integer bitrate = Integer.valueOf(Integer.parseInt(value));
                                if (unit.equals("mb/s")) {
                                    bitrate = Integer.valueOf(1024 * bitrate.intValue());
                                }
                                parameters.put("bitrate", bitrate);
                            }
                        }
                    }
                }
                else if ((line.startsWith("Stream")) && (line.indexOf("Video:") > -1) && (parameters.get("video_codec") is null))
                {
                    String beforeVideo = line.substring(0, line.indexOf("Video:"));
                    String afterVideo = line.substring(beforeVideo.length());
                    String[] beforeVideoTokens = beforeVideo.split(",");
                    String[] afterVideoTokens = afterVideo.split(",");
                    foreach (String token ; beforeVideoTokens)
                    {
                        token = token.trim();
                        if (token.startsWith("Stream")) {
                            parameters.put("video_stream_index", getStreamIndex(token));
                        }
                    }
                    foreach (String token ; afterVideoTokens)
                    {
                        token = token.trim();
                        if (token.startsWith("Video:"))
                        {
                            parameters.put("video_codec", getVideoCodec(token));
                            parameters.put("video_fourcc", getVideoFourCC(token));
                        }
                        else if (token.indexOf("x") > -1)
                        {
                            String resolution = token.trim();
                            int aspectStart = resolution.indexOf(" [");
                            if (aspectStart > -1)
                            {
                                String aspectDef = resolution.substring(aspectStart + 2, resolution.indexOf("]"));
                                parameters.put("sar", getSar(aspectDef));
                                resolution = resolution.substring(0, aspectStart);
                            }
                            try
                            {
                                parameters.put("width", Integer.valueOf(Integer.parseInt(resolution.substring(0, resolution.indexOf("x")))));
                                parameters.put("height", Integer.valueOf(Integer.parseInt(resolution.substring(resolution.indexOf("x") + 1))));
                            }
                            catch (NumberFormatException nfe) {}
                        }
                        else if ((token.indexOf("SAR") > -1) || (token.indexOf("PAR") > -1))
                        {
                            parameters.put("sar", getSar(token));
                        }
                        else if (token.indexOf("kb/s") > -1)
                        {
                            parameters.put("video_bitrate", Integer.valueOf(Integer.parseInt(token.substring(0, token.indexOf("kb/s")).trim())));
                        }
                        else if (token.indexOf("mb/s") > -1)
                        {
                            parameters.put("video_bitrate", Integer.valueOf(Integer.parseInt(token.substring(0, token.indexOf("mb/s")).trim()) * 1024));
                        }
                        else if (token.indexOf("tbr") > -1)
                        {
                            String tbrValue = token.substring(0, token.indexOf("tbr")).trim();
                            parameters.put("fps", getFps(tbrValue));
                        }
                        else if ((token.indexOf("fps") > -1) && (parameters.get("fps") is null))
                        {
                            String fpsValue = token.substring(0, token.indexOf("fps")).trim();
                            parameters.put("fps", getFps(fpsValue));
                        }
                    }
                }
                else if ((line.startsWith("Stream")) && (line.indexOf("Audio:") > -1) && (parameters.get("audio_codec") is null))
                {
                    String[] tokens = line.split(",");
                    foreach (String token ; tokens)
                    {
                        token = token.trim();
                        if (token.startsWith("Stream"))
                        {
                            parameters.put("audio_codec", getAudioCodec(token));
                            parameters.put("audio_stream_index", getStreamIndex(token));
                        }
                        else if (token.indexOf("channels") > -1)
                        {
                            parameters.put("channels", Integer.valueOf(Integer.parseInt(token.substring(0, token.indexOf("channels")).trim())));
                        }
                        else if (token.indexOf("stereo") > -1)
                        {
                            parameters.put("channels", Integer.valueOf(2));
                        }
                        else if (token.indexOf("5.1") > -1)
                        {
                            parameters.put("channels", Integer.valueOf(6));
                        }
                        else if (token.indexOf("7.1") > -1)
                        {
                            parameters.put("channels", Integer.valueOf(8));
                        }
                        else if (token.indexOf("mono") > -1)
                        {
                            parameters.put("channels", Integer.valueOf(1));
                        }
                        else if (token.indexOf("Hz") > -1)
                        {
                            parameters.put("frequency", Integer.valueOf(Integer.parseInt(token.substring(0, token.indexOf("Hz")).trim())));
                        }
                        else if (token.indexOf("kb/s") > -1)
                        {
                            parameters.put("audio_bitrate", Integer.valueOf(Integer.parseInt(token.substring(0, token.indexOf("kb/s")).trim())));
                        }
                        else if (token.indexOf("mb/s") > -1)
                        {
                            parameters.put("audio_bitrate", Integer.valueOf(Integer.parseInt(token.substring(0, token.indexOf("mb/s")).trim()) * 1024));
                        }
                    }
                }
                else if ((line.startsWith("Stream")) && (line.indexOf("Subtitle:") > -1))
                {
                    String sCodecName = getSubtitleCodec(line);
                    SubtitleCodec sCodec = SubtitleCodec.getByFFmpegValue(sCodecName);
                    if (sCodec !is null)
                    {
                        Tupple!(Integer, String) streamInfo = getStreamIndex(line);
                        bool defaultLanguage = line.indexOf("(default)") > -1;
                        subtitlesList.add(new EmbeddedSubtitles(cast(Integer)streamInfo.getValueA(), sCodec, cast(String)streamInfo.getValueB(), defaultLanguage));
                    }
                }
            }
        }
        parameters.put("embedded_subtitles", subtitlesList);
        return parameters;
    }

    protected static void updateMetadata(VideoMetadata metadata, List!(String) ffmpegMediaDescription, String filePath)
    {
        Map!(String, Object) parameters = getParametersMap(ffmpegMediaDescription);
        Tupple!(Integer, String) audioStreamInfo = cast(Tupple)parameters.get("audio_stream_index");
        Tupple!(Integer, String) videoStreamInfo = cast(Tupple)parameters.get("video_stream_index");
        metadata.setAudioBitrate(cast(Integer)parameters.get("audio_bitrate"));
        metadata.setAudioCodec(AudioCodec.getByFFmpegDecoderName(cast(String)parameters.get("audio_codec")));
        metadata.setAudioStreamIndex(audioStreamInfo !is null ? cast(Integer)audioStreamInfo.getValueA() : null);
        metadata.setBitrate(cast(Integer)parameters.get("bitrate"));
        metadata.setChannels(cast(Integer)parameters.get("channels"));
        metadata.setContainer(VideoContainer.getByFFmpegValue(cast(String)parameters.get("container"), filePath));
        metadata.setDuration(cast(Integer)parameters.get("duration"));
        metadata.setFps(cast(String)parameters.get("fps"));
        metadata.setFrequency(cast(Integer)parameters.get("frequency"));
        metadata.setHeight(cast(Integer)parameters.get("height"));
        metadata.setVideoBitrate(cast(Integer)parameters.get("video_bitrate"));
        metadata.setVideoCodec(VideoCodec.getByFFmpegValue(cast(String)parameters.get("video_codec")));
        metadata.setVideoStreamIndex(videoStreamInfo !is null ? cast(Integer)videoStreamInfo.getValueA() : null);
        metadata.setVideoFourCC(cast(String)parameters.get("video_fourcc"));
        metadata.setWidth(cast(Integer)parameters.get("width"));
        metadata.setFtyp(cast(String)parameters.get("ftyp"));
        metadata.setSar(new SourceAspectRatio(cast(String)parameters.get("sar")));
        metadata.getEmbeddedSubtitles().addAll(cast(List)parameters.get("embedded_subtitles"));
    }

    protected static void updateMetadata(AudioMetadata metadata, List!(String) ffmpegMediaDescription)
    {
        Map!(String, Object) parameters = getParametersMap(ffmpegMediaDescription);
        metadata.setBitrate(cast(Integer)parameters.get("bitrate"));
        metadata.setChannels(cast(Integer)parameters.get("channels"));
        metadata.setContainer(AudioContainer.getByName(cast(String)parameters.get("audio_codec")));
        metadata.setDuration(cast(Integer)parameters.get("duration"));
        metadata.setSampleFrequency(cast(Integer)parameters.get("frequency"));
    }

    protected static String getFps(String fpsValue)
    {
        if (fpsValue.indexOf("k") > -1) {
            fpsValue = fpsValue.replaceFirst("k", "000");
        }
        return MediaUtils.getValidFps(fpsValue);
    }

    protected static String getSar(String aspectDef)
    {
        int sarIndex = aspectDef.indexOf("SAR");
        if (sarIndex < 0) {
            sarIndex = aspectDef.indexOf("PAR");
        }
        if (sarIndex > -1)
        {
            aspectDef = aspectDef.substring(sarIndex + 4);
            String sar = aspectDef.substring(0, aspectDef.indexOf(" "));
            return sar;
        }
        return null;
    }

    protected static String getVideoCodec(String token)
    {
        String codecValue = token.substring(token.indexOf("Video: ") + 7).split(" ")[0];
        if ((codecValue !is null) && (codecValue.startsWith("drm"))) {
            throw new InvalidMediaFormatException("File is DRM protected");
        }
        return codecValue;
    }

    protected static String getVideoFourCC(String token)
    {
        if (token.indexOf("(") > -1)
        {
            String fourCCBlock = token.substring(token.lastIndexOf("(") + 1, token.lastIndexOf(")"));
            if (fourCCBlock.indexOf("/") > -1)
            {
                String fourCC = StringUtils.localeSafeToLowercase(fourCCBlock.split("/")[0].trim());
                if (fourCC.indexOf("[") == -1) {
                    return fourCC;
                }
            }
        }
        return null;
    }

    protected static String getAudioCodec(String token)
    {
        String codecValue = token.substring(token.indexOf("Audio: ") + 7).split(" ")[0];
        return codecValue;
    }

    protected static String getSubtitleCodec(String token)
    {
        String codecValue = token.substring(token.indexOf("Subtitle: ") + 10).split(" ")[0];
        return codecValue;
    }

    protected static Tupple!(Integer, String) getStreamIndex(String token)
    {
        Matcher m = streamIndexPattern.matcher(token);
        if (m.find()) {
            return new Tupple(Integer.valueOf(Integer.parseInt(m.group(1))), m.groupCount() == 3 ? m.group(3) : null);
        }
        return null;
    }

    protected static void validateMandatoryMetadata(VideoMetadata metadata)
    {
        if (metadata.getContainer() is null) {
            throw new InvalidMediaFormatException("Unknown video file type.");
        }
        if (metadata.getVideoCodec() is null) {
            throw new InvalidMediaFormatException("Unknown video codec.");
        }
        if (metadata.getWidth() is null) {
            throw new InvalidMediaFormatException("Unknown video width.");
        }
        if (metadata.getHeight() is null) {
            throw new InvalidMediaFormatException("Unknown video height.");
        }
    }

    protected static void validateCodecsFound(AudioMetadata metadata)
    {
        if (metadata.getContainer() is null) {
            throw new InvalidMediaFormatException("Unknown audio file type.");
        }
    }

    private static void getProfileForH264(VideoMetadata metadata, String filePath, DeliveryContext context)
    {
        if (metadata.getVideoCodec() == VideoCodec.H264) {
            try
            {
                log.debug_(String.format("Retrieving H264 profile/level for file '%s'", cast(Object[])[ filePath ]));
                byte[] h264Stream = FFMPEGWrapper.readH264AnnexBHeader(filePath, metadata.getContainer(), context);
                AVCHeader avcHeader = parseH264Header(h264Stream);
                if (avcHeader !is null)
                {
                    metadata.setH264Profile(avcHeader.getProfile());
                    String refFramesLevel = getAndValidateH264LevelBasedOnRefFrames(avcHeader.getRefFrames(), metadata.getWidth(), metadata.getHeight());
                    if (ObjectValidator.isNotEmpty(avcHeader.getLevel())) {
                        metadata.getH264Levels().put(H264LevelType.H, avcHeader.getLevel());
                    }
                    if (ObjectValidator.isNotEmpty(refFramesLevel)) {
                        metadata.getH264Levels().put(H264LevelType.RF, refFramesLevel);
                    }
                    log.debug_(String.format("File '%s' has H264 profile %s, levels [%s] and %s ref frames", cast(Object[])[ filePath, metadata.getH264Profile(), metadata.getH264Levels(), avcHeader.getRefFrames() ]));
                }
                else
                {
                    log.warn(String.format("Couldn't resolve H264 profile/level/ref_frames for file '%s' because the header was not recognized", cast(Object[])[ filePath ]));
                }
            }
            catch (Exception e)
            {
                log.warn(String.format("Failed to retrieve H264 profile/level/ref_frames information for file '%s': %s", cast(Object[])[ filePath, e.getMessage() ]));
            }
        }
    }

    protected static AVCHeader parseH264Header(byte[] h264Stream)
    {
        try
        {
            AVCHeader avcHeader = new AVCHeader(h264Stream);
            avcHeader.parse();
            return avcHeader;
        }
        catch (Throwable e)
        {
            log.debug_("AVC Header parse error: " + e.getMessage());
        }
        return null;
    }

    protected static String getAndValidateH264LevelBasedOnRefFrames(Integer refFrames, Integer width, Integer height)
    {
        if ((width !is null) && (height !is null) && (width.intValue() > 0) && (height.intValue() > 0) && (refFrames !is null) && (refFrames.intValue() > 0))
        {
            Integer dpbMbs = Integer.valueOf(width.intValue() * height.intValue() * refFrames.intValue() / 256);

            String level = null;
            foreach (Map.Entry!(String, Integer) levelDbp ; maxDpbMbs.entrySet())
            {
                level = cast(String)levelDbp.getKey();
                if ((cast(Integer)levelDbp.getValue()).intValue() > dpbMbs.intValue()) {
                    return level;
                }
            }
            return level;
        }
        return null;
    }

    private static void prepareMaxDpbMbs()
    {
        maxDpbMbs.put("1", Integer.valueOf(396));
        maxDpbMbs.put("1.1", Integer.valueOf(396));
        maxDpbMbs.put("1.2", Integer.valueOf(900));
        maxDpbMbs.put("1.3", Integer.valueOf(2376));
        maxDpbMbs.put("2", Integer.valueOf(2376));
        maxDpbMbs.put("2.1", Integer.valueOf(4752));
        maxDpbMbs.put("2.2", Integer.valueOf(8100));
        maxDpbMbs.put("3", Integer.valueOf(8100));
        maxDpbMbs.put("3.1", Integer.valueOf(18000));
        maxDpbMbs.put("3.2", Integer.valueOf(20480));
        maxDpbMbs.put("4", Integer.valueOf(32768));
        maxDpbMbs.put("4.1", Integer.valueOf(32768));
        maxDpbMbs.put("4.2", Integer.valueOf(34816));
        maxDpbMbs.put("5", Integer.valueOf(110400));
        maxDpbMbs.put("5.1", Integer.valueOf(184320));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.metadata.FFmpegMetadataRetriever
* JD-Core Version:    0.7.0.1
*/