module org.serviio.library.local.metadata.ImageMetadata;

import java.lang.Integer;
import org.serviio.dlna.ImageContainer;
import org.serviio.dlna.SamplingMode;
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.library.local.metadata.LocalItemMetadata;

public class ImageMetadata : LocalItemMetadata
{
    private ImageContainer container;
    private Integer width;
    private Integer height;
    private Integer colorDepth;
    private Integer exifRotation;
    private SamplingMode chromaSubsampling;

    public void merge(LocalItemMetadata additionalMetadata)
    {
        if (( cast(ImageMetadata)additionalMetadata !is null ))
        {
            ImageMetadata additionalImageMetadata = cast(ImageMetadata)additionalMetadata;

            super.merge(additionalImageMetadata);
            if (this.container is null) {
                setContainer(additionalImageMetadata.getContainer());
            }
            if (this.width is null) {
                setWidth(additionalImageMetadata.getWidth());
            }
            if (this.height is null) {
                setHeight(additionalImageMetadata.getHeight());
            }
            if (this.colorDepth is null) {
                setColorDepth(additionalImageMetadata.getColorDepth());
            }
            if (this.exifRotation is null) {
                setExifRotation(additionalImageMetadata.getExifRotation());
            }
            if (this.chromaSubsampling is null) {
                setChromaSubsampling(additionalImageMetadata.getChromaSubsampling());
            }
        }
    }

    public void fillInUnknownEntries()
    {
        super.fillInUnknownEntries();
    }

    public void validateMetadata()
    {
        super.validateMetadata();
        if (this.container is null) {
            throw new InvalidMetadataException("Unknown image file type.");
        }
        if (this.width is null) {
            throw new InvalidMetadataException("Unknown image width.");
        }
        if (this.height is null) {
            throw new InvalidMetadataException("Unknown image height.");
        }
    }

    public Integer getColorDepth()
    {
        return this.colorDepth;
    }

    public Integer getWidth()
    {
        return this.width;
    }

    public void setWidth(Integer width)
    {
        this.width = width;
    }

    public Integer getHeight()
    {
        return this.height;
    }

    public void setHeight(Integer height)
    {
        this.height = height;
    }

    public void setColorDepth(Integer colorDepth)
    {
        this.colorDepth = colorDepth;
    }

    public ImageContainer getContainer()
    {
        return this.container;
    }

    public void setContainer(ImageContainer container)
    {
        this.container = container;
    }

    public Integer getExifRotation()
    {
        return this.exifRotation;
    }

    public void setExifRotation(Integer exifRotation)
    {
        this.exifRotation = exifRotation;
    }

    public SamplingMode getChromaSubsampling()
    {
        return this.chromaSubsampling;
    }

    public void setChromaSubsampling(SamplingMode chromaSubsampling)
    {
        this.chromaSubsampling = chromaSubsampling;
    }

    public String toString()
    {
        return String.format("ImageMetadata [title=%s, date=%s, filePath=%s, fileSize=%s, container=%s, width=%s, height=%s, colorDepth=%s, sampling=%s]", cast(Object[])[ this.title, this.date, this.filePath, Long.valueOf(this.fileSize), this.container, this.width, this.height, this.colorDepth, this.chromaSubsampling ]);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.ImageMetadata
* JD-Core Version:    0.7.0.1
*/