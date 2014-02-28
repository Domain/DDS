module org.serviio.library.search.SearchIndexer;

import java.io.File;
import java.io.IOException;
import java.util.List;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.FieldType;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.IndexWriterConfig:OpenMode;
import org.apache.lucene.index.LiveIndexWriterConfig;
import org.apache.lucene.index.Term;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.store.RAMDirectory;
import org.apache.lucene.util.Version;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.definition.ActionNode;
import org.serviio.upnp.service.contentdirectory.definition.Definition;
import org.serviio.util.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchIndexer
{
    public static enum SearchCategory
    {
        MOVIES,  EPISODES,  SERIES,  ALBUMS,  MUSIC_TRACKS,  ALBUM_ARTISTS,  FOLDERS,  FILES,  ONLINE_CONTAINERS,  ONLINE_ITEMS
    }

    private static final Logger log = LoggerFactory.getLogger!(SearchIndexer);
    private bool inMemory;
    private final FieldType indexedTokenizedStored;
    private final FieldType storedNotIndexed;
    private final FieldType storedIndexed;
    private final IndexWriter writer;
    private final Directory directory;

    public this(bool inMemory)
    {
        this.inMemory = inMemory;

        this.indexedTokenizedStored = new FieldType(TextField.TYPE_STORED);

        this.storedIndexed = new FieldType(StringField.TYPE_STORED);

        this.storedNotIndexed = new FieldType();
        this.storedNotIndexed.setStored(true);
        this.storedNotIndexed.setIndexed(false);
        this.storedNotIndexed.setTokenized(false);
        this.storedNotIndexed.setStoreTermVectors(false);

        this.directory = startDirectory();
        this.writer = startIndexWriter();
        this.writer.commit();
    }

    public void metadataAdded(SearchMetadata searchMetadata)
    {
        log.debug_(String.format("Adding term '%s' to search index", cast(Object[])[ searchMetadata.getSearchableValue() ]));
        Definition definition = Definition.instance();
        List!(ActionNode) nodes = definition.findNodesForSearchCategory(searchMetadata.getCategory());
        foreach (ActionNode node ; nodes) {
            try
            {
                addItemToIndex(searchMetadata, node, this.writer);
            }
            catch (IOException e)
            {
                log.warn(String.format("Could not add entry '%s' to search index: %s", cast(Object[])[ searchMetadata.getSearchableValue(), e.getMessage() ]));
            }
        }
    }

    public void metadataRemoved(SearchCategory category, Long entityId)
    {
        String indexId = AbstractSearchMetadata.generateIndexId(category, entityId);
        metadataRemoved("id", indexId);
    }

    public void metadataRemoved(String field, String value)
    {
        log.debug_(String.format("Removing documents with '%s' of '%s' from search index", cast(Object[])[ field, value ]));
        try
        {
            this.writer.deleteDocuments(new Term(field, value));
        }
        catch (IOException e)
        {
            log.warn(String.format("Could not remove entry with %s '%s' from search index: %s", cast(Object[])[ field, value, e.getMessage() ]));
        }
    }

    public IndexWriter getWriter()
    {
        return this.writer;
    }

    public void deleteIndexEntries()
    {
        try
        {
            this.writer.deleteAll();
            this.writer.commit();
        }
        catch (IOException e)
        {
            log.warn("Failed to delete index entries", e);
        }
    }

    public void close()
    {
        log.info("Closing search index writer");
        try
        {
            this.writer.close();
            this.directory.close();
        }
        catch (IOException e)
        {
            log.warn("Failed to close index writer", e);
        }
    }

    private synchronized void addItemToIndex(SearchMetadata searchMetadata, ActionNode node, IndexWriter writer)
    {
        Document doc = new Document();
        try
        {
            addField(doc, "cdsObjectId", searchMetadata.generateCDSIdentifier(node), this.storedNotIndexed);
            addField(doc, "cdsParentId", searchMetadata.generateCDSParentIdentifier(node), this.storedNotIndexed);
            addField(doc, "id", searchMetadata.getIndexId(), this.storedIndexed);
            addField(doc, "entityId", searchMetadata.getEntityId().toString(), this.storedNotIndexed);
            addField(doc, "fileType", searchMetadata.getFileType().toString(), this.storedIndexed);
            addField(doc, "category", searchMetadata.getCategory().toString(), this.storedIndexed);
            addField(doc, "value", searchMetadata.getSearchableValue(), this.indexedTokenizedStored);
            addField(doc, "objectType", searchMetadata.getObjectType().toString(), this.storedNotIndexed);
            if (searchMetadata.getThumbnailId() !is null) {
                addField(doc, "thumbnailId", searchMetadata.getThumbnailId().toString(), this.storedNotIndexed);
            }
            if (searchMetadata.getContext().size() > 0) {
                addField(doc, "context", CollectionUtils.listToCSV(searchMetadata.getContext(), "/", true), this.storedNotIndexed);
            }
            if (searchMetadata.getOnlineRepositoryId() !is null) {
                addField(doc, "onlineRepoId", searchMetadata.getOnlineRepositoryId().toString(), this.storedIndexed);
            }
            if (writer.getConfig().getOpenMode() == IndexWriterConfig.OpenMode.CREATE) {
                writer.addDocument(doc);
            } else {
                writer.updateDocument(new Term("id", searchMetadata.getIndexId()), doc);
            }
        }
        catch (CommandNotSuitableForSearchMetadataException e) {}
    }

    private void addField(Document doc, String fieldName, String value, FieldType type)
    {
        Field pathField = new Field(fieldName, value, type);
        doc.add(pathField);
    }

    private IndexWriter startIndexWriter()
    {
        Analyzer analyzer = new ServiioSearchAnalyzer(Version.LUCENE_44);
        IndexWriterConfig iwc = new IndexWriterConfig(Version.LUCENE_44, analyzer);
        iwc.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
        if (IndexWriter.isLocked(this.directory)) {
            IndexWriter.unlock(this.directory);
        }
        return new IndexWriter(this.directory, iwc);
    }

    private Directory startDirectory()
    {
        return this.inMemory ? new RAMDirectory() : FSDirectory.open(getSearchIndexFilePath());
    }

    private File getSearchIndexFilePath()
    {
        return new File(System.getProperty("serviio.home"), "library/search");
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.SearchIndexer
* JD-Core Version:    0.7.0.1
*/