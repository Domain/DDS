module org.serviio.library.local.metadata.extractor.video.MetadataLanguages;

import java.lang.String;
import java.util.ArrayList;
import java.util.List;
import org.serviio.i18n.Language;

public class MetadataLanguages
{
    private static List!(Language) languages;
    public static immutable String DEFAULT_LANGUAGE_CODE = "en";

    static this()
    {
        languages = new ArrayList!(Language)();
        languages.add(new Language("cs", "Čeština"));
        languages.add(new Language("da", "Dansk"));
        languages.add(new Language("de", "Deutsch"));
        languages.add(new Language("el", "Ελληνικά"));
        languages.add(new Language("en", "English"));
        languages.add(new Language("es", "Español"));
        languages.add(new Language("fi", "Suomeksi"));
        languages.add(new Language("fr", "Français"));
        languages.add(new Language("he", "עברית"));
        languages.add(new Language("hr", "Hrvatski"));
        languages.add(new Language("hu", "Magyar"));
        languages.add(new Language("it", "Italiano"));
        languages.add(new Language("ja", "日本語"));
        languages.add(new Language("ko", "한국어"));
        languages.add(new Language("nl", "Nederlands"));
        languages.add(new Language("no", "Norsk"));
        languages.add(new Language("pl", "Polski"));
        languages.add(new Language("pt", "Português"));
        languages.add(new Language("ru", "Pусский язык"));
        languages.add(new Language("sl", "Slovenščina"));
        languages.add(new Language("sv", "Svenska"));
        languages.add(new Language("tr", "Türkçe"));
        languages.add(new Language("zh", "中文"));
    }

    public static List!(Language) getLanguages()
    {
        return languages;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.video.MetadataLanguages
* JD-Core Version:    0.7.0.1
*/