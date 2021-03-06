module org.serviio.dlna.DLNAConstants;

import java.lang.String;

public class DLNAConstants
{
    public static immutable int THUMBNAIL_MAX_WIDTH = 160;
    public static immutable int THUMBNAIL_MAX_HEIGHT = 160;
    public static immutable int JPEG_SM_MAX_WIDTH = 640;
    public static immutable int JPEG_SM_MAX_HEIGHT = 480;
    public static immutable int JPEG_MED_MAX_WIDTH = 1024;
    public static immutable int JPEG_MED_MAX_HEIGHT = 768;
    public static immutable int JPEG_LRG_MAX_WIDTH = 4096;
    public static immutable int JPEG_LRG_MAX_HEIGHT = 4096;
    public static immutable int GIF_LRG_MAX_WIDTH = 1600;
    public static immutable int GIF_LRG_MAX_HEIGHT = 1200;
    public static immutable int WMA_BASE_MAX_BITRATE = 193;
    public static immutable int MP4_320_MAX_BITRATE = 320;
    public static immutable String HTTP_HEADER_TIME_RANGE = "TimeSeekRange.dlna.org";
    public static immutable String HTTP_HEADER_X_AVAILABLE_SEEK_RANGE = "X-AvailableSeekRange";
    public static immutable String HTTP_HEADER_TRANSFER_MODE = "transferMode.dlna.org";
    public static immutable String HTTP_HEADER_REALTIME_INFO = "realTimeInfo.dlna.org";
    public static immutable String HTTP_HEADER_CONTENT_FEATURES = "contentFeatures.dlna.org";
    public static immutable String HTTP_HEADER_BYTE_RANGE = "Range";
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.DLNAConstants
* JD-Core Version:    0.7.0.1
*/