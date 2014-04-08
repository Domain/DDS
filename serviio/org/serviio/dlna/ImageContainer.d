module org.serviio.dlna.ImageContainer;

import java.lang.String;

public enum ImageContainer
{
    JPEG,  PNG,  GIF,  RAW,  INVALID
}

public ImageContainer getByName(String name)
{
    if (name !is null)
    {
        if (name.equals("jpeg")) {
            return ImageContainer.JPEG;
        }
        if (name.equals("gif")) {
            return ImageContainer.GIF;
        }
        if (name.equals("png")) {
            return ImageContainer.PNG;
        }
        if (name.equals("raw")) {
            return ImageContainer.RAW;
        }
    }
    return ImageContainer.INVALID;
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.ImageContainer
* JD-Core Version:    0.7.0.1
*/