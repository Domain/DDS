module org.serviio.delivery.resource.transcode.TranscodingDefinition;

import java.lang.Integer;
import java.lang.util;
import org.serviio.delivery.resource.transcode.TranscodingConfiguration;

public abstract interface TranscodingDefinition : IObject
{
    public abstract Integer getAudioBitrate();

    public abstract Integer getAudioSamplerate();

    public abstract bool isForceInheritance();

    public abstract TranscodingConfiguration getTranscodingConfiguration();
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.TranscodingDefinition
* JD-Core Version:    0.6.2
*/