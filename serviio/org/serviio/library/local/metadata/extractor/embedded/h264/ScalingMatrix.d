module org.serviio.library.local.metadata.extractor.embedded.h264.ScalingMatrix;

import java.util.Arrays;

public class ScalingMatrix
{
  public ScalingList[] ScalingList4x4;
  public ScalingList[] ScalingList8x8;
  
  public String toString()
  {
    return "ScalingMatrix{ScalingList4x4=" + (this.ScalingList4x4 is null ? null : Arrays.asList(this.ScalingList4x4)) + "\n" + ", ScalingList8x8=" + (this.ScalingList8x8 is null ? null : Arrays.asList(this.ScalingList8x8)) + "\n" + '}';
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.ScalingMatrix
 * JD-Core Version:    0.7.0.1
 */