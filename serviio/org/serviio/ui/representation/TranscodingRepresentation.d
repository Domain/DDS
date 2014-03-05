module org.serviio.ui.representation.TranscodingRepresentation;

import java.lang;

public class TranscodingRepresentation
{
    private bool audioDownmixing;
    private Integer threadsNumber;
    private String transcodingFolderLocation;
    private bool transcodingEnabled;
    private bool bestVideoQuality;

    public bool isAudioDownmixing()
    {
        return this.audioDownmixing;
    }

    public void setAudioDownmixing(bool audioDownmixing)
    {
        this.audioDownmixing = audioDownmixing;
    }

    public Integer getThreadsNumber()
    {
        return this.threadsNumber;
    }

    public void setThreadsNumber(Integer threadsNumber)
    {
        this.threadsNumber = threadsNumber;
    }

    public String getTranscodingFolderLocation()
    {
        return this.transcodingFolderLocation;
    }

    public void setTranscodingFolderLocation(String transcodingFolderLocation)
    {
        this.transcodingFolderLocation = transcodingFolderLocation;
    }

    public bool isTranscodingEnabled()
    {
        return this.transcodingEnabled;
    }

    public void setTranscodingEnabled(bool transcodingEnabled)
    {
        this.transcodingEnabled = transcodingEnabled;
    }

    public bool isBestVideoQuality()
    {
        return this.bestVideoQuality;
    }

    public void setBestVideoQuality(bool bestVideoQuality)
    {
        this.bestVideoQuality = bestVideoQuality;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.TranscodingRepresentation
* JD-Core Version:    0.7.0.1
*/