module org.serviio.library.local.metadata.extractor.embedded.h264.NALUnitReader;

import java.io.IOException;
import org.serviio.library.local.metadata.extractor.embedded.h264.BufferWrapper;

public abstract interface NALUnitReader
{
    public abstract BufferWrapper nextNALUnit();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.NALUnitReader
* JD-Core Version:    0.7.0.1
*/