module org.serviio.util.ZipUtils;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.GZIPInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class ZipUtils
{
    public static InputStream unZipSingleFile(InputStream input)
    {
        ZipInputStream zis = new ZipInputStream(input);
        ZipEntry entry = zis.getNextEntry();
        if (entry is null) {
            throw new IOException("Invalid zip file");
        }
        byte[] unpackedFile = FileUtils.readFileBytes(zis);
        return new ByteArrayInputStream(unpackedFile);
    }

    public static InputStream unGzipSingleFile(InputStream input)
    {
        GZIPInputStream zis = new GZIPInputStream(input);
        byte[] unpackedFile = FileUtils.readFileBytes(zis);
        return new ByteArrayInputStream(unpackedFile);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.ZipUtils
* JD-Core Version:    0.7.0.1
*/