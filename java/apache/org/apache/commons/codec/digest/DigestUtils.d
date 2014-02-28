module org.apache.commons.codec.digest.DigestUtils;

import std.digest.md;

import java.lang.String;

public class DigestUtils
{
    public static String md5Hex(String data)
    {
        return toHexString(md5Of(data));
    }
}