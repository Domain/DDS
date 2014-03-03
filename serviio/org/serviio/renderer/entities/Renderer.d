module org.serviio.renderer.entities.Renderer;

import java.lang;

public class Renderer
{
    private String uuid;
    private String ipAddress;
    private String name;
    private String profileId;
    private bool manuallyAdded;
    private bool forcedProfile;
    private bool enabled = true;
    private Long accessGroupId;

    public this(String uuid, String ipAddress, String name, String profileId, bool manuallyAdded, bool forcedProfile, bool enabled, Long accessGroupId)
    {
        this.uuid = uuid;
        this.ipAddress = ipAddress;
        this.name = name;
        this.profileId = profileId;
        this.manuallyAdded = manuallyAdded;
        this.forcedProfile = forcedProfile;
        this.enabled = enabled;
        this.accessGroupId = accessGroupId;
    }

    public String getUuid()
    {
        return this.uuid;
    }

    public String getIpAddress()
    {
        return this.ipAddress;
    }

    public String getName()
    {
        return this.name;
    }

    public String getProfileId()
    {
        return this.profileId;
    }

    public void setProfileId(String forcedProfileId)
    {
        this.profileId = forcedProfileId;
    }

    public void setIpAddress(String ipAddress)
    {
        this.ipAddress = ipAddress;
    }

    public bool isManuallyAdded()
    {
        return this.manuallyAdded;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public bool isForcedProfile()
    {
        return this.forcedProfile;
    }

    public void setForcedProfile(bool forcedProfile)
    {
        this.forcedProfile = forcedProfile;
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

    public override hash_t toHash()
    {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.uuid is null ? 0 : this.uuid.hashCode());
        return result;
    }

    public override equals_t opEquals(Object obj)
    {
        if (this == obj) {
            return true;
        }
        if (obj is null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        Renderer other = cast(Renderer)obj;
        if (this.uuid is null)
        {
            if (other.uuid !is null) {
                return false;
            }
        }
        else if (!this.uuid.equals(other.uuid)) {
            return false;
        }
        return true;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("Renderer [uuid=").append(this.uuid).append(", ipAddress=").append(this.ipAddress).append(", name=").append(this.name).append(", profileId=").append(this.profileId).append(", manuallyAdded=").append(this.manuallyAdded).append(", forcedProfile=").append(this.forcedProfile).append(", enabled=").append(this.enabled).append(", accessGroupId=").append(this.accessGroupId).append("]");

        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.renderer.entities.Renderer
* JD-Core Version:    0.7.0.1
*/