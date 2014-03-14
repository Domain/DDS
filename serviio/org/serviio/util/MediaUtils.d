module org.serviio.util.MediaUtils;

import java.lang;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MediaUtils
{
    private static Logger log;

    static this()
    {
        log = LoggerFactory.getLogger!(MediaUtils);
    }

    public static Integer convertBitrateFromKbpsToByPS(Integer bitrate)
    {
        if ((bitrate !is null) && (bitrate.intValue() > 0)) {
            return Integer.valueOf(bitrate.intValue() * 1000 / 8);
        }
        return null;
    }

    public static String getValidFps(String fps)
    {
        String validFrameRate = fps;
        if (ObjectValidator.isNotEmpty(fps)) {
            try
            {
                double fr = Double.parseDouble(fps);
                if ((fr > 23.9) && (fr < 23.99)) {
                    validFrameRate = "23.976";
                } else if ((fr > 23.99) && (fr < 24.1)) {
                    validFrameRate = "24";
                } else if ((fr >= 24.99) && (fr < 25.1)) {
                    validFrameRate = "25";
                } else if ((fr > 29.9) && (fr < 29.99)) {
                    validFrameRate = "29.97";
                } else if ((fr >= 29.99) && (fr < 30.1)) {
                    validFrameRate = "30";
                } else if ((fr > 49.9) && (fr < 50.1)) {
                    validFrameRate = "50";
                } else if ((fr > 59.9) && (fr < 59.99)) {
                    validFrameRate = "59.94";
                } else if ((fr >= 59.99) && (fr < 60.1)) {
                    validFrameRate = "60";
                } else {
                    validFrameRate = "23.976";
                }
            }
            catch (NumberFormatException nfe)
            {
                log.debug_(String.format("Cannot get valid FPS of video file: %s", cast(Object[])[ fps ]));
            }
        }
        return validFrameRate;
    }

    public static String formatFpsForFFmpeg(String fps)
    {
        String normalizedFps = getValidFps(fps);
        if (normalizedFps.equals("23.976")) {
            return "24000/1001";
        }
        if (normalizedFps.equals("29.97")) {
            return "30000/1001";
        }
        if (normalizedFps.equals("59.94")) {
            return "60000/1001";
        }
        return normalizedFps;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.MediaUtils
* JD-Core Version:    0.7.0.1
*/