module org.serviio.util.NicIP;

import java.lang.String;
import java.net.InetAddress;
import java.net.NetworkInterface;

public class NicIP
{
    private InetAddress ip;
    private NetworkInterface nic;
    private int ipIndex;

    public this(NetworkInterface nic, InetAddress ip, int ipIndex)
    {
        this.ip = ip;
        this.nic = nic;
        this.ipIndex = ipIndex;
    }

    public InetAddress getIp()
    {
        return this.ip;
    }

    public NetworkInterface getNic()
    {
        return this.nic;
    }

    public String getNicName()
    {
        return this.nic.getName();
    }

    public int getIpIndex()
    {
        return this.ipIndex;
    }

    public String nameWithIndex()
    {
        return String.format("%s-%s", cast(Object[])[ getNicName(), Integer.valueOf(this.ipIndex) ]);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.NicIP
* JD-Core Version:    0.7.0.1
*/