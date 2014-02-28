module org.serviio.library.metadata.MediaFileType;

import std.traits;

import java.lang.String;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import org.serviio.util.CollectionUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;

public enum MediaFileType
{
    IMAGE,  VIDEO,  AUDIO
}

public String[] supportedFileExtensions(MediaFileType type)
{
    switch (type)
    {
        case IMAGE: 
            return ["jpg", "jpeg", "png", "gif", "arw", "cr2", "crw", "dng", "raf", "raw", "rw2", "mrw", "nef", "nrw", "pef", "srf", "orf"];
        case VIDEO: 
            return ["mpg", "mpeg", "vob", "avi", "mp4", "m4v", "ts", "wmv", "asf", "mkv", "divx", "m2ts", "mts", "mov", "mod", "tp", "trp", "vdr", "flv", "f4v", "dvr", "dvr-ms", "wtv", "ogv", "ogm", "3gp", "rm", "rmvb"];
        case AUDIO: 
            return ["mp3", "mp2", "wma", "m4a", "flac", "ogg", "oga", "wv", "mpc", "ape"];
    }
    return [];
}

public MediaFileType findMediaFileTypeByExtension(String extension)
{
    foreach (immutable mediaFileType; [EnumMembers!MediaFileType])
    {
        foreach (String supportedExtension ; mediaFileType.supportedFileExtensions()) {
            if (extension.equalsIgnoreCase(supportedExtension)) {
                return mediaFileType;
            }
        }
    }
    return null;
}

public MediaFileType findMediaFileTypeByMimeType(String mimeType)
{
    if (ObjectValidator.isNotEmpty(mimeType))
    {
        String mimeTypeLC = StringUtils.localeSafeToLowercase(mimeType);
        if (mimeTypeLC.startsWith("audio")) {
            return AUDIO;
        }
        if (mimeTypeLC.startsWith("image")) {
            return IMAGE;
        }
        if (mimeTypeLC.startsWith("video")) {
            return VIDEO;
        }
    }
    return null;
}

public Set!(MediaFileType) parseMediaFileTypesFromString(String fileTypesCSV)
{
    Set!(MediaFileType) result = new HashSet();
    if (ObjectValidator.isNotEmpty(fileTypesCSV))
    {
        String[] fileTypes = fileTypesCSV.split(",");
        foreach (String fileType ; fileTypes) {
            result.add(valueOf(StringUtils.localeSafeToUppercase(fileType.trim())));
        }
    }
    return result;
}

public String parseMediaFileTypesToString(Set!(MediaFileType) fileTypes)
{
    return CollectionUtils.listToCSV(new ArrayList(fileTypes), ",", true);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.metadata.MediaFileType
* JD-Core Version:    0.7.0.1
*/