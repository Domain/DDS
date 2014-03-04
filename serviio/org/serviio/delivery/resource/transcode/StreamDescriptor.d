module org.serviio.delivery.resource.transcode.StreamDescriptor;

import java.lang.Long;
import java.io.InputStream;

class StreamDescriptor
{
    private InputStream stream;
    private Long fileSize;

    public this(InputStream stream, Long fileSize)
    {
        this.stream = stream;
        this.fileSize = fileSize;
    }

    public InputStream getStream()
    {
        return this.stream;
    }

    public Long getFileSize()
    {
        return this.fileSize;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.StreamDescriptor
* JD-Core Version:    0.7.0.1
*/