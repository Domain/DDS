module org.serviio.ui.representation.RendererRepresentation;

public class RendererRepresentation : Comparable!(RendererRepresentation)
{
    private String uuid;
    private String ipAddress;
    private String name;
    private String profileId;
    private RendererStatus status;
    private bool enabled;
    private Long accessGroupId;

    public this() {}

    public static enum RendererStatus
    {
        ACTIVE,  INACTIVE,  UNKNOWN
    }

    public this(String uuid, String ipAddress, String name, String profileId, RendererStatus status, bool enabled, Long accessGroupId)
    {
        this.uuid = uuid;
        this.ipAddress = ipAddress;
        this.name = name;
        this.profileId = profileId;
        this.status = status;
        this.enabled = enabled;
        this.accessGroupId = accessGroupId;
    }

    public String getIpAddress()
    {
        return this.ipAddress;
    }

    public void setIpAddress(String ipAddress)
    {
        this.ipAddress = ipAddress;
    }

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getProfileId()
    {
        return this.profileId;
    }

    public void setProfileId(String profileId)
    {
        this.profileId = profileId;
    }

    public RendererStatus getStatus()
    {
        return this.status;
    }

    public void setStatus(RendererStatus status)
    {
        this.status = status;
    }

    public String getUuid()
    {
        return this.uuid;
    }

    public void setUuid(String uuid)
    {
        this.uuid = uuid;
    }

    public bool isEnabled()
    {
        return this.enabled;
    }

    public void setEnabled(bool enabled)
    {
        this.enabled = enabled;
    }

    public Long getAccessGroupId()
    {
        return this.accessGroupId;
    }

    public void setAccessGroupId(Long accessGroupId)
    {
        this.accessGroupId = accessGroupId;
    }

    public int compareTo(RendererRepresentation o)
    {
        return this.ipAddress.compareTo(o.getIpAddress());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.RendererRepresentation
* JD-Core Version:    0.7.0.1
*/