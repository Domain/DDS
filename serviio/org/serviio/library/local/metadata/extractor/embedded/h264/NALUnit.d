module org.serviio.library.local.metadata.extractor.embedded.h264.NALUnit;

import java.lang.String;
import java.io.IOException;
import java.io.OutputStream;
import org.serviio.library.local.metadata.extractor.embedded.h264.NALUnitType;
import org.serviio.library.local.metadata.extractor.embedded.h264.BufferWrapper;

public class NALUnit
{
    public NALUnitType type;
    public int nal_ref_idc;

    public this(NALUnitType type, int nal_ref_idc)
    {
        this.type = type;
        this.nal_ref_idc = nal_ref_idc;
    }

    public static NALUnit read(BufferWrapper ins)
    {
        int nalu = ins.read();
        int nal_ref_idc = nalu >> 5 & 0x3;
        int nb = nalu & 0x1F;

        NALUnitType type = NALUnitType.fromValue(nb);
        return new NALUnit(type, nal_ref_idc);
    }

    public void write(OutputStream os)
    {
        int nalu = this.type.getValue() | this.nal_ref_idc << 5;
        os.write(nalu);
    }

    override public String toString()
    {
        return "NALUnit{type=" + this.type + ", nal_ref_idc=" + this.nal_ref_idc + '}';
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.NALUnit
* JD-Core Version:    0.7.0.1
*/