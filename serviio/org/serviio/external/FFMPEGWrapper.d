module org.serviio.external.FFMPEGWrapper;

import java.lang;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map:Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.ApplicationSettings;
import org.serviio.config.Configuration;
import org.serviio.delivery.DeliveryContext;
import org.serviio.delivery.resource.transcode.AudioTranscodingDefinition;
import org.serviio.delivery.resource.transcode.TranscodingDefinition;
import org.serviio.delivery.resource.transcode.TranscodingJobListener;
import org.serviio.delivery.resource.transcode.VideoTranscodingDefinition;
import org.serviio.delivery.subtitles.HardSubs;
import org.serviio.dlna.AudioCodec;
import org.serviio.dlna.AudioContainer;
import org.serviio.dlna.DisplayAspectRatio;
import org.serviio.dlna.SourceAspectRatio;
import org.serviio.dlna.SubtitleCodec;
import org.serviio.dlna.VideoCodec;
import org.serviio.dlna.VideoContainer;
import org.serviio.library.entities.MediaItem;
import org.serviio.library.entities.MusicTrack;
import org.serviio.library.entities.Video;
import org.serviio.library.local.EmbeddedSubtitles;
import org.serviio.library.local.service.MediaService;
import org.serviio.util.CollectionUtils;
import org.serviio.util.FileUtils;
import org.serviio.util.MediaUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.Platform;
import org.serviio.util.ThreadUtils;
import org.serviio.util.Tupple;
import org.serviio.external.AbstractExecutableWrapper;
import org.serviio.external.FFmpegCLBuilder;
import org.serviio.external.ProcessExecutorParameter;
import org.serviio.external.ResizeDefinition;
import org.serviio.external.ProcessExecutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FFMPEGWrapper : AbstractExecutableWrapper
{
    public static immutable String THREADS_AUTO = "auto";
    public static immutable String SEGMENT_PLAYLIST_FILE_NAME;
    private static Integer thumbnailSeekPosition;
    private static Integer defaultAudioBitrate;
    private static immutable String videoQualityFactor;
    private static immutable String x264VideoQualityFactor;
    private static immutable String segmentSizeInSeconds;
    private static immutable String segmentNumberForLiveStreams;
    private static Logger log;
    private static immutable int DEFAULT_AUDIO_FREQUENCY = 48000;
    private static immutable int MIN_AUDIO_FREQUENCY = 44100;
    private static immutable int RTMP_BUFFER_SIZE = 100000000;
    private static immutable long LOCAL_FILE_TIMEOUT = 30000L;
    private static immutable long DEFAULT_ONLINE_FILE_TIMEOUT = 60000L;
    private static List!(Integer) validAudioBitrates;
    private static String ffmpegUserAgent;
    private static Map!(AudioCodec, Integer) maxChannelNumber;
    private static Map!(String, String) stringEncoding;
    private static Map!(String, String) windowsStringEncoding;

    static this()
    {
        SEGMENT_PLAYLIST_FILE_NAME = ApplicationSettings.getStringProperty("hls_playlist_file_name");
        thumbnailSeekPosition = ApplicationSettings.getIntegerProperty("video_thumbnail_seek_position");
        defaultAudioBitrate = ApplicationSettings.getIntegerProperty("transcoding_default_audio_bitrate");
        videoQualityFactor = ApplicationSettings.getStringProperty("transcoding_quality_factor");
        x264VideoQualityFactor = ApplicationSettings.getStringProperty("x264_transcoding_quality_factor");
        segmentSizeInSeconds = ApplicationSettings.getStringProperty("hls_segment_size");
        segmentNumberForLiveStreams = ApplicationSettings.getStringProperty("hls_live_segment_number");
        log = LoggerFactory.getLogger!(FFMPEGWrapper);
        validAudioBitrates = Arrays.asList(cast(Integer[])[ Integer.valueOf(32), Integer.valueOf(48), Integer.valueOf(56), Integer.valueOf(64), Integer.valueOf(80), Integer.valueOf(96), Integer.valueOf(112), Integer.valueOf(128), Integer.valueOf(160), Integer.valueOf(192), Integer.valueOf(224), Integer.valueOf(256), Integer.valueOf(320), Integer.valueOf(384), Integer.valueOf(448), Integer.valueOf(512), Integer.valueOf(576), Integer.valueOf(640) ]);
        setupMaxChannelsMap();
        setupStringEncodingMap();
    }

    public static bool ffmpegPresent()
    {
        FFmpegCLBuilder builder = new FFmpegCLBuilder();

        log.debug_(java.lang.String.format("Invoking FFMPEG to check if it exists of path %s", cast(Object[])[ FFmpegCLBuilder.executablePath ]));
        ProcessExecutor executor = new ProcessExecutor(builder.build(), false);
        executeSynchronously(executor);
        bool success = (executor.isSuccess()) && (executor.getResults().size() > 5);
        if (success)
        {
            log.info(java.lang.String.format("Found FFmpeg: %s", cast(Object[])[ executor.getResults().get(0) ]));
            String ffmpegOutput = CollectionUtils.listToCSV(executor.getResults(), "", false);
            if (ffmpegOutput.indexOf("--enable-librtmp") == -1) {
                log.warn("FFmpeg is not compiled with librtmp support, RTMP streaming will not work.");
            }
            if (ffmpegOutput.indexOf("--enable-libass") == -1)
            {
                log.warn("FFmpeg is not compiled with libass support, rendering subtitles (hardsubs) will not work.");
                Configuration.setHardSubsEnabled(false);
            }
            ffmpegUserAgent = getUserAgent(ffmpegOutput);
        }
        return success;
    }

    public static List!(String) readMediaFileInformation(String filePath, DeliveryContext context)
    {
        FFmpegCLBuilder builder = new FFmpegCLBuilder();

        addInputFileOptions(filePath, context, builder);
        builder.inFile(fixFilePath(filePath, context.isLocalContent()));

        log.debug_(java.lang.String.format("Invoking FFMPEG to retrieve media information for file: %s", cast(Object[])[ filePath ]));
        ProcessExecutor executor = new ProcessExecutor(builder.build(), false, Long.valueOf(context.isLocalContent() ? LOCAL_FILE_TIMEOUT : onlineItemTimeout()));

        executeSynchronously(executor);
        return executor.getResults();
    }

    public static byte[] readVideoThumbnail(File f, Integer videoLength, VideoCodec vCodec, VideoContainer vContainer)
    {
        FFmpegCLBuilder builder = new FFmpegCLBuilder();
        builder.inFile(java.lang.String.format("%s", cast(Object[])[ f.getAbsolutePath() ]));
        builder.inFileOptions(cast(String[])[ "-threads", Configuration.getTranscodingThreads() ]);



        addTimePosition(videoLength, (vCodec != VideoCodec.MPEG2) && (vContainer != VideoContainer.MPEG2TS), builder);
        builder.outFileOptions(cast(String[])[ "-an", "-frames:v", "1", "-f", "image2" ]).outFile("pipe:");

        log.debug_(java.lang.String.format("Invoking FFMPEG to retrieve thumbnail for file: %s", cast(Object[])[ f.getAbsolutePath() ]));
        ProcessExecutor executor = new ProcessExecutor(builder.build(), false, new Long(160000L));
        executeSynchronously(executor);
        ByteArrayOutputStream output = cast(ByteArrayOutputStream)executor.getOutputStream();
        if (output !is null) {
            return output.toByteArray();
        }
        return null;
    }

    public static byte[] transcodeSubtitleFileToSRT(File f)
    {
        FFmpegCLBuilder builder = new FFmpegCLBuilder();

        builder.inFileOptions(cast(String[])[ "-sub_charenc", Configuration.getSubsCharacterEncoding() ]);
        builder.inFile(java.lang.String.format("%s", cast(Object[])[ f.getAbsolutePath() ]));

        builder.outFileOptions(cast(String[])[ "-an", "-vn", "-c:s", SubtitleCodec.SRT.getFFmpegEncoderName(), "-f", SubtitleCodec.SRT.getFFmpegEncoderName() ]).outFile("pipe:");


        log.debug_(java.lang.String.format("Invoking FFMPEG to convert subtitle file: %s", cast(Object[])[ f.getAbsolutePath() ]));
        ProcessExecutor executor = new ProcessExecutor(builder.build(), false, new Long(30000L));
        executeSynchronously(executor);
        ByteArrayOutputStream output = cast(ByteArrayOutputStream)executor.getOutputStream();
        if (output !is null) {
            return output.toByteArray();
        }
        return null;
    }

    public static File extractSubtitleFile(Video video, EmbeddedSubtitles subtitle, String targetFilePath)
    {
        String subtitleFormat = subtitle.getCodec().getFFmpegEncoderName();
        String subtitleEncoder = "copy";
        String subtitleExtension = "";
        if (subtitleFormat is null)
        {
            subtitleEncoder = SubtitleCodec.ASS.getFFmpegEncoderName();
            subtitleFormat = SubtitleCodec.ASS.getFFmpegEncoderName();
            subtitleExtension = cast(String)SubtitleCodec.ASS.getFileExtensions().get(0);
        }
        else
        {
            subtitleExtension = cast(String)subtitle.getCodec().getFileExtensions().get(0);
        }
        FFmpegCLBuilder builder = prepareCommandForSubtitleExtraction(video, subtitle, subtitleEncoder, subtitleFormat);

        File targetFile = new File(targetFilePath ~ "." ~ subtitleExtension);
        builder.outFile(getOutputFile(targetFile));

        log.debug_(java.lang.String.format("Invoking FFMPEG to extract subtitle file from: %s", cast(Object[])[ video.getFileName() ]));
        ProcessExecutor executor = new ProcessExecutor(builder.build(), false, new Long(30000L));
        executeSynchronously(executor);
        if ((targetFile.exists()) && (targetFile.length() > 0L)) {
            return targetFile;
        }
        throw new IOException(java.lang.String.format("Could not extract subtitle from file %s", cast(Object[])[ video.getFileName() ]));
    }

    public static byte[] extractSubtitleFileAsSRT(Video video, EmbeddedSubtitles subtitle)
    {
        FFmpegCLBuilder builder = prepareCommandForSubtitleExtraction(video, subtitle, SubtitleCodec.SRT.getFFmpegEncoderName(), SubtitleCodec.SRT.getFFmpegEncoderName());

        builder.outFile(getOutputFile(null));

        log.debug_(java.lang.String.format("Invoking FFMPEG to extract SRT subtitle file from: %s", cast(Object[])[ video.getFileName() ]));
        ProcessExecutor executor = new ProcessExecutor(builder.build(), false, new Long(30000L));
        executeSynchronously(executor);
        ByteArrayOutputStream output = cast(ByteArrayOutputStream)executor.getOutputStream();
        if (output !is null) {
            return output.toByteArray();
        }
        throw new IOException(java.lang.String.format("Could not extract SRT subtitle from file %s", cast(Object[])[ video.getFileName() ]));
    }

    public static byte[] readH264AnnexBHeader(String filePath, VideoContainer container, DeliveryContext context)
    {
        FFmpegCLBuilder builder = new FFmpegCLBuilder();

        addInputFileOptions(filePath, context, builder);
        builder.inFile(java.lang.String.format("%s", cast(Object[])[ fixFilePath(filePath, context.isLocalContent()) ]));
        builder.outFileOptions(cast(String[])[ "-frames:v", "1", "-c:v", "copy", "-f", "h264" ]);
        if (!isMpegTSbasedContainer(container)) {
            builder.outFileOptions(cast(String[])[ "-bsf:v", "h264_mp4toannexb" ]);
        }
        builder.outFileOptions(cast(String[])[ "-an" ]);
        builder.outFile("pipe:");

        log.debug_(java.lang.String.format("Invoking FFMPEG to retrieve H264 header for file: %s", cast(Object[])[ filePath ]));
        ProcessExecutor executor = new ProcessExecutor(builder.build(), false, Long.valueOf(context.isLocalContent() ? LOCAL_FILE_TIMEOUT : onlineItemTimeout()));

        executeSynchronously(executor);
        ByteArrayOutputStream output = cast(ByteArrayOutputStream)executor.getOutputStream();
        if (output !is null) {
            return output.toByteArray();
        }
        return null;
    }

    public static OutputStream transcodeFile(MediaItem mediaItem, File tmpFile, TranscodingDefinition tDef, TranscodingJobListener listener, Double timeOffset, Double timeDuration)
    {
        if (( cast(Video)mediaItem !is null )) {
            return transcodeVideoFile(cast(Video)mediaItem, tmpFile, cast(VideoTranscodingDefinition)tDef, listener, timeOffset, timeDuration);
        }
        if (( cast(MusicTrack)mediaItem !is null )) {
            return transcodeAudioFile(cast(MusicTrack)mediaItem, tmpFile, cast(AudioTranscodingDefinition)tDef, listener, timeOffset, timeDuration);
        }
        return null;
    }

    public static String getFFmpegUserAgent()
    {
        return ffmpegUserAgent;
    }

    protected static String prepareOnlineContentUrl(String url)
    {
        if (url.startsWith("mms://")) {
            return url.replaceFirst("mms://", "mmsh://");
        }
        return url;
    }

    private static FFmpegCLBuilder prepareCommandForSubtitleExtraction(Video video, EmbeddedSubtitles subtitle, String subtitleEncoder, String subtitleFormat)
    {
        String sourceFileName = getFilePathForTranscoding(video);
        FFmpegCLBuilder builder = buildBasicTranscodingParameters(sourceFileName, video.getDeliveryContext());
        builder.outFileOptions(cast(String[])[ "-an", "-vn", "-map", "0:" ~ subtitle.getStreamId().toString(), "-c:s", subtitleEncoder, "-f", subtitleFormat ]);

        return builder;
    }

    private static void addTimePosition(Integer videoLength, bool inputOption, FFmpegCLBuilder builder)
    {
        Integer thumbnailPosition = null;
        if ((videoLength !is null) && (videoLength.intValue() < thumbnailSeekPosition.intValue())) {
            thumbnailPosition = Integer.valueOf(videoLength.intValue() / 2);
        } else {
            thumbnailPosition = thumbnailSeekPosition;
        }
        if (inputOption)
        {
            builder.inFileOptions(cast(String[])[ "-ss", Integer.toString(thumbnailPosition.intValue()) ]);
        }
        else
        {
            builder.inFileOptions(cast(String[])[ "-ss", Integer.toString(thumbnailPosition.intValue() - 1) ]);
            builder.outFileOptions(cast(String[])[ "-ss", "1" ]);
        }
    }

    private static OutputStream transcodeVideoFile(Video mediaItem, File tmpFile, VideoTranscodingDefinition tDef, TranscodingJobListener listener, Double timeOffset, Double timeDuration)
    {
        String sourceFileName = getFilePathForTranscoding(mediaItem);
        FFmpegCLBuilder builder = buildBasicTranscodingParameters(sourceFileName, mediaItem.getDeliveryContext());

        addTranscodingThreads(builder);
        addTimeConstraintParameters(timeOffset, timeDuration, mediaItem.getDuration(), builder);
        addVideoParameters(mediaItem, tDef, mediaItem.getDeliveryContext().getHardsubsSubtitlesFile(), builder);
        addAudioParameters(mediaItem, tDef, builder);
        mapStreams(mediaItem, builder);

        builder.outFileOptions(cast(String[])[ "-sn" ]);
        addTargetVideoFormatAndOutputFile(builder, tDef, tmpFile, mediaItem.isLive());

        log.debug_(java.lang.String.format("Invoking FFmpeg to transcode video file: %s", cast(Object[])[ sourceFileName ]));
        return executeTranscodingProcess(tmpFile, listener, builder.build());
    }

    private static void addTranscodingThreads(FFmpegCLBuilder builder)
    {
        builder.inFileOptions(cast(String[])[ "-threads", Configuration.getTranscodingThreads() ]);
        builder.outFileOptions(cast(String[])[ "-threads", Configuration.getTranscodingThreads() ]);
    }

    private static File addTargetVideoFormatAndOutputFile(FFmpegCLBuilder builder, VideoTranscodingDefinition tDef, File tmpFile, bool live)
    {
        builder.outFileOptions(cast(String[])[ "-f", tDef.getTargetContainer().getFFmpegValue() ]);
        if (tDef.getTargetContainer().isSegmentBased())
        {
            String segmentsFileName = FileUtils.getProperFilePath(tmpFile);
            String segmentFileTemplate = FileUtils.getProperFilePath(new File(tmpFile.getParentFile(), "segment%05d.ts"));

            builder.outFileOptions(cast(String[])[ "-segment_time", segmentSizeInSeconds, "-segment_format", VideoContainer.MPEG2TS.getFFmpegValue(), "-segment_list_flags", live ? "live" : "cache", "-segment_list", segmentsFileName ]);
            if (live) {
                builder.outFileOptions(cast(String[])[ "-segment_list_size", segmentNumberForLiveStreams ]);
            }
            builder.outFile(segmentFileTemplate);
            return tmpFile;
        }
        builder.outFile(getOutputFile(tmpFile));
        return tmpFile;
    }

    private static OutputStream transcodeAudioFile(MusicTrack mediaItem, File tmpFile, AudioTranscodingDefinition tDef, TranscodingJobListener listener, Double timeOffset, Double timeDuration)
    {
        String sourceFileName = getFilePathForTranscoding(mediaItem);
        FFmpegCLBuilder builder = buildBasicTranscodingParameters(sourceFileName, mediaItem.getDeliveryContext());

        addTranscodingThreads(builder);
        addTimeConstraintParameters(timeOffset, timeDuration, mediaItem.getDuration(), builder);
        if (tDef.getTargetContainer() != AudioContainer.LPCM)
        {
            Integer itemBitrate = mediaItem.getBitrate() !is null ? mediaItem.getBitrate() : null;
            Integer audioBitrate = getAudioBitrate(itemBitrate, tDef);
            builder.outFileOptions(cast(String[])[ "-b:a", java.lang.String.format("%sk", cast(Object[])[audioBitrate.toString()]) ]);
        }
        if (tDef.getTargetContainer() == AudioContainer.MP3) {
            builder.outFileOptions(cast(String[])[ "-id3v2_version", "3" ]);
        }
        Integer frequency = getAudioFrequency(tDef, mediaItem);
        if (frequency !is null) {
            builder.outFileOptions(cast(String[])[ "-ar", frequency.toString() ]);
        }
        addAudioChannelsNumber(mediaItem.getChannels(), AudioCodec.UNKNOWN, true, false, builder);

        builder.outFileOptions(cast(String[])[ "-f", tDef.getTargetContainer().getFFmpegContainerEncoderName() ]).outFile(getOutputFile(tmpFile));


        log.debug_(java.lang.String.format("Invoking FFmpeg to transcode audio file: %s", cast(Object[])[ sourceFileName ]));
        return executeTranscodingProcess(tmpFile, listener, builder.build());
    }

    private static OutputStream executeTranscodingProcess(File tmpFile, TranscodingJobListener listener, ProcessExecutorParameter[] ffmpegArgs)
    {
        ProcessExecutor executor = new ProcessExecutor(ffmpegArgs, true, null, tmpFile is null);
        executor.addListener(listener);
        executor.start();
        if (tmpFile is null)
        {
            int retries = 0;
            while ((executor.getOutputStream() is null) && (retries++ < 5)) {
                ThreadUtils.currentThreadSleep(500L);
            }
        }
        return executor.getOutputStream();
    }

    private static String getOutputFile(File outputFile)
    {
        if (outputFile is null) {
            return "pipe:";
        }
        return FileUtils.getProperFilePath(outputFile);
    }

    private static FFmpegCLBuilder buildBasicTranscodingParameters(String sourceFilePath, DeliveryContext context)
    {
        FFmpegCLBuilder builder = new FFmpegCLBuilder();
        addInputFileOptions(sourceFilePath, context, builder);
        builder.inFile(java.lang.String.format("%s", cast(Object[])[ sourceFilePath ])).outFileOptions(cast(String[])[ "-y" ]);
        return builder;
    }

    private static void addInputFileOptions(String fileName, DeliveryContext context, FFmpegCLBuilder builder)
    {
        if ((!context.isLocalContent()) && (ObjectValidator.isNotEmpty(context.getUserAgent())) && ((fileName.startsWith("http://")) || (fileName.startsWith("https://")))) {
            builder.inFileOptions(cast(String[])[ "-user-agent", context.getUserAgent() ]);
        }
        if ((!context.isLocalContent()) && (fileName.startsWith("rtsp://"))) {
            builder.globalOptions(cast(String[])[ "-rtsp_transport", "+tcp+udp" ]);
        }
        if (!context.isLocalContent()) {
            builder.globalOptions(cast(String[])[ "-analyzeduration", "10000000" ]);
        }
    }

    private static void mapStreams(Video mediaItem, FFmpegCLBuilder builder)
    {
        if (mediaItem.getVideoStreamIndex() !is null) {
            builder.outFileOptions(cast(String[])[ "-map", java.lang.String.format("0:%s", cast(Object[])[mediaItem.getVideoStreamIndex().toString()]) ]);
        }
        if ((mediaItem.getAudioCodec() != AudioCodec.UNKNOWN) && (mediaItem.getAudioStreamIndex() !is null)) {
            builder.outFileOptions(cast(String[])[ "-map", java.lang.String.format("0:%s", cast(Object[])[mediaItem.getAudioStreamIndex().toString()]) ]);
        }
    }

    protected static void addTimeConstraintParameters(Double timeOffset, Double timeDuration, Integer totalTime, FFmpegCLBuilder builder)
    {
        int seekSplitPosition = 10;

        double start = 0.0;
        if ((timeOffset !is null) && (timeOffset.doubleValue() > 0.0) && (((totalTime !is null) && (timeOffset.doubleValue() < totalTime.intValue())) || (totalTime is null)))
        {
            if (timeOffset.doubleValue() > seekSplitPosition)
            {
                builder.inFileOptions(cast(String[])[ "-ss", Double.toString(timeOffset.doubleValue() - seekSplitPosition) ]);
                builder.outFileOptions(cast(String[])[ "-ss", Double.toString(seekSplitPosition) ]);
            }
            else
            {
                builder.outFileOptions(cast(String[])[ "-ss", Double.toString(timeOffset.doubleValue()) ]);
            }
            start += timeOffset.doubleValue();
        }
        if (timeDuration !is null) {
            builder.outFileOptions(cast(String[])[ "-t", Double.toString(start + timeDuration.doubleValue()) ]);
        }
    }

    private static void addVideoParameters(Video mediaItem, VideoTranscodingDefinition tDef, HardSubs hardSubs, FFmpegCLBuilder builder)
    {
        bool vCodecCopy = false;
        VideoCodec targetCodec = getTargetVideoCodec(mediaItem, tDef);

        builder.outFileOptions(cast(String[])[ "-c:v" ]);
        if (!isVideoStreamChanged(mediaItem, tDef, hardSubs))
        {
            builder.outFileOptions(cast(String[])[ "copy" ]);
            vCodecCopy = true;
            builder.globalOptions(cast(String[])[ "-fflags", "+genpts" ]);
        }
        else
        {
            builder.outFileOptions(cast(String[])[ targetCodec.getFFmpegEncoderName() ]);
            if (targetCodec == VideoCodec.H264)
            {
                builder.outFileOptions(cast(String[])[ "-profile:v", "baseline", "-level", "3", "-preset", "veryfast" ]);
                addVideoBitrateConstraints(tDef, builder);
                if (Configuration.isTranscodingBestQuality()) {
                    builder.outFileOptions(cast(String[])[ "-crf", "10" ]);
                } else {
                    builder.outFileOptions(cast(String[])[ "-crf", x264VideoQualityFactor ]);
                }
            }
            else
            {
                if (targetCodec == VideoCodec.MPEG2) {
                    builder.outFileOptions(cast(String[])[ "-pix_fmt", "yuv420p" ]);
                }
                if (!addVideoBitrateConstraints(tDef, builder)) {
                    if (Configuration.isTranscodingBestQuality()) {
                        builder.outFileOptions(cast(String[])[ "-qscale:v", "1" ]);
                    } else {
                        builder.outFileOptions(cast(String[])[ "-qscale:v", videoQualityFactor ]);
                    }
                }
            }
            addVideoFilters(mediaItem, tDef.getMaxHeight(), tDef.getDar(), tDef.getTargetContainer(), hardSubs, builder);
            addFrameRate(mediaItem, builder);

            builder.outFileOptions(cast(String[])[ "-g", "15" ]);
        }
        if ((vCodecCopy) && (mediaItem.getVideoCodec() == VideoCodec.H264) && (!isMpegTSbasedContainer(mediaItem.getContainer())) && (isMpegTSbasedContainer(tDef.getTargetContainer()))) {
            builder.outFileOptions(cast(String[])[ "-bsf:v", "h264_mp4toannexb" ]);
        } else if ((!vCodecCopy) && (targetCodec == VideoCodec.H264) && (isMpegTSbasedContainer(tDef.getTargetContainer()))) {
            builder.outFileOptions(cast(String[])[ "-bsf:v", "h264_mp4toannexb", "-flags", "-global_header" ]);
        }
        if (tDef.getTargetContainer() == VideoContainer.M2TS) {
            builder.outFileOptions(cast(String[])[ "-mpegts_m2ts_mode", "1" ]);
        }
    }

    public static VideoCodec getTargetVideoCodec(Video mediaItem, VideoTranscodingDefinition tDef)
    {
        return tDef.getTargetVideoCodec() != VideoCodec.UNKNOWN ? tDef.getTargetVideoCodec() : mediaItem.getVideoCodec();
    }

    private static bool isMpegTSbasedContainer(VideoContainer container)
    {
        return (container == VideoContainer.MPEG2TS) || (container == VideoContainer.WTV) || (container == VideoContainer.APPLE_HTTP) || (container == VideoContainer.M2TS);
    }

    private static bool addVideoBitrateConstraints(VideoTranscodingDefinition tDef, FFmpegCLBuilder builder)
    {
        if (tDef.getMaxVideoBitrate() !is null)
        {
            builder.outFileOptions(cast(String[])[ "-b:v", tDef.getMaxVideoBitrate().toString() ~ "k", "-maxrate:v", tDef.getMaxVideoBitrate().toString() ~ "k", "-bufsize:v", tDef.getMaxVideoBitrate().toString() ~ "k" ]);

            return true;
        }
        return false;
    }

    private static bool isVideoStreamChanged(Video mediaItem, VideoTranscodingDefinition tDef, HardSubs hardSubs)
    {
        bool codecCopy = (!tDef.isForceVTranscoding()) && ((tDef.getTargetVideoCodec() == VideoCodec.UNKNOWN) || (tDef.getTargetVideoCodec() == mediaItem.getVideoCodec()));

        return (!codecCopy) || (hardSubs !is null) || (tDef.getMaxVideoBitrate() !is null) || (isVideoResolutionChangeRequired(mediaItem.getWidth(), mediaItem.getHeight(), tDef.getMaxHeight(), tDef.getDar(), tDef.getTargetContainer(), mediaItem.getSar()));
    }

    private static void addFrameRate(Video mediaItem, FFmpegCLBuilder builder)
    {
        String fr = mediaItem.getFps();
        if (fr !is null)
        {
            fr = findNearestValidFFmpegFrameRate(fr);
            builder.outFileOptions(cast(String[])[ "-r", fr.toString() ]);
        }
    }

    protected static void addVideoFilters(Video video, Integer maxHeight, DisplayAspectRatio targetDar, VideoContainer targetContainer, HardSubs hardSubs, FFmpegCLBuilder builder)
    {
        List!(String) filters = new ArrayList!(String)();
        bool parameterQuoted = false;
        ResizeDefinition resizeDefinition = getTargetVideoDimensions(video, maxHeight, targetDar, targetContainer);
        if (resizeDefinition.changed())
        {
            if (resizeDefinition.physicalDimensionsChanged()) {
                filters.add(java.lang.String.format("scale=%s:%s", cast(Object[])[ Integer.valueOf(resizeDefinition.contentWidth), Integer.valueOf(resizeDefinition.contentHeight) ]));
            }
            if (resizeDefinition.darChanged)
            {
                Integer posX = Integer.valueOf(Math.abs(resizeDefinition.width - resizeDefinition.contentWidth) / 2);
                Integer posY = Integer.valueOf(Math.abs(resizeDefinition.height - resizeDefinition.contentHeight) / 2);
                filters.add(java.lang.String.format("pad=%s:%s:%s:%s:black", cast(Object[])[ Integer.valueOf(resizeDefinition.width), Integer.valueOf(resizeDefinition.height), posX, posY ]));

                filters.add("setdar=4:3");
            }
            if (resizeDefinition.sarChangedToSquarePixels) {
                filters.add("setsar=1");
            } else if (!video.getSar().isSquarePixels()) {
                filters.add("setsar=" ~ video.getSar().toString());
            }
        }
        if (hardSubs !is null)
        {
            filters.add(java.lang.String.format("subtitles=filename=%s:original_size=%sx%s:charenc=%s", cast(Object[])[ encodeFilePathForFilter(hardSubs, Platform.isWindows()), video.getWidth().toString(), video.getHeight().toString(), Configuration.getSubsCharacterEncoding() ]));

            parameterQuoted = true;
        }
        if (filters.size() > 0)
        {
            builder.outFileOptions(cast(String[])[ "-vf" ]);
            builder.outFileOption(CollectionUtils.listToCSV(filters, ",", true), parameterQuoted);
        }
    }

    protected static String encodeFilePathForFilter(HardSubs hardSubs, bool windows)
    {
        String tplt = windows ? "\"%s\"" : "'%s'";
        String fileName = hardSubs.getSubtitlesFile();
        foreach (Entry!(String, String) encodingRule ; windows ? windowsStringEncoding.entrySet() : stringEncoding.entrySet()) {
            fileName = fileName.replaceAll(cast(String)encodingRule.getKey(), cast(String)encodingRule.getValue());
        }
        return java.lang.String.format(tplt, cast(Object[])[ fileName ]);
    }

    private static void addAudioParameters(Video mediaItem, VideoTranscodingDefinition tDef, FFmpegCLBuilder builder)
    {
        if (mediaItem.getAudioCodec() == AudioCodec.UNKNOWN)
        {
            builder.outFileOptions(cast(String[])[ "-an" ]);
            return;
        }
        builder.outFileOptions(cast(String[])[ "-c:a" ]);
        if ((tDef.getTargetAudioCodec()  == AudioCodec.UNKNOWN) || ((tDef.getTargetAudioCodec() == mediaItem.getAudioCodec()) && ((tDef.getAudioSamplerate() is null) || (tDef.getAudioSamplerate().opEquals(mediaItem.getFrequency())))))
        {
            builder.outFileOptions(cast(String[])[ "copy" ]);
        }
        else
        {
            builder.outFileOptions(cast(String[])[ tDef.getTargetAudioCodec().getFFmpegEncoderName() ]);
            if (tDef.getTargetAudioCodec() == AudioCodec.AAC) {
                builder.outFileOptions(cast(String[])[ "-strict", "experimental" ]);
            }
            if (tDef.getTargetAudioCodec() != AudioCodec.LPCM)
            {
                Integer itemBitrate = mediaItem.getAudioBitrate() !is null ? mediaItem.getAudioBitrate() : null;
                Integer audioBitrate = getAudioBitrate(itemBitrate, tDef);
                builder.outFileOptions(cast(String[])[ "-b:a", java.lang.String.format("%sk", cast(Object[])[audioBitrate]) ]);
            }
            Integer frequency = getAudioFrequency(tDef, mediaItem);
            if (frequency !is null) {
                builder.outFileOptions(cast(String[])[ "-ar", frequency.toString() ]);
            }
            bool downmixingSupported = mediaItem.getAudioCodec() != AudioCodec.FLAC;

            addAudioChannelsNumber(mediaItem.getChannels(), tDef.getTargetAudioCodec(), downmixingSupported, tDef.isForceStereo(), builder);
        }
    }

    public static Integer getAudioBitrate(Integer itemBitrate, TranscodingDefinition tDef)
    {
        if ((itemBitrate !is null) && 
            (!validAudioBitrates.contains(itemBitrate))) {
                itemBitrate = findNearestValidBitrate(itemBitrate);
            }
        Integer minimalAudioBitrate = (itemBitrate !is null) && (itemBitrate.intValue() < defaultAudioBitrate.intValue()) ? itemBitrate : defaultAudioBitrate;


        Integer audioBitrate = tDef.getAudioBitrate() !is null ? tDef.getAudioBitrate() : minimalAudioBitrate;
        return audioBitrate;
    }

    private static Integer findNearestValidBitrate(Integer itemBitrate)
    {
        int nearest = -1;
        int bestDistanceFoundYet = 2147483647;
        for (auto i = validAudioBitrates.iterator(); i.hasNext();)
        {
            int validRate = (cast(Integer)i.next()).intValue();
            int d = Math.abs(itemBitrate.intValue() - validRate);
            if (d < bestDistanceFoundYet)
            {
                nearest = validRate;
                bestDistanceFoundYet = d;
            }
        }
        return Integer.valueOf(nearest);
    }

    private static Integer getAudioFrequency(VideoTranscodingDefinition tDef, Video mediaItem)
    {
        return getAudioFrequency(tDef, mediaItem.getFrequency(), (tDef.getTargetAudioCodec() == AudioCodec.LPCM) || (mediaItem.getAudioCodec() == AudioCodec.LPCM));
    }

    private static Integer getAudioFrequency(AudioTranscodingDefinition tDef, MusicTrack mediaItem)
    {
        return getAudioFrequency(tDef, mediaItem.getSampleFrequency(), (tDef.getTargetContainer() == AudioContainer.LPCM) || (mediaItem.getContainer() == AudioContainer.LPCM));
    }

    public static Integer getAudioFrequency(TranscodingDefinition tDef, Integer itemFrequency, bool isLPCM)
    {
        Integer frequency = Integer.valueOf(48000);
        bool frequencyRequired = false;
        if (itemFrequency !is null)
        {
            if (itemFrequency.intValue() >= 44100) {
                frequency = itemFrequency;
            } else {
                frequencyRequired = true;
            }
        }
        else {
            frequencyRequired = true;
        }
        if (tDef.getAudioSamplerate() is null)
        {
            if ((isLPCM) || (frequencyRequired)) {
                return frequency;
            }
            return null;
        }
        return tDef.getAudioSamplerate();
    }

    private static void addAudioChannelsNumber(Integer channelNumber, AudioCodec targetCodec, bool downmixingSupported, bool alwaysForceStereo, FFmpegCLBuilder builder)
    {
        Integer channels = getAudioChannelNumber(channelNumber, targetCodec, downmixingSupported, alwaysForceStereo);
        if (channels !is null) {
            builder.outFileOptions(cast(String[])[ "-ac", channels.toString() ]);
        }
    }

    private static Integer getMaxNumberOfChannels(AudioCodec codec)
    {
        if (codec != AudioCodec.UNKNOWN) {
            return cast(Integer)maxChannelNumber.get(codec);
        }
        return null;
    }

    public static Integer getAudioChannelNumber(Integer channelNumber, AudioCodec targetCodec, bool downmixingSupported, bool alwaysForceStereo)
    {
        if (channelNumber is null)
        {
            if ((Configuration.isTranscodingDownmixToStereo()) || (alwaysForceStereo)) {
                return Integer.valueOf(2);
            }
        }
        else
        {
            Integer maxChannels = getMaxNumberOfChannels(targetCodec);
            if ((channelNumber.intValue() > 2) && ((Configuration.isTranscodingDownmixToStereo()) || (alwaysForceStereo)) && (downmixingSupported)) {
                return Integer.valueOf(2);
            }
            if ((maxChannels !is null) && (maxChannels.intValue() < channelNumber.intValue())) {
                return maxChannels;
            }
            return channelNumber;
        }
        return null;
    }

    public static ResizeDefinition getTargetVideoDimensions(Video video, Integer maxHeight, DisplayAspectRatio targetDar, VideoContainer targetContainer)
    {
        if ((!isVideoHeightChanged(video.getHeight(), maxHeight)) && (!isVideoDARChanged(video.getWidth(), video.getHeight(), targetDar, video.getSar())) && (!isSARFixNeeded(targetContainer, video.getSar().isSquarePixels()))) {
            return new ResizeDefinition(video.getWidth().intValue(), video.getHeight().intValue());
        }
        Integer newWidth = video.getWidth();
        Integer newHeight = video.getHeight();
        Integer newContentWidth = video.getWidth();
        Integer newContentHeight = video.getHeight();
        bool sarChanged = false;
        bool darChanged = false;
        bool heightChanged = false;
        if (isSARFixNeeded(targetContainer, video.getSar().isSquarePixels()))
        {
            Tupple!(Integer, Integer) dimensions = getResolutionForSquarePixels(video.getWidth(), video.getHeight(), video.getSar());

            newWidth = cast(Integer)dimensions.getValueA();
            newHeight = cast(Integer)dimensions.getValueB();
            newContentWidth = newWidth;
            newContentHeight = newHeight;
            sarChanged = true;
        }
        SourceAspectRatio sarMultiplier = sarChanged ? SourceAspectRatio.square() : video.getSar();
        if (isVideoDARChanged(newWidth, newHeight, targetDar, sarMultiplier))
        {
            float originalDar = newWidth.intValue() / newHeight.intValue() * sarMultiplier.getSar().floatValue();
            if (originalDar >= targetDar.getRatio()) {
                newHeight = Integer.valueOf(Math.round(newWidth.intValue() * sarMultiplier.getSar().floatValue() / targetDar.getRatio()));
            } else {
                newWidth = Integer.valueOf(Math.round(newHeight.intValue() * targetDar.getRatio() / sarMultiplier.getSar().floatValue()));
            }
            darChanged = true;
        }
        if (isVideoHeightChanged(newHeight, maxHeight))
        {
            int origNewWidth = newWidth.intValue();
            int origNewHeight = newHeight.intValue();
            newWidth = Integer.valueOf(Math.round(newWidth.intValue() * (maxHeight.intValue() / newHeight.intValue())));
            newHeight = maxHeight;
            newContentWidth = Integer.valueOf(Math.round(newContentWidth.intValue() * (newWidth.intValue() / origNewWidth)));
            newContentHeight = Integer.valueOf(Math.round(newContentHeight.intValue() * (newHeight.intValue() / origNewHeight)));
            heightChanged = true;
        }
        return new ResizeDefinition(newWidth.intValue(), newHeight.intValue(), newContentWidth.intValue(), newContentHeight.intValue(), darChanged, sarChanged, heightChanged);
    }

    private static Tupple!(Integer, Integer) getResolutionForSquarePixels(Integer width, Integer height, SourceAspectRatio sar)
    {
        return new Tupple!(Integer, Integer)(Integer.valueOf(Math.round(width.intValue() * sar.getSar().floatValue())), height);
    }

    protected static bool isVideoResolutionChangeRequired(Integer width, Integer height, Integer maxHeight, DisplayAspectRatio dar, VideoContainer targetContainer, SourceAspectRatio sar)
    {
        return (isVideoHeightChanged(height, maxHeight)) || (isVideoDARChanged(width, height, dar, sar)) || (isSARFixNeeded(targetContainer, sar.isSquarePixels()));
    }

    private static bool isVideoHeightChanged(Integer height, Integer maxHeight)
    {
        return (maxHeight !is null) && (height !is null) && (height.intValue() > maxHeight.intValue());
    }

    private static bool isSARFixNeeded(VideoContainer targetContainer, bool squarePixels)
    {
        return ((targetContainer == VideoContainer.ASF) || (targetContainer == VideoContainer.FLV)) && (!squarePixels);
    }

    private static bool isVideoDARChanged(Integer width, Integer height, DisplayAspectRatio dar, SourceAspectRatio sourceSar)
    {
        return (dar !is null) && (width !is null) && (height !is null) && (!dar.isEqualTo(width.intValue(), height.intValue(), sourceSar.getSar().floatValue()));
    }

    protected static String findNearestValidFFmpegFrameRate(String frameRate)
    {
        float frFloat = Float.parseFloat(frameRate);
        float validFrameRate = new Float(frFloat).floatValue();
        while (validFrameRate < 23.0F) {
            validFrameRate += frFloat;
        }
        return MediaUtils.formatFpsForFFmpeg(Float.toString(validFrameRate));
    }

    private static String getFilePathForTranscoding(MediaItem mediaItem)
    {
        bool isLocalMedia = mediaItem.isLocalMedia();
        String sourceFileName = null;
        if (isLocalMedia) {
            sourceFileName = MediaService.getFile(mediaItem.getId()).getPath();
        } else {
            sourceFileName = mediaItem.getFileName();
        }
        sourceFileName = fixFilePath(sourceFileName, isLocalMedia);
        if (!isLocalMedia) {
            sourceFileName = buildOnlineContentUrl(sourceFileName, mediaItem.isLive());
        }
        return sourceFileName;
    }

    private static String fixFilePath(String filePath, bool isLocalContent)
    {
        if (!isLocalContent) {
            return prepareOnlineContentUrl(filePath);
        }
        return filePath;
    }

    private static String buildOnlineContentUrl(String url, bool live)
    {
        if ((url.startsWith("rtmp")) && (!live)) {
            url = java.lang.String.format("%s buffer=%s", cast(Object[])[ url, Integer.valueOf(100000000).toString() ]);
        }
        return url;
    }

    protected static String getUserAgent(String ffmpegOutput)
    {
        Pattern p = Pattern.compile("libavformat(.*?)/", 2);
        Matcher m = p.matcher(ffmpegOutput);
        if (m.find())
        {
            String ver = m.group(1);
            ver = ver.replaceAll(" ", "");
            return "Lavf" ~ ver;
        }
        log.warn("Could not work output FFmpeg default User-Agent");
        return null;
    }

    private static void setupMaxChannelsMap()
    {
        maxChannelNumber = new HashMap!(AudioCodec, Integer)();
        maxChannelNumber.put(AudioCodec.AC3, new Integer(6));
        maxChannelNumber.put(AudioCodec.MP2, new Integer(2));
        maxChannelNumber.put(AudioCodec.MP3, new Integer(2));
        maxChannelNumber.put(AudioCodec.WMA, new Integer(2));
        maxChannelNumber.put(AudioCodec.LPCM, new Integer(2));
    }

    private static void setupStringEncodingMap()
    {
        stringEncoding = new LinkedHashMap!(String, String)();
        stringEncoding.put("\\\\", "/");
        stringEncoding.put("\\[", "\\\\[");
        stringEncoding.put("\\]", "\\\\]");
        stringEncoding.put("\"", "\\\\\"");
        stringEncoding.put(",", "\\\\,");
        stringEncoding.put("'", "\\\\\\\\\\\\\\\\\\\\\\\\\\\\'");

        windowsStringEncoding = new LinkedHashMap!(String, String)();
        windowsStringEncoding.put("\\\\", "/");
        windowsStringEncoding.put("\\[", "\\\\[");
        windowsStringEncoding.put("\\]", "\\\\]");
        windowsStringEncoding.put(",", "\\\\,");

        windowsStringEncoding.put(":", "\\\\\\\\:");
        windowsStringEncoding.put("'", "\\\\\\\\\\\\'");
    }

    private static long onlineItemTimeout()
    {
        String systemPropertyValue = System.getProperty("serviio.onlineContentTimeout");
        if (ObjectValidator.isEmpty(systemPropertyValue)) {
            return DEFAULT_ONLINE_FILE_TIMEOUT;
        }
        return Long.parseLong(systemPropertyValue) * 1000L;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.FFMPEGWrapper
* JD-Core Version:    0.7.0.1
*/