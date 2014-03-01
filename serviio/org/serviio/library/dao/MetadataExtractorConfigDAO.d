module org.serviio.library.dao.MetadataExtractorConfigDAO;

import java.lang.Long;
import java.util.List;
import org.serviio.db.dao.InvalidArgumentException;
import org.serviio.db.dao.PersistenceException;
import org.serviio.library.entities.MetadataExtractorConfig;
import org.serviio.library.metadata.MediaFileType;

public abstract interface MetadataExtractorConfigDAO
{
    public abstract long create(MetadataExtractorConfig paramMetadataExtractorConfig);

    public abstract void delete_(Long paramLong);

    public abstract List!(MetadataExtractorConfig) retrieveByMediaFileType(MediaFileType paramMediaFileType);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.MetadataExtractorConfigDAO
* JD-Core Version:    0.7.0.1
*/