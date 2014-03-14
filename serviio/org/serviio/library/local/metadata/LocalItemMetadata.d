module org.serviio.library.local.metadata.LocalItemMetadata;

import java.lang.String;
import java.util.ArrayList;
import java.util.List;
import org.serviio.library.local.metadata.extractor.MetadataFile;
import org.serviio.library.metadata.InvalidMetadataException;
import org.serviio.library.metadata.ItemMetadata;
import org.serviio.util.ObjectValidator;
import org.serviio.library.local.metadata.ImageDescriptor;

public abstract class LocalItemMetadata : ItemMetadata
{
    protected long fileSize;
    protected String filePath;
    protected List!(MetadataFile) metadataFiles = new ArrayList!(MetadataFile)();
    private ImageDescriptor coverImage;

    public void merge(LocalItemMetadata additionalMetadata)
    {
        if (ObjectValidator.isEmpty(this.title)) {
            setTitle(additionalMetadata.getTitle());
        }
        if (ObjectValidator.isEmpty(this.author)) {
            setAuthor(additionalMetadata.getAuthor());
        }
        if (this.date is null) {
            setDate(additionalMetadata.getDate());
        }
        if (this.fileSize == 0L) {
            setFileSize(additionalMetadata.getFileSize());
        }
        if (ObjectValidator.isEmpty(this.filePath)) {
            setFilePath(additionalMetadata.getFilePath());
        }
        if (ObjectValidator.isEmpty(this.description)) {
            setDescription(additionalMetadata.getDescription());
        }
        if (this.coverImage is null) {
            setCoverImage(additionalMetadata.getCoverImage());
        }
        this.metadataFiles.addAll(additionalMetadata.getMetadataFiles());
    }

    override public void validateMetadata()
    {
        super.validateMetadata();
        if (this.fileSize == 0L) {
            throw new InvalidMetadataException("Filesize is zero.");
        }
        if (ObjectValidator.isEmpty(this.filePath)) {
            throw new InvalidMetadataException("Filepath is empty.");
        }
    }

    public long getFileSize()
    {
        return this.fileSize;
    }

    public void setFileSize(long fileSize)
    {
        this.fileSize = fileSize;
    }

    public String getFilePath()
    {
        return this.filePath;
    }

    public void setFilePath(String filePath)
    {
        this.filePath = filePath;
    }

    public List!(MetadataFile) getMetadataFiles()
    {
        return this.metadataFiles;
    }

    public ImageDescriptor getCoverImage()
    {
        return this.coverImage;
    }

    public void setCoverImage(ImageDescriptor coverImage)
    {
        this.coverImage = coverImage;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.LocalItemMetadata
* JD-Core Version:    0.7.0.1
*/