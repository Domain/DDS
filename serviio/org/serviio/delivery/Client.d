module org.serviio.delivery.Client;

import java.lang.String;
import org.serviio.profile.Profile;
import org.serviio.delivery.HostInfo;

public class Client
{
    private immutable String clientIdentifier;
    private Profile rendererProfile;
    private HostInfo hostInfo;
    private bool expectsClosedConnection = false;
    private bool supportsRandomTimeSeek = false;

    public this(String clientIdentifier, Profile rendererProfile, HostInfo hostInfo)
    {
        this.clientIdentifier = clientIdentifier;
        this.rendererProfile = rendererProfile;
        this.hostInfo = hostInfo;
    }

    public Profile getRendererProfile()
    {
        return this.rendererProfile;
    }

    public bool isExpectsClosedConnection()
    {
        return this.expectsClosedConnection;
    }

    public void setExpectsClosedConnection(bool expectsClosedConnection)
    {
        this.expectsClosedConnection = expectsClosedConnection;
    }

    public bool isSupportsRandomTimeSeek()
    {
        return this.supportsRandomTimeSeek;
    }

    public void setSupportsRandomTimeSeek(bool supportsRandomTimeSeek)
    {
        this.supportsRandomTimeSeek = supportsRandomTimeSeek;
    }

    public HostInfo getHostInfo()
    {
        return this.hostInfo;
    }

    public override hash_t toHash()
    {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.clientIdentifier is null ? 0 : this.clientIdentifier.hashCode());
        result = 31 * result + (this.rendererProfile is null ? 0 : this.rendererProfile.hashCode());
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
        Client other = cast(Client)obj;
        if (this.clientIdentifier is null)
        {
            if (other.clientIdentifier !is null) {
                return false;
            }
        }
        else if (!this.clientIdentifier.equals(other.clientIdentifier)) {
            return false;
        }
        if (this.rendererProfile is null)
        {
            if (other.rendererProfile !is null) {
                return false;
            }
        }
        else if (!this.rendererProfile.equals(other.rendererProfile)) {
            return false;
        }
        return true;
    }

    override public String toString()
    {
        return String.format("Identifier=%s, Profile=%s", cast(Object[])[ this.clientIdentifier, this.rendererProfile ]);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.Client
* JD-Core Version:    0.7.0.1
*/