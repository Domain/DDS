module org.serviio.dlna.SubtitleCodec;

import std.algorithm;
import std.traits;

import java.lang;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.serviio.util.FileUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;

public enum SubtitleCodec
{
    SRT,  ASS,  SUB,  SMI,  VTT,  MOV_TEXT,  UNKNOWN
}

public String[] getFileExtensions(SubtitleCodec codec)
{
    final switch (codec)
    {
        case SubtitleCodec.SRT:
            return ["srt"];

        case SubtitleCodec.ASS:
            return ["ass", "ssa"];

        case SubtitleCodec.SUB:
            return ["sub"];

        case SubtitleCodec.SMI:
            return ["smi"];

        case SubtitleCodec.VTT:
            return ["vtt"];

        case SubtitleCodec.MOV_TEXT:
            return [];

        case SubtitleCodec.UNKNOWN:
            return ["txt"];
    }
}

public String getFFmpegEncoderName(SubtitleCodec codec)
{
    final switch (codec)
    {
        case SubtitleCodec.SRT:
            return "srt";

        case SubtitleCodec.ASS:
            return "ass";

        case SubtitleCodec.SUB:
        case SubtitleCodec.SMI:
        case SubtitleCodec.VTT:
        case SubtitleCodec.MOV_TEXT:
        case SubtitleCodec.UNKNOWN:
            return null;
    }
}

public String[] getAllSupportedExtensions()
{
    String[] result;
    foreach (immutable codec; [EnumMembers!SubtitleCodec])
        result ~= getFileExtensions(codec);
    return result;
}

public SubtitleCodec getByFileName(String subtitleFileName)
{
    if (subtitleFileName !is null)
    {
        String extension = FileUtils.getFileExtension(subtitleFileName);
        if (extension != "")
        {
            String normalizedExtension = StringUtils.localeSafeToLowercase(extension);
            foreach (immutable codec; [EnumMembers!SubtitleCodec]) 
            {
                if (getFileExtensions(codec).canFind(normalizedExtension))
                    return codec;
            }
        }
    }
    return SubtitleCodec.UNKNOWN;
}

public SubtitleCodec getByFFmpegValue(String ffmpegName)
{
    if (ffmpegName !is null)
    {
        if ((ffmpegName.equals("srt")) || (ffmpegName.equals("subrip"))) {
            return SubtitleCodec.SRT;
        }
        if (ffmpegName.equals("microdvd")) {
            return SubtitleCodec.SUB;
        }
        if ((ffmpegName.equals("ass")) || (ffmpegName.equals("ssa"))) {
            return SubtitleCodec.ASS;
        }
        if (ffmpegName.equals("sami")) {
            return SubtitleCodec.SMI;
        }
        if (ffmpegName.equals("webvtt")) {
            return SubtitleCodec.VTT;
        }
        if (ffmpegName.equals("mov_text")) {
            return SubtitleCodec.MOV_TEXT;
        }
    }
    return SubtitleCodec.UNKNOWN;
}

/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.SubtitleCodec
* JD-Core Version:    0.7.0.1
*/