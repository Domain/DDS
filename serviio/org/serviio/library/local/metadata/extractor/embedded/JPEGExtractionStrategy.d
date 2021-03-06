module org.serviio.library.local.metadata.extractor.embedded.JPEGExtractionStrategy;

import java.lang;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.imaging.ImageReadException;
import org.apache.commons.imaging.Imaging;
import org.apache.commons.imaging.common.IImageMetadata;
import org.apache.commons.imaging.common.bytesource.ByteSource;
import org.apache.commons.imaging.formats.jpeg.JpegImageMetadata;
import org.apache.commons.imaging.formats.tiff.TiffField;
import org.apache.commons.imaging.formats.tiff.constants.TiffConstants;
import org.serviio.dlna.ImageContainer;
import org.serviio.dlna.SamplingMode;
import org.serviio.library.local.metadata.ImageMetadata;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.serviio.library.local.metadata.extractor.embedded.ImageExtractionStrategy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JPEGExtractionStrategy : ImageExtractionStrategy
{
    private static DateFormat exifDF;
    private static Logger log;

    static this()
    {
        exifDF = new SimpleDateFormat("''yyyy:MM:dd HH:mm:ss''");
        log = LoggerFactory.getLogger!(JPEGExtractionStrategy);
    }

    override public void extractMetadata(ImageMetadata metadata, ByteSource f)
    {
        super.extractMetadata(metadata, f);
        try
        {
            IImageMetadata imageMetadata = Imaging.getMetadata(f.getInputStream(), f.getFilename());
            if ((imageMetadata !is null) && (( cast(JpegImageMetadata)imageMetadata !is null )))
            {
                JpegImageMetadata jpegMetadata = cast(JpegImageMetadata)imageMetadata;


                TiffField dateField = jpegMetadata.findEXIFValue(TiffConstants.EXIF_TAG_DATE_TIME_ORIGINAL);
                if (dateField is null) {
                    dateField = jpegMetadata.findEXIFValue(TiffConstants.TIFF_TAG_DATE_TIME);
                }
                Date createdDate = dateField !is null ? exifDF.parse(dateField.getValueDescription()) : null;
                metadata.setDate(createdDate);
                metadata.setExifRotation(getRotation(jpegMetadata));
            }
            try
            {
                JPEGSamplingTypeReader.JpegImageParams params = JPEGSamplingTypeReader.getJpegImageData(f.getInputStream(), f.getFilename());
                metadata.setChromaSubsampling(params.getSamplingMode());
            }
            catch (Exception e)
            {
                metadata.setChromaSubsampling(SamplingMode.UNKNOWN);
            }
        }
        catch (ImageReadException e)
        {
            log.debug_(java.lang.String.format("Cannot read file %s for metadata extraction. Message: %s", cast(Object[])[ f.getFilename(), e.getMessage() ]));
        }
        catch (ParseException e) {}catch (OutOfMemoryError e)
        {
            log.debug_(java.lang.String.format("Cannot get metadata of file %s because of OutOfMemory error. The file is dodgy, but will still be added to the library.", cast(Object[])[ f.getFilename() ]));
        }
        catch (IOException e)
        {
            log.debug_(java.lang.String.format("Cannot read EXIF metadata for file %s. Message: %s", cast(Object[])[ f.getFilename(), e.getMessage() ]));
        }
    }

    override protected ImageContainer getContainer()
    {
        return ImageContainer.JPEG;
    }

    protected Integer getRotation(JpegImageMetadata jpegMetadata)
    {
        TiffField rotation = jpegMetadata.findEXIFValue(TiffConstants.TIFF_TAG_ORIENTATION);
        if (rotation !is null)
        {
            if (rotation.getIntValue() == 3) {
                return Integer.valueOf(180);
            }
            if (rotation.getIntValue() == 8) {
                return Integer.valueOf(270);
            }
            if (rotation.getIntValue() == 6) {
                return Integer.valueOf(90);
            }
            return Integer.valueOf(0);
        }
        return Integer.valueOf(0);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.JPEGExtractionStrategy
* JD-Core Version:    0.7.0.1
*/