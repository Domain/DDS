module org.serviio.library.search.ServiioSearchAnalyzer;

import java.io.IOException;
import java.io.Reader;
import org.apache.lucene.analysis.Analyzer:TokenStreamComponents;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.Tokenizer;
import org.apache.lucene.analysis.core.LowerCaseFilter;
import org.apache.lucene.analysis.core.StopAnalyzer;
import org.apache.lucene.analysis.core.StopFilter;
import org.apache.lucene.analysis.miscellaneous.ASCIIFoldingFilter;
import org.apache.lucene.analysis.standard.StandardFilter;
import org.apache.lucene.analysis.standard.StandardTokenizer;
import org.apache.lucene.analysis.util.CharArraySet;
import org.apache.lucene.analysis.util.StopwordAnalyzerBase;
import org.apache.lucene.util.Version;

public class ServiioSearchAnalyzer : StopwordAnalyzerBase
{
    public static final int DEFAULT_MAX_TOKEN_LENGTH = 255;
    private int maxTokenLength = 255;
    public static final CharArraySet STOP_WORDS_SET = StopAnalyzer.ENGLISH_STOP_WORDS_SET;

    public this(Version matchVersion, CharArraySet stopWords)
    {
        super(matchVersion, stopWords);
    }

    public this(Version matchVersion)
    {
        this(matchVersion, STOP_WORDS_SET);
    }

    public this(Version matchVersion, Reader stopwords)
    {
        this(matchVersion, loadStopwordSet(stopwords, matchVersion));
    }

    public void setMaxTokenLength(int length)
    {
        this.maxTokenLength = length;
    }

    public int getMaxTokenLength()
    {
        return this.maxTokenLength;
    }

    protected Analyzer.TokenStreamComponents createComponents(String fieldName, Reader reader)
    {
        final StandardTokenizer src = new StandardTokenizer(this.matchVersion, reader);
        src.setMaxTokenLength(this.maxTokenLength);
        TokenStream tok = new StandardFilter(this.matchVersion, src);
        tok = new LowerCaseFilter(this.matchVersion, tok);
        tok = new StopFilter(this.matchVersion, tok, this.stopwords);
        tok = new ASCIIFoldingFilter(tok);
        new class(src, tok) Analyzer.TokenStreamComponents
        {
            protected void setReader(Reader reader)
            {
                src.setMaxTokenLength(this.outer.maxTokenLength);
                super.setReader(reader);
            }
        };
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.search.ServiioSearchAnalyzer
* JD-Core Version:    0.7.0.1
*/