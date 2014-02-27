module org.serviio.upnp.service.contentdirectory.classes.ClassProperties;

import std.traits;

public enum ClassProperties
{
    OBJECT_CLASS,  
    ID,  
    PARENT_ID,  
    TITLE,  
    CREATOR,  
    GENRE,  
    CHILD_COUNT,  
    REF_ID,  
    DESCRIPTION,  
    LONG_DESCRIPTION,  
    LANGUAGE,  
    PUBLISHER,  
    ACTOR,  
    DIRECTOR,  
    PRODUCER,  
    ARTIST,  
    RIGHTS,  
    RATING,  
    RESTRICTED,  
    SEARCHABLE,  
    ALBUM,  
    RESOURCE_URL,  
    RESOURCE_SIZE,  
    RESOURCE_DURATION,  
    RESOURCE_BITRATE,  
    RESOURCE_PROTOCOLINFO,  
    RESOURCE_CHANNELS,  
    RESOURCE_SAMPLE_FREQUENCY,  
    RESOURCE_RESOLUTION,  
    RESOURCE_COLOR_DEPTH,  
    ORIGINAL_TRACK_NUMBER,  
    DATE, 
    ALBUM_ART_URI,  
    ICON,  
    SUBTITLES_URL,  
    DCM_INFO,  
    MEDIA_CLASS,  
    LIVE,  
    ONLINE_DB_IDENTIFIERS,  
    CONTENT_TYPE,
}

public String getAttributeName(ClassProperties property)
{
    switch (property)
    {
        case OBJECT_CLASS:
            return "objectClass";
        case ID:
            return "id";
        case PARENT_ID:
            return "parentID";
        case TITLE:
            return "title";
        case CREATOR:
            return "creator";
        case GENRE:
            return "genre";
        case CHILD_COUNT:
            return "childCount";
        case REF_ID:
            return "refID";
        case DESCRIPTION:
            return "description";
        case LONG_DESCRIPTION:
            return "longDescription";
        case LANGUAGE:
            return "language";
        case PUBLISHER:
            return "publishers";
        case ACTOR:
            return "actors";
        case DIRECTOR:
            return "directors";
        case PRODUCER:
            return "producers";
        case ARTIST:
            return "artist";
        case RIGHTS:
            return "rights";
        case RATING:
            return "rating";
        case RESTRICTED:
            return "restricted";
        case SEARCHABLE:
            return "searchable";
        case ALBUM:
            return "album";
        case RESOURCE_URL:
            return "resource.generatedURL";
        case RESOURCE_SIZE:
            return "resource.size";
        case RESOURCE_DURATION:
            return "resource.durationFormatted";
        case RESOURCE_BITRATE:
            return "resource.bitrate";
        case RESOURCE_PROTOCOLINFO:
            return "resource.protocolInfo";
        case RESOURCE_CHANNELS:
            return "resource.nrAudioChannels";
        case RESOURCE_SAMPLE_FREQUENCY:
            return "resource.sampleFrequency";
        case RESOURCE_RESOLUTION:
            return "resource.resolution";
        case RESOURCE_COLOR_DEPTH:
            return "resource.colorDepth";
        case ORIGINAL_TRACK_NUMBER:
            return "originalTrackNumber";
        case DATE:
            return "date";
        case ALBUM_ART_URI:
            return "albumArtURIResource.generatedURL";
        case ICON:
            return "icon.generatedURL";
        case SUBTITLES_URL:
            return "subtitlesUrlResource.generatedURL";
        case DCM_INFO:
            return "dcmInfo";
        case MEDIA_CLASS:
            return "mediaClass";
        case LIVE:
            return "live";
        case ONLINE_DB_IDENTIFIERS:
            return "onlineIdentifiers";
        case CONTENT_TYPE:
            return "contentType";
    }
    return null;
}

public String[] getPropertyFilterNames(ClassProperties property)
{
    switch (property)
    {
        case OBJECT_CLASS:
            return ["upnp:class"];
        case ID:
            return ["@id"];
        case PARENT_ID:
            return ["@parentID"];
        case TITLE:
            return ["dc:title"];
        case CREATOR:
            return ["dc:creator"];
        case GENRE:
            return ["upnp:genre"];
        case CHILD_COUNT:
            return ["@childCount"];
        case REF_ID:
            return ["@refID"];
        case DESCRIPTION:
            return ["dc:description"];
        case LONG_DESCRIPTION:
            return ["upnp:longDescription"];
        case LANGUAGE:
            return ["dc:language"];
        case PUBLISHER:
            return ["dc:publisher"];
        case ACTOR:
            return ["upnp:actor"];
        case DIRECTOR:
            return ["upnp:director"];
        case PRODUCER:
            return ["upnp:producer"];
        case ARTIST:
            return ["upnp:artist"];
        case RIGHTS:
            return ["dc:rights"];
        case RATING:
            return ["upnp:rating"];
        case RESTRICTED:
            return ["@restricted"];
        case SEARCHABLE:
            return ["@searchable"];
        case ALBUM:
            return ["upnp:album"];
        case RESOURCE_URL:
            return ["res"];
        case RESOURCE_SIZE:
            return ["res@size"];
        case RESOURCE_DURATION:
            return ["res@duration"];
        case RESOURCE_BITRATE:
            return ["res@bitrate"];
        case RESOURCE_PROTOCOLINFO:
            return ["res@protocolInfo"];
        case RESOURCE_CHANNELS:
            return ["res@nrAudioChannels"];
        case RESOURCE_SAMPLE_FREQUENCY:
            return ["res@sampleFrequency"];
        case RESOURCE_RESOLUTION:
            return ["res@resolution"];
        case RESOURCE_COLOR_DEPTH:
            return ["res@colorDepth"];
        case ORIGINAL_TRACK_NUMBER:
            return ["upnp:originalTrackNumber"];
        case DATE:
            return ["dc:date"];
        case ALBUM_ART_URI:
            return ["upnp:albumArtURI"];
        case ICON:
            return ["upnp:icon"];
        case SUBTITLES_URL:
            return ["sec:CaptionInfoEx", "res@pv:subtitleFileUri"];
        case DCM_INFO:
            return ["sec:dcmInfo"];
        case MEDIA_CLASS:
            return ["av:mediaClass"];
        case LIVE:
            return [];
        case ONLINE_DB_IDENTIFIERS:
            return [];
        case CONTENT_TYPE:
            return [];
    }
    return [];
}

public String getFirstPropertyXMLName(ClassProperties property)
{
    int attributeSep = getPropertyFilterNames(property)[0].indexOf("@");
    if (attributeSep > -1) {
        return getPropertyFilterNames(property)[0].substring(attributeSep + 1);
    }
    return getPropertyFilterNames(property)[0];
}

public ClassProperties getByFilterName(String filterName)
{
    foreach (immutable cp; [EnumMembers!ClassProperties]) {
        foreach (String fn ; cp.getPropertyFilterNames()) {
            if (fn.equalsIgnoreCase(filterName)) {
                return cp;
            }
        }
    }
    return null;
}

/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.ClassProperties
* JD-Core Version:    0.7.0.1
*/