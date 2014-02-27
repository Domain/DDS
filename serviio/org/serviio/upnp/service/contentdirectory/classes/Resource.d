module org.serviio.upnp.service.contentdirectory.classes.Resource;

import org.serviio.delivery.DefaultResourceURLGenerator;
import org.serviio.delivery.HostInfo;
import org.serviio.delivery.ResourceURLGenerator;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.profile.DeliveryQuality:QualityType;

public class Resource
{
    private static final ResourceURLGenerator urlGenerator = new DefaultResourceURLGenerator();
    private Long resourceId;
    private ResourceType resourceType;
    private MediaFormatProfile ver;
    private Long size;
    private Integer duration;
    private Integer bitrate;
    private Integer sampleFrequency;
    private Integer bitsPerSample;
    private Integer nrAudioChannels;
    private String resolution;
    private Integer colorDepth;
    private String protocolInfo;
    private String protection;

    public static enum ResourceType
    {
        MEDIA_ITEM,  COVER_IMAGE,  SUBTITLE,  MANIFEST,  SEGMENT,
    }

    private Integer protocolInfoIndex = Integer.valueOf(0);
    private DeliveryQuality.QualityType quality;
    private Boolean transcoded;

    public this(ResourceType resourceType, Long resourceId, MediaFormatProfile ver, Integer protocolInfoIndex, DeliveryQuality.QualityType quality, Boolean transcoded)
    {
        this.resourceId = resourceId;
        this.resourceType = resourceType;
        this.ver = ver;
        this.protocolInfoIndex = protocolInfoIndex;
        this.quality = quality;
        this.transcoded = transcoded;
    }

    public Resource clone(ResourceType newType, DeliveryQuality.QualityType selectedQuality)
    {
        Resource r = new Resource(newType, this.resourceId, this.ver, this.protocolInfoIndex, selectedQuality, this.transcoded);
        r.setBitrate(this.bitrate);
        r.setBitsPerSample(this.bitsPerSample);
        r.setColorDepth(this.colorDepth);
        r.setDuration(this.duration);
        r.setNrAudioChannels(this.nrAudioChannels);
        r.setProtection(this.protection);
        r.setProtocolInfo(this.protocolInfo);
        r.setResolution(this.resolution);
        r.setSampleFrequency(this.sampleFrequency);
        r.setSize(this.size);
        return r;
    }

    public String getGeneratedURL(HostInfo hostInfo)
    {
        return urlGenerator.getGeneratedURL(hostInfo, this.resourceType, this.resourceId, this.ver, this.protocolInfoIndex, this.quality);
    }

    public Long getSize()
    {
        return this.size;
    }

    public void setSize(Long size)
    {
        this.size = size;
    }

    public Integer getDuration()
    {
        return this.duration;
    }

    public void setDuration(Integer duration)
    {
        this.duration = duration;
    }

    public String getDurationFormatted()
    {
        if (this.duration !is null)
        {
            int hours = this.duration.intValue() / 3600;
            int minutes = hours > 0 ? this.duration.intValue() % (hours * 3600) / 60 : this.duration.intValue() / 60;
            int seconds = this.duration.intValue() - (hours * 3600 + minutes * 60);
            return String.format("%d:%02d:%02d.000", cast(Object[])[ Integer.valueOf(hours), Integer.valueOf(minutes), Integer.valueOf(seconds) ]);
        }
        return null;
    }

    public Integer getBitrate()
    {
        return this.bitrate;
    }

    public void setBitrate(Integer bitrate)
    {
        this.bitrate = bitrate;
    }

    public Integer getSampleFrequency()
    {
        return this.sampleFrequency;
    }

    public void setSampleFrequency(Integer sampleFrequency)
    {
        this.sampleFrequency = sampleFrequency;
    }

    public Integer getBitsPerSample()
    {
        return this.bitsPerSample;
    }

    public void setBitsPerSample(Integer bitsPerSample)
    {
        this.bitsPerSample = bitsPerSample;
    }

    public Integer getNrAudioChannels()
    {
        return this.nrAudioChannels;
    }

    public void setNrAudioChannels(Integer nrAudioChannels)
    {
        this.nrAudioChannels = nrAudioChannels;
    }

    public String getResolution()
    {
        return this.resolution;
    }

    public void setResolution(String resolution)
    {
        this.resolution = resolution;
    }

    public Integer getColorDepth()
    {
        return this.colorDepth;
    }

    public void setColorDepth(Integer colorDepth)
    {
        this.colorDepth = colorDepth;
    }

    public String getProtocolInfo()
    {
        return this.protocolInfo;
    }

    public void setProtocolInfo(String protocolInfo)
    {
        this.protocolInfo = protocolInfo;
    }

    public String getProtection()
    {
        return this.protection;
    }

    public void setProtection(String protection)
    {
        this.protection = protection;
    }

    public ResourceType getResourceType()
    {
        return this.resourceType;
    }

    public Integer getProtocolInfoIndex()
    {
        return this.protocolInfoIndex;
    }

    public DeliveryQuality.QualityType getQuality()
    {
        return this.quality;
    }

    public Boolean isTranscoded()
    {
        return this.transcoded;
    }

    public Long getResourceId()
    {
        return this.resourceId;
    }

    public MediaFormatProfile getVersion()
    {
        return this.ver;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.Resource
* JD-Core Version:    0.7.0.1
*/