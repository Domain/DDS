module org.serviio.dlna.H264Profile;

public enum H264Profile
{
  C_BASELINE,  BASELINE,  MAIN,  EXTENDED,  HIGH,  HIGH_10,  HIGH_422,  HIGH_444;
  
  private this() {}
  
  public abstract int getCode();
  
  public Boolean isConstrained()
  {
    return null;
  }
  
  public static H264Profile getByCode(int code, bool constrained)
  {
    for (H264Profile p : ) {
      if ((p.getCode() == code) && ((p.isConstrained() is null) || (p.isConstrained().equals(Boolean.valueOf(constrained))))) {
        return p;
      }
    }
    return null;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.dlna.H264Profile
 * JD-Core Version:    0.7.0.1
 */