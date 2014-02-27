module org.serviio.upnp.service.contentdirectory.classes.ObjectClassType;

public enum ObjectClassType
{
    CONTAINER,  
    AUDIO_ITEM,  
    VIDEO_ITEM,  
    IMAGE_ITEM,  
    MOVIE,  
    MUSIC_TRACK,  
    PHOTO,  
    PLAYLIST_ITEM,  
    PLAYLIST_CONTAINER,  
    PERSON,  
    MUSIC_ARTIST,  
    GENRE,  
    MUSIC_GENRE,  
    ALBUM,  
    MUSIC_ALBUM,  
    STORAGE_FOLDER,
}

public String getClassName(ObjectClassType type)
{
    switch (type)
    {
        case CONTAINER:
            return "object.container";
        case AUDIO_ITEM:
            return "object.item.audioItem";
        case VIDEO_ITEM:
            return "object.item.videoItem";
        case IMAGE_ITEM:
            return "object.item.imageItem";
        case MOVIE:
            return "object.item.videoItem.movie";
        case MUSIC_TRACK:
            return "object.item.audioItem.musicTrack";
        case PHOTO:
            return "object.item.imageItem.photo";
        case PLAYLIST_ITEM:
            return "object.container";
        case PLAYLIST_CONTAINER:
            return "object.container.playlistContainer";
        case PERSON:
            return "object.container.person";
        case MUSIC_ARTIST:
            return "object.container.person.musicArtist";
        case GENRE:
            return "object.container.genre";
        case MUSIC_GENRE:
            return "object.container.genre.musicGenre";
        case ALBUM:
            return "object.container.album";
        case MUSIC_ALBUM:
            return "object.container.album.musicAlbum";
        case STORAGE_FOLDER:
            return "object.container.storageFolder";
    }
    return null;
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.ObjectClassType
* JD-Core Version:    0.7.0.1
*/