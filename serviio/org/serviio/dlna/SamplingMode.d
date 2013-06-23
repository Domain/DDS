module org.serviio.dlna.SamplingMode;

enum SamplingMode
{
    UNKNOWN = (-2), DEFAULT = (-1), YUV444 = (17), YUV422 = (33), YUV420 = (34), YUV411 = (65)
}

public int getModeValue(SamplingMode samplingMode)
{
    return cast(int)samplingMode;//mode;
}

//public class SamplingMode
//{
//    enum SamplingModeEnum
//    {
//        UNKNOWN = (-2), DEFAULT = (-1), YUV444 = (17), YUV422 = (33), YUV420 = (34), YUV411 = (65)
//    }
//
//    SamplingModeEnum samplingMode;
//    alias samplingMode this;
//
//  //private int mode;
//  //
//  //private this(int mode) { this.mode = mode; }
//
//  public int getModeValue()
//  {
//    return cast(int)samplingMode;//mode;
//  }
//}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
 * Qualified Name:     org.serviio.dlna.SamplingMode
 * JD-Core Version:    0.6.2
 */