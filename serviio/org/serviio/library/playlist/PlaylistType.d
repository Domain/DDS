module org.serviio.library.playlist.PlaylistType;

import std.traits;

public enum PlaylistType
{
    ASX,  M3U,  PLS,  WPL
}

public String[] supportedFileExtensions(PlaylistType type)
{
    switch (type)
    {
        case ASX: 
            return ["asx", "wax", "wvx"];
        case M3U: 
            return ["m3u", "m3u8"];
        case PLS: 
            return ["pls"];
        case WPL: 
            return ["wpl"];
    }
    return [];
}

public bool playlistTypeExtensionSupported(String extension)
{
    foreach (immutable playlistType; [EnumMembers!PlaylistType]) {
        foreach (String supportedExtension ; playlistType.supportedFileExtensions()) {
            if (extension.equalsIgnoreCase(supportedExtension)) {
                return true;
            }
        }
    }
    return false;
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.playlist.PlaylistType
* JD-Core Version:    0.7.0.1
*/