module org.serviio.dlna.H264Profile;

enum H264Profile
{
    C_BASELINE  = 66, 
    BASELINE    = 66, 
    MAIN        = 77, 
    EXTENDED    = 88, 
    HIGH        = 100, 
    HIGH_10     = 110, 
    HIGH_422    = 122, 
    HIGH_444    = 244,
}

public int getCode(H264Profile h264Profile)
{
    return cast(int)h264Profile;
}

public bool isConstrained(H264Profile h264Profile)
{
    if (h264Profile == C_BASELINE)
        return true;
    return false;
}

public H264Profile getByCode(int code, bool constrained)
{
    foreach (immutable p; [EnumMembers!H264Profile])
    {
        if (p.getCode() == code && (!p.isConstrained() || p.isConstrained() == constrained)) 
        {
            return p;
        }
    }
    return MAIN;
}

/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.dlna.H264Profile
 * JD-Core Version:    0.7.0.1
 */