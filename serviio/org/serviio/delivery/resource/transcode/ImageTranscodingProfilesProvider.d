module org.serviio.delivery.resource.transcode.ImageTranscodingProfilesProvider;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.dlna.MediaFormatProfile;

public class ImageTranscodingProfilesProvider
{
    private static Map!(MediaFormatProfile, List!(MediaFormatProfile)) transcodingConfig;

    static this()
    {
        transcodingConfig = new HashMap!(MediaFormatProfile, List!(MediaFormatProfile))();
        transcodingConfig.put(MediaFormatProfile.JPEG_MED, Arrays.asList(cast(MediaFormatProfile[])[ MediaFormatProfile.JPEG_SM ]));
        transcodingConfig.put(MediaFormatProfile.JPEG_LRG, Arrays.asList(cast(MediaFormatProfile[])[ MediaFormatProfile.JPEG_SM, MediaFormatProfile.JPEG_MED ]));
        transcodingConfig.put(MediaFormatProfile.PNG_LRG, Arrays.asList(cast(MediaFormatProfile[])[ MediaFormatProfile.JPEG_LRG ]));
        transcodingConfig.put(MediaFormatProfile.GIF_LRG, Arrays.asList(cast(MediaFormatProfile[])[ MediaFormatProfile.JPEG_LRG ]));
        transcodingConfig.put(MediaFormatProfile.RAW, Arrays.asList(cast(MediaFormatProfile[])[ MediaFormatProfile.JPEG_SM, MediaFormatProfile.JPEG_MED, MediaFormatProfile.JPEG_LRG ]));
    }

    public static List!(MediaFormatProfile) getAvailableTranscodingProfiles(List!(MediaFormatProfile) profiles)
    {
        Set!(MediaFormatProfile) availableProfiles = new HashSet();
        foreach (MediaFormatProfile profile ; profiles) {
            if (transcodingConfig.containsKey(profile)) {
                availableProfiles.addAll(cast(Collection)transcodingConfig.get(profile));
            }
        }
        return new ArrayList(availableProfiles);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.ImageTranscodingProfilesProvider
* JD-Core Version:    0.7.0.1
*/