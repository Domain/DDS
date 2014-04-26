module org.serviio.library.local.metadata.extractor.embedded.h264.AnnexBNALUnitReader;

import java.io.IOException;
import java.util.Arrays;
import org.serviio.library.local.metadata.extractor.embedded.h264.NALUnitReader;
import org.serviio.library.local.metadata.extractor.embedded.h264.BufferWrapper;

public class AnnexBNALUnitReader : NALUnitReader
{
    private BufferWrapper src;

    public this(BufferWrapper src)
    {
        this.src = src;
    }

    public BufferWrapper nextNALUnit()
    {
        if (this.src.remaining() < 5L) {
            return null;
        }
        long start = -1L;
        do
        {
            byte[] marker = new byte[4];
            if (this.src.remaining() >= 4L)
            {
                this.src.read(marker);
                if ((cast(byte[])[ 0, 0, 0, 1 ] == marker))
                {
                    if (start == -1L)
                    {
                        start = this.src.position();
                    }
                    else
                    {
                        this.src.position(this.src.position() - 4L);
                        return this.src.getSegment(start, this.src.position() - start);
                    }
                }
                else {
                    this.src.position(this.src.position() - 3L);
                }
            }
            else
            {
                return this.src.getSegment(start, this.src.size() - start);
            }
        } while (this.src.remaining() > 0L);
        return this.src.getSegment(start, this.src.position());
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.AnnexBNALUnitReader
* JD-Core Version:    0.7.0.1
*/