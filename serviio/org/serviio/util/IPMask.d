module org.serviio.util.IPMask;

import java.lang.String;
import java.net.UnknownHostException;

public class IPMask
{
    private String i4addr;
    private byte maskCtr;
    private int addrInt;
    private int maskInt;

    private this(String i4addr, byte mask)
    {
        this.i4addr = i4addr;
        this.maskCtr = mask;

        this.addrInt = addrToInt(i4addr);
        this.maskInt = ((1 << 32 - this.maskCtr) - 1 ^ 0xFFFFFFFF);
    }

    public static IPMask getIPMask(String addrSlashMask)
    {
        int pos = addrSlashMask.indexOf('/');
        byte maskCtr;
        String addr;
        byte maskCtr;
        if (pos == -1)
        {
            String addr = addrSlashMask;
            maskCtr = 32;
        }
        else
        {
            addr = addrSlashMask.substring(0, pos);
            maskCtr = Byte.parseByte(addrSlashMask.substring(pos + 1));
        }
        return new IPMask(addr, maskCtr);
    }

    public bool matches(byte[] testAddr)
    {
        int testAddrInt = addrToInt(testAddr);
        return (this.addrInt & this.maskInt) == (testAddrInt & this.maskInt);
    }

    public bool matches(String addr)
    {
        return matches(textToNumericFormatV4(addr));
    }

    private static int addrToInt(String i4addr)
    {
        byte[] ba = textToNumericFormatV4(i4addr);
        return addrToInt(ba);
    }

    private static int addrToInt(byte[] ba)
    {
        return ba[0] << 24 | (ba[1] & 0xFF) << 16 | (ba[2] & 0xFF) << 8 | ba[3] & 0xFF;
    }

    override public String toString()
    {
        return "IPMask(" ~ this.i4addr ~ "/" ~ this.maskCtr ~ ")";
    }

    public override equals_t opEquals(Object obj)
    {
        if (obj is null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        IPMask that = cast(IPMask)obj;
        return (this.addrInt == that.addrInt) && (this.maskInt == that.maskInt);
    }

    public override hash_t toHash()
    {
        return this.maskInt + this.addrInt;
    }

    public static byte[] textToNumericFormatV4(String src)
    {
        if (src.length() == 0) {
            return null;
        }
        byte[] res = new byte[4];
        String[] s = src.trim().split("\\.", -1);
        try
        {
            long val;
            long val;
            switch (s.length)
            {
                case 1: 
                    val = Long.parseLong(s[0]);
                    if ((val < 0L) || (val > 4294967295L)) {
                        return null;
                    }
                    res[0] = (cast(byte)cast(int)(val >> 24 & 0xFF));
                    res[1] = (cast(byte)cast(int)((val & 0xFFFFFF) >> 16 & 0xFF));
                    res[2] = (cast(byte)cast(int)((val & 0xFFFF) >> 8 & 0xFF));
                    res[3] = (cast(byte)cast(int)(val & 0xFF));
                    break;
                case 2: 
                    val = Integer.parseInt(s[0]);
                    if ((val < 0L) || (val > 255L)) {
                        return null;
                    }
                    res[0] = (cast(byte)cast(int)(val & 0xFF));
                    val = Integer.parseInt(s[1]);
                    if ((val < 0L) || (val > 16777215L)) {
                        return null;
                    }
                    res[1] = (cast(byte)cast(int)(val >> 16 & 0xFF));
                    res[2] = (cast(byte)cast(int)((val & 0xFFFF) >> 8 & 0xFF));
                    res[3] = (cast(byte)cast(int)(val & 0xFF));
                    break;
                case 3: 
                    for (int i = 0; i < 2; i++)
                    {
                        val = Integer.parseInt(s[i]);
                        if ((val < 0L) || (val > 255L)) {
                            return null;
                        }
                        res[i] = (cast(byte)cast(int)(val & 0xFF));
                    }
                    val = Integer.parseInt(s[2]);
                    if ((val < 0L) || (val > 65535L)) {
                        return null;
                    }
                    res[2] = (cast(byte)cast(int)(val >> 8 & 0xFF));
                    res[3] = (cast(byte)cast(int)(val & 0xFF));
                    break;
                case 4: 
                    for (int i = 0; i < 4; i++)
                    {
                        val = Integer.parseInt(s[i]);
                        if ((val < 0L) || (val > 255L)) {
                            return null;
                        }
                        res[i] = (cast(byte)cast(int)(val & 0xFF));
                    }
                    break;
                default: 
                    return null;
            }
        }
        catch (NumberFormatException e)
        {
            return null;
        }
        return res;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.IPMask
* JD-Core Version:    0.7.0.1
*/