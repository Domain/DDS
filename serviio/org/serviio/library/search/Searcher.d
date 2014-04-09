module org.serviio.library.search.Searcher;

import java.lang.String;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.MultiReader;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.BooleanClause:Occur;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.WildcardQuery;
import org.apache.lucene.util.Version;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.util.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.serviio.library.search.SearchIndexer;
import org.serviio.library.search.SearchIndexer:SearchCategory;
import org.serviio.library.search.SearchResultsHolder;

public class Searcher
{
    private static Logger log;
    private static Map!(MediaFileType, List!(SearchCategory)) categoryMapping;
    private MultiReader ireader;
    private DirectoryReader[] subReaders;

    static this()
    {
        log = LoggerFactory.getLogger!(Searcher);
        categoryMapping = new HashMap!(MediaFileType, List!(SearchCategory))();
        categoryMapping.put(MediaFileType.VIDEO, Arrays.asList(cast(SearchCategory[])[ SearchCategory.MOVIES, SearchCategory.SERIES, SearchCategory.EPISODES, SearchCategory.FILES, SearchCategory.FOLDERS, SearchCategory.ONLINE_ITEMS, SearchCategory.ONLINE_CONTAINERS ]));
        categoryMapping.put(MediaFileType.IMAGE, Arrays.asList(cast(SearchCategory[])[ SearchCategory.FILES, SearchCategory.FOLDERS, SearchCategory.ONLINE_ITEMS, SearchCategory.ONLINE_CONTAINERS ]));
        categoryMapping.put(MediaFileType.AUDIO, Arrays.asList(cast(SearchCategory[])[ SearchCategory.ALBUM_ARTISTS, SearchCategory.ALBUMS, SearchCategory.MUSIC_TRACKS, SearchCategory.FILES, SearchCategory.FOLDERS, SearchCategory.ONLINE_ITEMS, SearchCategory.ONLINE_CONTAINERS ]));
    }

    public this(SearchIndexer[] indexers...)
    {
        this.subReaders = new DirectoryReader[indexers.length];
        for (int i = 0; i < indexers.length; i++)
        {
            IndexWriter writer = indexers[i].getWriter();
            this.subReaders[i] = DirectoryReader.open(writer, true);
        }
        this.ireader = new MultiReader(this.subReaders, true);
    }

    public List!(SearchResultsHolder) search(String term, MediaFileType fileType, int offset, int count)
    {
        log.debug_(java.lang.String.format("Performing search for term '%s'", cast(Object[])[ term ]));
        openReader();
        IndexSearcher isearcher = new IndexSearcher(this.ireader);
        List!(SearchResultsHolder) results = new ArrayList();
        foreach (SearchCategory category ; cast(List)categoryMapping.get(fileType)) {
            results.add(runSearchForCategory(isearcher, category, fileType, term, offset, count));
        }
        return results;
    }

    public void close()
    {
        try
        {
            this.ireader.close();
        }
        catch (IOException e)
        {
            log.warn("Failed to close index reader", e);
        }
    }

    private SearchResultsHolder runSearchForCategory(IndexSearcher isearcher, SearchCategory category, MediaFileType fileType, String term, int offset, int count)
    {
        BooleanQuery termQuery = new BooleanQuery();

        List!(String) termParts = tokenizeQuery(term);
        foreach (String termPart ; termParts) {
            termQuery.add(new WildcardQuery(new Term("value", termPart.trim() + "*")), BooleanClause.Occur.MUST);
        }
        BooleanQuery query = new BooleanQuery();
        query.add(new TermQuery(new Term("fileType", fileType.toString())), BooleanClause.Occur.MUST);
        query.add(new WildcardQuery(new Term("category", category.toString())), BooleanClause.Occur.MUST);
        query.add(termQuery, BooleanClause.Occur.MUST);

        TopDocs result = isearcher.search(query, count + offset);
        List!(SearchResult) foundItems = new ArrayList();
        List!(ScoreDoc) hits = CollectionUtils.getSubList(Arrays.asList(result.scoreDocs), offset, count);
        foreach (ScoreDoc doc ; hits) {
            foundItems.add(SearchResult.fromDoc(isearcher.doc(doc.doc)));
        }
        SearchResultsHolder holder = new SearchResultsHolder();
        holder.setTotalMatched(result.totalHits);
        holder.setCategory(category);
        holder.setItems(foundItems);
        return holder;
    }

    private void openReader()
    {
        bool changed = false;
        for (int i = 0; i < this.subReaders.length; i++)
        {
            DirectoryReader originalReader = this.subReaders[i];
            DirectoryReader updatedIndexReader = DirectoryReader.openIfChanged(originalReader);
            if (updatedIndexReader !is null)
            {
                changed = true;
                this.subReaders[i] = updatedIndexReader;
            }
        }
        if (changed) {
            this.ireader = new MultiReader(this.subReaders);
        }
    }

    private List!(String) tokenizeQuery(String term)
    {
        List!(String) query = new ArrayList();
        Analyzer analyzer = new ServiioSearchAnalyzer(Version.LUCENE_44);
        TokenStream tokenStream = analyzer.tokenStream("value", new StringReader(term));
        CharTermAttribute termAtt = cast(CharTermAttribute)tokenStream.addAttribute(CharTermAttribute.class_);
        try
        {
            tokenStream.reset();
            while (tokenStream.incrementToken()) {
                query.add(termAtt.toString());
            }
            tokenStream.end();
        }
        finally
        {
            tokenStream.close();
            analyzer.close();
        }
        return query;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.Searcher
* JD-Core Version:    0.7.0.1
*/