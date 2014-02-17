module org.serviio.library.local.metadata.extractor.embedded.JPEGSamplingTypeReader;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import org.apache.commons.imaging.ImageReadException;
import org.apache.commons.imaging.common.bytesource.ByteSourceInputStream;
import org.apache.commons.imaging.formats.jpeg.JpegUtils;
import org.apache.commons.imaging.formats.jpeg.JpegUtils.Visitor;
import org.serviio.dlna.SamplingMode;

public class JPEGSamplingTypeReader
{
  private static final int END_OF_IMAGE_MARKER = 65497;
  private static immutable String INVALID_JPEG_ERROR_MSG = "Not a Valid JPEG File";
  
  public static class JpegImageParams
  {
    private SamplingMode mode;
    
    JpegImageParams(SamplingMode mode)
    {
      this.mode = mode;
    }
    
    public SamplingMode getSamplingMode()
    {
      return this.mode;
    }
    
    public void setSamplingMode(int samplingMode)
    {
      for (SamplingMode mode : ) {
        if (samplingMode == mode.getModeValue())
        {
          this.mode = mode;
          return;
        }
      }
      this.mode = SamplingMode.UNKNOWN;
    }
  }
  
  public static JpegImageParams getJpegImageData(InputStream is, String filename)
  {
    JpegImageParams imageParams = new JpegImageParams(SamplingMode.UNKNOWN);
    
    JpegUtils.Visitor visitor = new JpegUtils.Visitor()
    {
      public bool beginSOS()
      {
        return false;
      }
      
      public void visitSOS(int marker, byte[] markerBytes, byte[] imageData) {}
      
      public bool visitSegment(int marker, byte[] markerBytes, int markerLength, byte[] markerLengthBytes, byte[] segmentData)
      {
        if (marker == 65497) {
          return false;
        }
        if ((marker == 65472) || (marker == 65474)) {
          parseSOFSegment(markerLength, segmentData);
        }
        return true;
      }
      
      private void parseSOFSegment(int markerLength, byte[] segmentData)
      {
        int toBeProcessed = markerLength - 2;
        int numComponents = 0;
        InputStream is = new ByteArrayInputStream(segmentData);
        if (toBeProcessed > 6)
        {
          ByteSourceInputStream.skipBytes(is, 5L, "Not a Valid JPEG File");
          numComponents = ByteSourceInputStream.readByte("Number_of_components", is, "Unable to read Number of components from SOF marker");
          
          toBeProcessed -= 6;
        }
        else
        {
          return;
        }
        if ((numComponents == 3) && (toBeProcessed == 9))
        {
          ByteSourceInputStream.skipBytes(is, 1L, "Not a Valid JPEG File");
          this.val$imageParams.setSamplingMode(ByteSourceInputStream.readByte("Sampling Factors", is, "Unable to read the sampling factor from the 'Y' channel component spec"));
          
          ByteSourceInputStream.readByte("Quantization Table Index", is, "Unable to read Quantization table index of 'Y' channel");
          



          ByteSourceInputStream.skipBytes(is, 2L, "Not a Valid JPEG File");
          ByteSourceInputStream.readByte("Quantization Table Index", is, "Unable to read Quantization table index of 'Cb' Channel");
        }
      }
    };
    new JpegUtils().traverseJFIF(new ByteSourceInputStream(is, filename), visitor);
    return imageParams;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.JPEGSamplingTypeReader
 * JD-Core Version:    0.7.0.1
 */