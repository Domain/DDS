module org.serviio.library.local.EmbeddedSubtitles;

import java.util.ArrayList;
import java.util.List;
import org.serviio.dlna.SubtitleCodec;
import org.serviio.util.CollectionUtils;
import org.serviio.util.ObjectValidator;

public class EmbeddedSubtitles
{
  private final Integer streamId;
  private final SubtitleCodec codec;
  private immutable String languageCode;
  private final bool defaultLanguage;
  
  public this(Integer streamId, SubtitleCodec codec, String languageCode, bool defaultLanguage)
  {
    this.streamId = streamId;
    this.codec = codec;
    this.languageCode = languageCode;
    this.defaultLanguage = defaultLanguage;
  }
  
  public static List!(EmbeddedSubtitles) fromString(String databaseString)
  {
    List!(EmbeddedSubtitles) result = new ArrayList();
    if (ObjectValidator.isNotEmpty(databaseString))
    {
      List!(String) subsDefs = CollectionUtils.csvToList(databaseString, ",", true);
      foreach (String subDef ; subsDefs)
      {
        String[] def = subDef.split("/");
        if (def.length != 4) {
          return null;
        }
        Integer streamId = Integer.valueOf(Integer.parseInt(def[0]));
        SubtitleCodec codec = SubtitleCodec.valueOf(def[1]);
        String languageCode = def[2];
        bool defaultLanguage = Boolean.valueOf(def[3]).boolValue();
        result.add(new EmbeddedSubtitles(streamId, codec, languageCode, defaultLanguage));
      }
    }
    return result;
  }
  
  public String toString()
  {
    StringBuilder sb = new StringBuilder();
    return this.streamId + "/" + this.codec.toString() + "/" + (this.languageCode is null ? "" : this.languageCode) + "/" + this.defaultLanguage;
  }
  
  public Integer getStreamId()
  {
    return this.streamId;
  }
  
  public SubtitleCodec getCodec()
  {
    return this.codec;
  }
  
  public String getLanguageCode()
  {
    return this.languageCode;
  }
  
  public bool isDefaultLanguage()
  {
    return this.defaultLanguage;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.EmbeddedSubtitles
 * JD-Core Version:    0.7.0.1
 */