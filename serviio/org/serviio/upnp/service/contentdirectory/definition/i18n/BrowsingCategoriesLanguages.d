module org.serviio.upnp.service.contentdirectory.definition.i18n.BrowsingCategoriesLanguages;

import java.util.ArrayList;
import java.util.List;
import org.serviio.i18n.Language;

public class BrowsingCategoriesLanguages
{
  public static immutable String DEFAULT_LANGUAGE_CODE = "en";
  private static List!(Language) languages = new ArrayList();
  
  static this()
  {
    languages.add(new Language("ar", "العربية"));
    languages.add(new Language("bg", "български език"));
    languages.add(new Language("ca", "Català"));
    languages.add(new Language("cs", "Čeština"));
    languages.add(new Language("da", "Dansk"));
    languages.add(new Language("de", "Deutsch"));
    languages.add(new Language("en", "English"));
    languages.add(new Language("es", "Español"));
    languages.add(new Language("es-419", "Español (Latin America)"));
    languages.add(new Language("el", "ελληνικά"));
    languages.add(new Language("et-EE", "Eesti"));
    languages.add(new Language("fi", "Suomi"));
    languages.add(new Language("fr", "Français"));
    languages.add(new Language("gsw-CH", "Schwyzerdütsch"));
    languages.add(new Language("he", "עברית"));
    languages.add(new Language("hr", "Hrvatski"));
    languages.add(new Language("hu", "Magyar"));
    languages.add(new Language("id", "Bahasa Indonesia"));
    languages.add(new Language("it", "Italiano"));
    languages.add(new Language("ja-JP", "日本語"));
    languages.add(new Language("ko", "한국어"));
    languages.add(new Language("lt", "Lietuvių kalba"));
    languages.add(new Language("lv", "Latviešu valoda"));
    languages.add(new Language("nl", "Nederlands"));
    languages.add(new Language("nl-BE", "Nederlands (Belgium)"));
    languages.add(new Language("no", "Norsk"));
    languages.add(new Language("pl", "Polski"));
    languages.add(new Language("pt-PT", "Português"));
    languages.add(new Language("pt-BR", "Português (Brazil)"));
    languages.add(new Language("ro", "Română"));
    languages.add(new Language("ru", "Pусский язык"));
    languages.add(new Language("sk", "Slovenčina"));
    languages.add(new Language("sl", "Slovenščina"));
    languages.add(new Language("sv", "Svenska"));
    languages.add(new Language("sr", "српски језик"));
    languages.add(new Language("ta", "தமிழ்"));
    languages.add(new Language("tr", "Türkçe"));
    languages.add(new Language("uk", "українська мова"));
    languages.add(new Language("zh-CN", "中文 (Simplified)"));
    languages.add(new Language("zh-HK", "中文 (Traditional)"));
  }
  
  public static List!(Language) getLanguages()
  {
    return languages;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.i18n.BrowsingCategoriesLanguages
 * JD-Core Version:    0.7.0.1
 */