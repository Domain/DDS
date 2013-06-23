module org.serviio.dlna.ImageContainer;

import java.lang.String;

enum ImageContainer
{
    JPEG, PNG, GIF, RAW
}

public ImageContainer getByName(String name) {
    if (name !is null) {
        if (name.equals("jpeg"))
            return JPEG;
        if (name.equals("gif"))
            return GIF;
        if (name.equals("png"))
            return PNG;
        if (name.equals("raw")) {
            return RAW;
        }
    }
    return null;
}

//public class ImageContainer
//{
//    enum ImageContainerEnum
//    {
//        JPEG, PNG, GIF, RAW
//    }
//
//    ImageContainerEnum imageContainer;
//    alias imageContainer this;
//
//    public static ImageContainer getByName(String name) {
//        if (name !is null) {
//            if (name.equals("jpeg"))
//                return JPEG;
//            if (name.equals("gif"))
//                return GIF;
//            if (name.equals("png"))
//                return PNG;
//            if (name.equals("raw")) {
//                return RAW;
//            }
//        }
//        return null;
//    }
//
//    public override bool opEquals(Object o)
//    {
//        if (is(o : ImageContainer))
//        {
//            return this.imageContainer == cast(ImageContainer)o.imageContainer;
//        }
//        else if (is(o : ImageContainerEnum))
//        {
//            return this.imageContainer == o;
//        }
//        return false;
//    }
//
//    public bool opEquals(ImageContainerEnum rhs)
//    {
//        return this.imageContainer == rhs;
//    }
//}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.dlna.ImageContainer
* JD-Core Version:    0.6.2
*/