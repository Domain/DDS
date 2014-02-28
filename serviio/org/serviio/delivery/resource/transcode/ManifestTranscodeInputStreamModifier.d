module org.serviio.delivery.resource.transcode.ManifestTranscodeInputStreamModifier;

import com.googlecode.streamflyer.core.AfterModification;
import com.googlecode.streamflyer.core.Modifier;
import com.googlecode.streamflyer.core.ModifyingReader;
import com.googlecode.streamflyer.regex.RegexModifier;
import com.googlecode.streamflyer.util.ModificationFactory;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.Reader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.delivery.HostInfo;
import org.serviio.delivery.ResourceURLGenerator;
import org.serviio.upnp.service.contentdirectory.classes.InvalidResourceException;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;

public class ManifestTranscodeInputStreamModifier
{
    public static Reader modifyReader(Reader originalReader, ResourceURLGenerator urlGenerator, HostInfo hostInfo, File manifestFile, Long resourceId, bool live, LiveSegmentBasedTranscodingDeliveryStrategy.SegmentRemover segmentRemover)
    {
        try
        {
            String segmentsFolder = buildSegmentResourcePath(manifestFile);
            String serverUrl = urlGenerator.getGeneratedURL(hostInfo, Resource.ResourceType.SEGMENT, resourceId, segmentsFolder);
            String[] serverUrlTemplate = buildTargetUrlTemplate(serverUrl);
            Modifier segmentUrlModifier = new RegexModifier(".*?(\\\\|/)(segment\\d{5}.ts)", 0, serverUrlTemplate[0] + "/$2" + serverUrlTemplate[1]);

            Reader modifyingReader = new ModifyingReader(originalReader, segmentUrlModifier);
            if (live) {
                return new ModifyingReader(modifyingReader, new LiveStreamSegmentListener(segmentRemover));
            }
            return modifyingReader;
        }
        catch (InvalidResourceException e)
        {
            throw new FileNotFoundException(e.getMessage());
        }
    }

    private static String buildSegmentResourcePath(File manifestFile)
    {
        return manifestFile.getParentFile().getName();
    }

    private static String[] buildTargetUrlTemplate(String serverUrl)
    {
        int queryStringIndex = serverUrl.indexOf('?');
        String[] result = new String[2];
        if (queryStringIndex > -1)
        {
            result[0] = serverUrl.substring(0, queryStringIndex);
            result[1] = serverUrl.substring(queryStringIndex);
        }
        else
        {
            result[0] = serverUrl;
            result[1] = "";
        }
        return result;
    }

    private static class LiveStreamSegmentListener
        : Modifier
    {
        private static enum ModifierState
        {
            INITIAL,  SEGMENT_SEARCH,  SEGMENT_FOUND
        }

        public this(LiveSegmentBasedTranscodingDeliveryStrategy.SegmentRemover segmentRemover)
        {
            this.segmentRemover = segmentRemover;
        }

        private ModifierState state = ModifierState.INITIAL;
        private ModificationFactory factory = new ModificationFactory(0, 4096);
        private final LiveSegmentBasedTranscodingDeliveryStrategy.SegmentRemover segmentRemover;

        public AfterModification modify(StringBuilder characterBuffer, int firstModifiableCharacterInBuffer, bool endOfStreamHit)
        {
            switch (state)
            {
                case 1: 
                    return this.factory.skipEntireBuffer(characterBuffer, firstModifiableCharacterInBuffer, endOfStreamHit);
                case 2: 
                    this.state = ModifierState.SEGMENT_SEARCH;
                    return this.factory.modifyAgainImmediately(4096, firstModifiableCharacterInBuffer);
                case 3: 
                    Matcher matcher = LiveSegmentBasedTranscodingDeliveryStrategy.segmentPattern.matcher(characterBuffer.toString());
                    if ((matcher.find()) && (matcher.groupCount() == 1))
                    {
                        if (this.segmentRemover !is null) {
                            this.segmentRemover.removeSegments(new Integer(matcher.group(1)));
                        }
                        this.state = ModifierState.SEGMENT_FOUND;
                    }
                    return this.factory.skipEntireBuffer(characterBuffer, firstModifiableCharacterInBuffer, endOfStreamHit);
            }
            throw new IllegalStateException("state " + this.state + " not supported");
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.ManifestTranscodeInputStreamModifier
* JD-Core Version:    0.7.0.1
*/