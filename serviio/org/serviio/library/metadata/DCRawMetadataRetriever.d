module org.serviio.library.metadata.DCRawMetadataRetriever;

import java.io.IOException;
import org.apache.commons.imaging.common.bytesource.ByteSource;
import org.apache.commons.imaging.common.bytesource.ByteSourceArray;
import org.serviio.dlna.ImageContainer;
import org.serviio.external.DCRawWrapper;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.local.metadata.ImageMetadata;
import org.serviio.library.local.metadata.extractor.InvalidMediaFormatException;
import org.serviio.library.local.metadata.extractor.embedded.JPEGExtractionStrategy;

public class DCRawMetadataRetriever
{
  public static void retrieveImageMetadata(ImageMetadata md, String imageLocation, bool local)
  {
    if (!local) {
      throw new IOException("dcraw doesn't support online images");
    }
    byte[] imageBytes = DCRawWrapper.retrieveThumbnailFromRawFile(imageLocation);
    if ((imageBytes !is null) && (imageBytes.length > 0))
    {
      ByteSource byteSource = new ByteSourceArray(imageLocation, imageBytes);
      new JPEGExtractionStrategy().extractMetadata(md, byteSource);
      md.setContainer(ImageContainer.RAW);
      
      ImageDescriptor imageDesc = new ImageDescriptor(imageBytes, "image/jpeg");
      md.setCoverImage(imageDesc);
      imageBytes = null;
    }
    else
    {
      throw new InvalidMediaFormatException(String.format("Cannot read raw image file %s using dcraw", cast(Object[])[ imageLocation ]));
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.metadata.DCRawMetadataRetriever
 * JD-Core Version:    0.7.0.1
 */