module org.serviio.library.local.metadata.extractor.embedded.h264.NALUnit;

import java.io.IOException;
import java.io.OutputStream;

public class NALUnit
{
  public NALUnitType type;
  public int nal_ref_idc;
  
  public this(NALUnitType type, int nal_ref_idc)
  {
    this.type = type;
    this.nal_ref_idc = nal_ref_idc;
  }
  
  public static NALUnit read(BufferWrapper is)
  {
    int nalu = is.read();
    int nal_ref_idc = nalu >> 5 & 0x3;
    int nb = nalu & 0x1F;
    
    NALUnitType type = NALUnitType.fromValue(nb);
    return new NALUnit(type, nal_ref_idc);
  }
  
  public void write(OutputStream out)
  {
    int nalu = this.type.getValue() | this.nal_ref_idc << 5;
    out.write(nalu);
  }
  
  public String toString()
  {
    return "NALUnit{type=" + this.type + ", nal_ref_idc=" + this.nal_ref_idc + '}';
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.NALUnit
 * JD-Core Version:    0.7.0.1
 */