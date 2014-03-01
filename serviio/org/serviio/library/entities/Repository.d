module org.serviio.library.entities.Repository;

import java.lang;
import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Set;
import org.serviio.db.entities.PersistedEntity;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.ObjectValidator;

public class Repository : PersistedEntity
{
    private File folder;
    private Set!(MediaFileType) supportedFileTypes;
    private bool supportsDescriptiveMetadata;
    private bool keepScanningForUpdates;
    private Date lastScanned;
    private List!(Long) accessGroupIds;

    public this(File folder, Set!(MediaFileType) supportedFileTypes, bool supportsDescriptiveMetadata, bool keepScanningForUpdates)
    {
        this.folder = folder;
        this.supportedFileTypes = supportedFileTypes;
        this.supportsDescriptiveMetadata = supportsDescriptiveMetadata;
        this.keepScanningForUpdates = keepScanningForUpdates;
    }

    public String getRepositoryName()
    {
        return ObjectValidator.isNotEmpty(this.folder.getName()) ? this.folder.getName() : this.folder.getPath();
    }

    public File getFolder()
    {
        return this.folder;
    }

    public Set!(MediaFileType) getSupportedFileTypes()
    {
        return this.supportedFileTypes;
    }

    public bool isSupportsDescriptiveMetadata()
    {
        return this.supportsDescriptiveMetadata;
    }

    public bool isKeepScanningForUpdates()
    {
        return this.keepScanningForUpdates;
    }

    public Date getLastScanned()
    {
        return this.lastScanned;
    }

    public void setLastScanned(Date lastScanned)
    {
        this.lastScanned = lastScanned;
    }

    public List!(Long) getAccessGroupIds()
    {
        return this.accessGroupIds;
    }

    public void setAccessGroupIds(List!(Long) accessGroupIds)
    {
        this.accessGroupIds = accessGroupIds;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("Repository [id=").append(this.id).append(", folder=").append(this.folder).append(", keepScanningForUpdates=").append(this.keepScanningForUpdates).append(", lastScanned=").append(this.lastScanned).append(", supportedFileTypes=").append(this.supportedFileTypes).append(", supportsDescriptiveMetadata=").append(this.supportsDescriptiveMetadata).append("]");

        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.entities.Repository
* JD-Core Version:    0.7.0.1
*/