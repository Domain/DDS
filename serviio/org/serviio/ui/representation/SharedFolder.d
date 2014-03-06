module org.serviio.ui.representation.SharedFolder;

import java.lang;
import java.util.LinkedHashSet;
import java.util.Set;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.CollectionUtils;
import org.serviio.ui.representation.WithAccessGroups;

public class SharedFolder : WithAccessGroups
{
    private Long id;
    private String folderPath;
    private Set!(MediaFileType) supportedFileTypes;
    private bool descriptiveMetadataSupported;
    private bool scanForUpdates;
    private LinkedHashSet!(Long) accessGroupIds;

    public this() {}

    public this(String folderPath, Set!(MediaFileType) supportedFileTypes, bool descMetadataEnabled, bool scanForUpdates, LinkedHashSet!(Long) accessGroupIds)
    {
        this.folderPath = folderPath;
        this.supportedFileTypes = supportedFileTypes;
        this.descriptiveMetadataSupported = descMetadataEnabled;
        this.scanForUpdates = scanForUpdates;
        this.accessGroupIds = accessGroupIds;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId()
    {
        return this.id;
    }

    public String getFolderPath()
    {
        return this.folderPath;
    }

    public Set!(MediaFileType) getSupportedFileTypes()
    {
        return this.supportedFileTypes;
    }

    protected void setSupportedFileTypes(Set!(MediaFileType) supportedFileTypes)
    {
        this.supportedFileTypes = supportedFileTypes;
    }

    public bool isDescriptiveMetadataSupported()
    {
        return this.descriptiveMetadataSupported;
    }

    protected void setDescriptiveMetadataSupported(bool descriptiveMetadataSupported)
    {
        this.descriptiveMetadataSupported = descriptiveMetadataSupported;
    }

    public bool isScanForUpdates()
    {
        return this.scanForUpdates;
    }

    protected void setScanForUpdates(bool scanForUpdates)
    {
        this.scanForUpdates = scanForUpdates;
    }

    public LinkedHashSet!(Long) getAccessGroupIds()
    {
        return this.accessGroupIds;
    }

    public void setAccessGroupIds(LinkedHashSet!(Long) accessGroupIds)
    {
        this.accessGroupIds = accessGroupIds;
    }

    override public String toString()
    {
        StringBuilder builder = new StringBuilder();
        builder.append("SharedFolder [id=").append(this.id).append(", folderPath=").append(this.folderPath).append(", scanForUpdates=").append(this.scanForUpdates).append(", supportedFileTypes=").append(this.supportedFileTypes).append(", descriptiveMetadataSupported=").append(this.descriptiveMetadataSupported).append(", accessGroupIds=").append(CollectionUtils.listToCSV(this.accessGroupIds, ",", true)).append("]");

        return builder.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.SharedFolder
* JD-Core Version:    0.7.0.1
*/