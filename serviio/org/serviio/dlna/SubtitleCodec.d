module org.serviio.dlna.SubtitleCodec;

import std.algorithm;
import std.traits;

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
    switch (codec)
    {
        case SRT:
            return ["srt"];

        case ASS:
            return ["ass", "ssa"];

        case sub:
            return ["sub"];

        case SMI:
            return ["smi"];

        case VTT:
            return ["vtt"];

        case MOV_TEXT:
            return [];

        case UNKNOWN:
            return ["txt"];
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
    return UNKNOWN;
}

public SubtitleCodec getByFFmpegValue(String ffmpegName)
{
    if (ffmpegName !is null)
    {
        if ((ffmpegName.equals("srt")) || (ffmpegName.equals("subrip"))) {
            return SRT;
        }
        if (ffmpegName.equals("microdvd")) {
            return SUB;
        }
        if ((ffmpegName.equals("ass")) || (ffmpegName.equals("ssa"))) {
            return ASS;
        }
        if (ffmpegName.equals("sami")) {
            return SMI;
        }
        if (ffmpegName.equals("webvtt")) {
            return VTT;
        }
        if (ffmpegName.equals("mov_text")) {
            return MOV_TEXT;
        }
    }
    return null;
}

/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.SubtitleCodec
* JD-Core Version:    0.7.0.1
*/