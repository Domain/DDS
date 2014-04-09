module org.serviio.dlna.DisplayAspectRatio;

import java.lang.String;
import java.lang.IllegalArgumentException;
import java.text.DecimalFormat;

enum DisplayAspectRatio : int[2]
{
    DAR_16_9 = [16, 9],
}

public float getRatio(DisplayAspectRatio displayAspectRatio) {
    //return x / y;
    return displayAspectRatio[0] / displayAspectRatio[1];
}

public float getRatio(int width, int height) {
    return width / height;
}

public bool isEqualTo(DisplayAspectRatio displayAspectRatio, int width, int height) {
    auto df = new DecimalFormat("##.##");
    return df.format(getRatio(displayAspectRatio)).opEquals(df.format(getRatio(width, height)));
}

public DisplayAspectRatio fromString(String dar) {
    if (dar.equals("16:9")) {
        return DisplayAspectRatio.DAR_16_9;
    }
    throw new IllegalArgumentException("DAR " ~ dar ~ "is not supported");
}

//public enum DisplayAspectRatio
//{
//  DAR_16_9(16, 9);
//  
//  private int x;
//  private int y;
//  private static DecimalFormat df = new DecimalFormat("##.##");
//  
//  private this(int x, int y)
//  {
//    this.x = x;
//    this.y = y;
//  }
//  
//  public float getRatio()
//  {
//    return this.x / this.y;
//  }
//  
//  public static float getRatio(int width, int height, float sar)
//  {
//    return sar * width / height;
//  }
//  
//  public bool isEqualTo(int width, int height, float sar)
//  {
//    return df.format(getRatio()).opEquals(df.format(getRatio(width, height, sar)));
//  }
//  
//  public static DisplayAspectRatio fromString(String dar)
//  {
//    if (dar.equals("16:9")) {
//      return DAR_16_9;
//    }
//    throw new IllegalArgumentException("DAR " + dar + "is not supported");
//  }
//}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.dlna.DisplayAspectRatio
 * JD-Core Version:    0.7.0.1
 */